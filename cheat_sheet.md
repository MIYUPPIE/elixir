# Quick Reference Cheat Sheet

## Data Types
```elixir
# Numbers
42                    # integer
3.14                  # float
1_000_000             # integer with underscores

# Strings  
"hello"               # string
'hello'               # charlist
"""                   # multiline string
multiline
"""

# Atoms
:ok                   # atom
:error                # atom
:"hello world"        # atom with spaces

# Collections
{1, 2}                # tuple
[1, 2, 3]             # list
%{key: "value"}       # map
[key: "value"]        # keyword list
```

## Pattern Matching
```elixir
{:ok, result} = {:ok, "success"}
[head | tail] = [1, 2, 3]
%{name: n} = %{name: "Alice", age: 30}
^x = y                # pin operator - match existing value
```

## Functions
```elixir
# Anonymous
fn x -> x * 2 end
&(&1 * 2)             # shorthand

# Named
def add(a, b), do: a + b
def add(a, b) do
  a + b
end

# Multiple clauses
def greet(:morning), do: "Good morning"
def greet(:evening), do: "Good evening"

# Guards
def factorial(n) when n > 0, do: n * factorial(n - 1)
```

## Control Flow
```elixir
# if/unless
if condition, do: "yes", else: "no"

# case
case value do
  {:ok, result} -> result
  {:error, _} -> "error"
  _ -> "other"
end

# cond
cond do
  age < 13 -> "child"
  age < 20 -> "teenager" 
  true -> "adult"
end

# with
with {:ok, a} <- step1(),
     {:ok, b} <- step2(a),
     {:ok, c} <- step3(b) do
  {:ok, c}
else
  error -> error
end
```

## Common Enum Functions
```elixir
Enum.map(list, fn x -> x * 2 end)
Enum.filter(list, &(&1 > 0))
Enum.reduce(list, 0, &+/2)
Enum.find(list, &(&1 > 5))
Enum.group_by(words, &String.first/1)
Enum.chunk_every(list, 3)
Enum.zip(list1, list2)
```

## Process Basics
```elixir
# Spawn
pid = spawn(fn -> IO.puts("hello") end)

# Send/receive
send(pid, {:hello, "world"})
receive do
  {:hello, msg} -> IO.puts(msg)
after
  1000 -> IO.puts("timeout")
end

# Self
my_pid = self()
```

## GenServer Template
```elixir
defmodule MyServer do
  use GenServer
  
  # Client API
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end
  
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end
  
  def update_state(new_state) do
    GenServer.cast(__MODULE__, {:update, new_state})
  end
  
  # Server callbacks
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end
  
  @impl true  
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  
  @impl true
  def handle_cast({:update, new_state}, _state) do
    {:noreply, new_state}
  end
end
```

## Mix Commands
```bash
mix new project_name          # Create new project
mix deps.get                  # Get dependencies
mix compile                   # Compile project
mix test                      # Run tests
mix format                    # Format code
iex -S mix                    # Interactive shell with project
mix run script.exs            # Run script
mix escript.build             # Build executable
```

## Common Patterns

### Result Tuples
```elixir
{:ok, data}
{:error, reason}
{:noreply, new_state}
```

### Pipe Operator
```elixir
data
|> String.trim()
|> String.downcase()  
|> String.split(" ")
|> Enum.map(&String.capitalize/1)
```

### Error Handling
```elixir
case risky_operation() do
  {:ok, result} -> process(result)
  {:error, reason} -> handle_error(reason)
end
```

## Testing
```elixir
defmodule MyTest do
  use ExUnit.Case
  doctest MyModule
  
  test "description" do
    assert actual == expected
    refute actual == wrong
  end
  
  describe "group of tests" do
    setup do
      %{data: "test data"}
    end
    
    test "test with setup", %{data: data} do
      assert data == "test data"
    end
  end
end
```

## Useful Standard Library
```elixir
# String
String.length("hello")
String.upcase("hello")
String.split("a,b,c", ",")

# Enum  
Enum.count([1,2,3])
Enum.sort([3,1,2])
Enum.uniq([1,1,2,2,3])

# Map
Map.get(map, :key)
Map.put(map, :key, value) 
Map.update(map, :key, default, fn x -> x + 1 end)

# Process
Process.alive?(pid)
Process.monitor(pid)
Process.send_after(pid, message, 1000)
```

Keep this handy while coding! 📌
