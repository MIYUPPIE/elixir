# OTP: Open Telecom Platform

OTP is a set of libraries, design principles, and behaviors that make it easy to build fault-tolerant, distributed applications. It's the secret sauce that makes Elixir/Erlang so powerful for building robust systems.

## OTP Behaviors

OTP provides several standard behaviors (patterns):

### GenServer - Generic Server
For stateful processes that handle synchronous and asynchronous requests.

### Supervisor - Process Supervision
For monitoring and restarting child processes when they crash.

### Application - Application Management
For defining and starting applications with their dependencies.

### Agent - Simple State
For simple state management (wrapper around GenServer).

### Task - Async Computation
For one-off async computations.

## GenServer Deep Dive

```elixir
defmodule BankAccount do
  use GenServer
  
  # Client API
  def start_link(initial_balance \\ 0) do
    GenServer.start_link(__MODULE__, initial_balance)
  end
  
  def balance(pid) do
    GenServer.call(pid, :balance)
  end
  
  def deposit(pid, amount) when amount > 0 do
    GenServer.call(pid, {:deposit, amount})
  end
  
  def withdraw(pid, amount) when amount > 0 do
    GenServer.call(pid, {:withdraw, amount})
  end
  
  def transfer(from_pid, to_pid, amount) do
    with {:ok, _} <- withdraw(from_pid, amount),
         {:ok, _} <- deposit(to_pid, amount) do
      {:ok, "Transfer completed"}
    else
      error -> error
    end
  end
  
  # Server Callbacks
  @impl true
  def init(initial_balance) do
    {:ok, %{balance: initial_balance, transactions: []}}
  end
  
  @impl true
  def handle_call(:balance, _from, state) do
    {:reply, state.balance, state}
  end
  
  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    new_balance = state.balance + amount
    transaction = {:deposit, amount, DateTime.utc_now()}
    new_state = %{
      balance: new_balance,
      transactions: [transaction | state.transactions]
    }
    {:reply, {:ok, new_balance}, new_state}
  end
  
  @impl true
  def handle_call({:withdraw, amount}, _from, state) do
    if state.balance >= amount do
      new_balance = state.balance - amount
      transaction = {:withdraw, amount, DateTime.utc_now()}
      new_state = %{
        balance: new_balance,
        transactions: [transaction | state.transactions]
      }
      {:reply, {:ok, new_balance}, new_state}
    else
      {:reply, {:error, "Insufficient funds"}, state}
    end
  end
  
  @impl true
  def handle_info(:timeout, state) do
    IO.puts("Account timeout - balance: #{state.balance}")
    {:noreply, state}
  end
end
```

## Supervisors

Supervisors monitor and restart child processes:

```elixir
defmodule BankSupervisor do
  use Supervisor
  
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end
  
  @impl true
  def init(:ok) do
    children = [
      # Static children
      {BankAccount, [1000]},
      {Registry, keys: :unique, name: AccountRegistry},
      
      # Dynamic children via DynamicSupervisor
      {DynamicSupervisor, name: AccountDynamicSupervisor, strategy: :one_for_one}
    ]
    
    # Supervision strategies:
    # :one_for_one - restart only the failed child
    # :one_for_all - restart all children if one fails
    # :rest_for_one - restart failed child and children started after it
    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

### Dynamic Supervision

```elixir
defmodule AccountManager do
  def create_account(account_id, initial_balance \\ 0) do
    child_spec = {BankAccount, [initial_balance]}
    
    case DynamicSupervisor.start_child(AccountDynamicSupervisor, child_spec) do
      {:ok, pid} -> 
        Registry.register(AccountRegistry, account_id, pid)
        {:ok, pid}
      error -> 
        error
    end
  end
  
  def get_account(account_id) do
    case Registry.lookup(AccountRegistry, account_id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :account_not_found}
    end
  end
  
  def close_account(account_id) do
    case get_account(account_id) do
      {:ok, pid} ->
        DynamicSupervisor.terminate_child(AccountDynamicSupervisor, pid)
        {:ok, "Account closed"}
      error ->
        error
    end
  end
