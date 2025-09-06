# Concurrency: Processes and the Actor Model

Elixir's greatest strength is its concurrency model based on the Actor model. Everything runs in lightweight processes that communicate via message passing.

## Understanding Processes

Elixir processes are NOT operating system threads:
- **Lightweight** - Start in microseconds, use very little memory
- **Isolated** - Share no memory, crash independently  
- **Cheap** - You can have millions on a single machine
- **Communicate via messages** - No shared state

## Spawning Processes

```elixir
# Spawn a simple process
pid = spawn(fn -> IO.puts("Hello from process!") end)

# Spawn and get the result
parent = self()
spawn(fn -> 
  result = 2 + 2
  send(parent, {:result, result})
end)

receive do
  {:result, value} -> IO.puts("Got result: #{value}")
end
```

## Message Passing

```elixir
defmodule MessageExample do
  def start_receiver do
    spawn(fn -> receive_loop() end)
  end
  
  defp receive_loop do
    receive do
      {:hello, name} -> 
        IO.puts("Hello, #{name}!")
        receive_loop()
      
      {:math, operation, a, b} ->
        result = case operation do
          :add -> a + b
          :multiply -> a * b
          :subtract -> a - b
        end
        IO.puts("#{operation}(#{a}, #{b}) = #{result}")
        receive_loop()
      
      :stop -> 
        IO.puts("Stopping receiver")
      
      other -> 
        IO.puts("Unknown message: #{inspect(other)}")
        receive_loop()
    end
  end
end

# Usage
receiver_pid = MessageExample.start_receiver()
send(receiver_pid, {:hello, "Alice"})
send(receiver_pid, {:math, :add, 5, 3})
send(receiver_pid, :stop)
```

## Process Registry and Naming

```elixir
# Register a process with a name
defmodule NamedProcess do
  def start do
    pid = spawn(fn -> loop() end)
    Process.register(pid, :my_server)
    pid
  end
  
  defp loop do
    receive do
      {:request, from, data} ->
        send(from, {:response, "Processed: #{data}"})
        loop()
      :stop ->
        :ok
    end
  end
  
  def request(data) do
    send(:my_server, {:request, self(), data})
    receive do
      {:response, result} -> result
    after
      5000 -> :timeout
    end
  end
end

# Usage
NamedProcess.start()
NamedProcess.request("Hello")
```

## Process Monitoring and Linking

```elixir
defmodule ProcessSupervision do
  def start_monitored_worker do
    # Monitor - receive a message when process dies
    {pid, ref} = spawn_monitor(fn -> 
      :timer.sleep(1000)
      raise "Something went wrong!"
    end)
    
    receive do
      {:DOWN, ^ref, :process, ^pid, reason} ->
        IO.puts("Process died: #{reason}")
    end
  end
  
  def start_linked_worker do
    # Link - if linked process dies, this one dies too
    spawn_link(fn -> 
      :timer.sleep(1000)
      raise "Linked process failed!"
    end)
    
    # This will also crash when the linked process crashes
    :timer.sleep(2000)
    IO.puts("This won't print")
  end
end
```

## Agent: Simple State Management

Agents provide simple state management:

```elixir
# Start an agent with initial state
{:ok, counter_pid} = Agent.start_link(fn -> 0 end)

# Update state
Agent.update(counter_pid, &(&1 + 1))
Agent.update(counter_pid, &(&1 + 5))

# Get state
count = Agent.get(counter_pid, &(&1))
IO.puts("Current count: #{count}")

# Named agents
{:ok, _} = Agent.start_link(fn -> %{} end, name: :cache)
Agent.update(:cache, &Map.put(&1, :key, "value"))
value = Agent.get(:cache, &Map.get(&1, :key))
```

## Task: Async Work

Tasks are great for async operations:

```elixir
# Start an async task
task = Task.async(fn ->
  :timer.sleep(1000)
  "Async work completed"
end)

# Do other work while task runs
IO.puts("Doing other work...")

# Wait for task result
result = Task.await(task)
IO.puts(result)

# Multiple async tasks
tasks = for i <- 1..5 do
  Task.async(fn ->
    :timer.sleep(100 * i)
    "Task #{i} done"
  end)
end

results = Task.await_many(tasks)
IO.inspect(results)
```

## GenServer: Stateful Server Process

GenServer provides a standard way to build stateful processes:

```elixir
defmodule Counter do
  use GenServer

  # Client API
  def start_link(initial_value \\ 0) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  def increment_by(value) do
    GenServer.call(__MODULE__, {:increment_by, value})
  end

  # Server callbacks
  @impl true
  def init(initial_value) do
    {:ok, initial_value}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:increment_by, value}, _from, state) do
    new_state = state + value
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end
end

# Usage
{:ok, _pid} = Counter.start_link(10)
IO.puts("Initial: #{Counter.get()}")
Counter.increment()
IO.puts("After increment: #{Counter.get()}")
new_value = Counter.increment_by(5)
IO.puts("After increment_by(5): #{new_value}")
```

## Process Communication Patterns

### Request-Response
```elixir
defmodule Calculator do
  def start do
    spawn(fn -> loop() end)
  end
  
  defp loop do
    receive do
      {:add, a, b, from} ->
        send(from, {:result, a + b})
        loop()
      
      {:multiply, a, b, from} ->
        send(from, {:result, a * b})
        loop()
    end
  end
  
  def add(pid, a, b) do
    send(pid, {:add, a, b, self()})
    receive do
      {:result, value} -> value
    after
      5000 -> :timeout
    end
  end
end
```

### Publish-Subscribe
```elixir
defmodule PubSub do
  def start do
    spawn(fn -> loop([]) end)
  end
  
  defp loop(subscribers) do
    receive do
      {:subscribe, pid} ->
        loop([pid | subscribers])
      
      {:publish, message} ->
        Enum.each(subscribers, &send(&1, {:notification, message}))
        loop(subscribers)
      
      {:unsubscribe, pid} ->
        loop(List.delete(subscribers, pid))
    end
  end
end
```

## Fault Tolerance

The "let it crash" philosophy:

```elixir
defmodule WorkerProcess do
  def start_supervised do
    # Start a process that might crash
    spawn_link(fn -> risky_work() end)
  end
  
  defp risky_work do
    # Simulate work that might fail
    if :rand.uniform() < 0.3 do
      raise "Random failure!"
    else
      IO.puts("Work completed successfully")
    end
    
    :timer.sleep(1000)
    risky_work()  # Keep working
  end
end

# In a real application, this would be supervised
```

## Process Performance Tips

1. **Processes are cheap** - Don't hesitate to create many
2. **Keep process state small** - Large state slows message processing
3. **Use timeouts** - Always set timeouts for receive blocks
4. **Monitor critical processes** - Use monitoring for fault tolerance
5. **Avoid shared state** - Use message passing instead

## Next Steps

This is where Elixir truly shines! Practice these concurrency concepts, then move to `13_otp/` to learn about OTP behaviors and building robust, fault-tolerant systems!