end
```

## Application Behavior

Applications define how your system starts up:

```elixir
defmodule MyBank.Application do
  use Application
  
  @impl true
  def start(_type, _args) do
    children = [
      # Start the main supervisor
      BankSupervisor,
      
      # Start a web server (if using Phoenix)
      MyBankWeb.Endpoint,
      
      # Start background workers
      {MyBank.TransactionProcessor, []},
      
      # Start monitoring
      {MyBank.HealthChecker, []}
    ]
    
    opts = [strategy: :one_for_one, name: MyBank.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  # Called when application is stopping
  @impl true
  def stop(_state) do
    IO.puts("MyBank application stopping...")
    :ok
  end
end
```

## GenServer State Patterns

### State as a Map
```elixir
defmodule UserSession do
  use GenServer
  
  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via_tuple(user_id))
  end
  
  # Client API
  def login(user_id, credentials) do
    GenServer.call(via_tuple(user_id), {:login, credentials})
  end
  
  def logout(user_id) do
    GenServer.cast(via_tuple(user_id), :logout)
  end
  
  def get_session(user_id) do
    GenServer.call(via_tuple(user_id), :get_session)
  end
  
  # Registry naming pattern
  defp via_tuple(user_id) do
    {:via, Registry, {UserRegistry, user_id}}
  end
  
  # Server callbacks
  @impl true
  def init(user_id) do
    initial_state = %{
      user_id: user_id,
      logged_in: false,
      login_time: nil,
      last_activity: DateTime.utc_now()
    }
    {:ok, initial_state}
  end
  
  @impl true
  def handle_call({:login, credentials}, _from, state) do
    if authenticate(credentials) do
      new_state = %{state | 
        logged_in: true,
        login_time: DateTime.utc_now(),
        last_activity: DateTime.utc_now()
      }
      {:reply, {:ok, "Logged in"}, new_state}
    else
      {:reply, {:error, "Invalid credentials"}, state}
    end
  end
  
  @impl true
  def handle_call(:get_session, _from, state) do
    {:reply, state, %{state | last_activity: DateTime.utc_now()}}
  end
  
  @impl true
  def handle_cast(:logout, state) do
    new_state = %{state | logged_in: false, login_time: nil}
    {:noreply, new_state}
  end
  
  # Handle process messages
  @impl true
  def handle_info(:timeout_check, state) do
    if session_expired?(state) do
      {:stop, :normal, state}
    else
      schedule_timeout_check()
      {:noreply, state}
    end
  end
  
  defp authenticate(_credentials), do: true  # Simplified
  
  defp session_expired?(state) do
    if state.login_time do
      DateTime.diff(DateTime.utc_now(), state.last_activity, :minute) > 30
    else
      false
    end
  end
  
  defp schedule_timeout_check do
    Process.send_after(self(), :timeout_check, 60_000)  # Check every minute
  end
end
```

## Supervision Trees

Build robust systems with nested supervisors:

```elixir
defmodule MyApp.Application do
  use Application
  
  def start(_type, _args) do
    children = [
      # Core services supervisor
      {MyApp.CoreSupervisor, []},
      
      # Web interface supervisor  
      {MyApp.WebSupervisor, []},
      
      # Background jobs supervisor
      {MyApp.JobsSupervisor, []}
    ]
    
    opts = [strategy: :one_for_one, name: MyApp.RootSupervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyApp.CoreSupervisor do
  use Supervisor
  
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: MyApp.Registry},
      {MyApp.UserManager, []},
      {MyApp.SessionManager, []},
      {MyApp.Cache, []}
    ]
    
    Supervisor.init(children, strategy: :one_for_all)
  end
end
```

## Error Kernel Pattern

Keep critical code small and simple:

```elixir
# Error kernel - simple, critical code
defmodule CriticalData do
  use GenServer
  
  def start_link(data) do
    GenServer.start_link(__MODULE__, data, name: __MODULE__)
  end
  
  def get_data do
    GenServer.call(__MODULE__, :get_data)
  end
  
  def init(data), do: {:ok, data}
  
  def handle_call(:get_data, _from, state) do
    {:reply, state, state}
  end
end

# Complex workers that can crash
defmodule ComplexWorker do
  def process_data do
    # Get critical data from error kernel
    data = CriticalData.get_data()
    
    # Do complex, crash-prone work
    perform_complex_operations(data)
  end
  
  defp perform_complex_operations(data) do
    # This might crash, but that's OK!
    # The supervisor will restart this process
    # while the critical data remains safe
    data
    |> transform()
    |> validate()
    |> save_to_database()
  end
end
```

## Next Steps

OTP is the heart of building production Elixir systems. Practice these patterns, then move to `14_metaprogramming/` to learn about macros and compile-time code generation!
