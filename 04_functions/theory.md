# Functions and Modules in Elixir

## Anonymous Functions (Lambdas)

Anonymous functions are defined with `fn` and called with a dot `.`:

```elixir
# Basic anonymous function
add = fn a, b -> a + b end
result = add.(5, 3)  # 8

# Multiple clauses with pattern matching
process = fn
  {:ok, data} -> "Success: #{data}"
  {:error, reason} -> "Error: #{reason}"
  _ -> "Unknown result"
end

process.({:ok, "Data loaded"})  # "Success: Data loaded"
```

## Named Functions and Modules

Modules group related functions together:

```elixir
defmodule Calculator do
  # Public function
  def add(a, b) do
    a + b
  end

  # Function with multiple clauses
  def divide(a, 0), do: {:error, "Cannot divide by zero"}
  def divide(a, b), do: {:ok, a / b}

  # Private function (only usable within this module)
  defp validate_number(n) when is_number(n), do: :ok
  defp validate_number(_), do: :error
end

# Using the module
Calculator.add(5, 3)      # 8
Calculator.divide(10, 2)  # {:ok, 5.0}
Calculator.divide(10, 0)  # {:error, "Cannot divide by zero"}
```

## Function Features

### Default Parameters
```elixir
defmodule Greeter do
  def hello(name \\ "World") do
    "Hello, #{name}!"
  end
end

Greeter.hello()        # "Hello, World!"
Greeter.hello("Alice") # "Hello, Alice!"
```

### Guards
```elixir
defmodule MathHelper do
  def factorial(0), do: 1
  def factorial(n) when is_integer(n) and n > 0 do
    n * factorial(n - 1)
  end
  
  def is_even(n) when rem(n, 2) == 0, do: true
  def is_even(n) when rem(n, 2) == 1, do: false
end
```

### Multiple Clauses with Pattern Matching
```elixir
defmodule ListProcessor do
  # Empty list
  def process_list([]) do
    "Empty list"
  end
  
  # Single element
  def process_list([item]) do
    "Single item: #{item}"
  end
  
  # Multiple elements
  def process_list([head | tail]) do
    "Head: #{head}, Tail length: #{length(tail)}"
  end
end
```

## Function Capture and Higher-Order Functions

```elixir
# Function capture syntax
add_one = &(&1 + 1)
multiply = &*/2

# Using with Enum
numbers = [1, 2, 3, 4, 5]
Enum.map(numbers, add_one)        # [2, 3, 4, 5, 6]
Enum.reduce(numbers, 0, &+/2)     # 15 (sum)
```

## Module Attributes and Documentation

```elixir
defmodule User do
  @moduledoc """
  This module handles user-related operations.
  """
  
  @default_role :user
  
  @doc """
  Creates a new user with the given name and optional role.
  
  ## Examples
  
      iex> User.create("Alice")
      %{name: "Alice", role: :user}
      
      iex> User.create("Bob", :admin)
      %{name: "Bob", role: :admin}
  """
  def create(name, role \\ @default_role) do
    %{name: name, role: role}
  end
end
```

## Import, Alias, and Require

```elixir
defmodule MyApp do
  # Import functions to use without module name
  import String, only: [upcase: 1, downcase: 1]
  
  # Create alias for shorter module names
  alias MyApp.User, as: U
  
  def process_name(name) do
    name
    |> downcase()
    |> upcase()
  end
  
  def create_user(name) do
    U.create(name)
  end
end
```

## Pipe Operator |>

The pipe operator makes code more readable by eliminating nested function calls:

```elixir
# Instead of this:
result = String.upcase(String.trim("  hello world  "))

# Write this:
result = "  hello world  "
         |> String.trim()
         |> String.upcase()

# Complex example
"  HELLO WORLD  "
|> String.trim()
|> String.downcase()
|> String.split(" ")
|> Enum.join("_")
# Result: "hello_world"
```

## Function Arity

In Elixir, functions are identified by name AND arity (number of parameters):

```elixir
defmodule Example do
  def greet(name), do: "Hello, #{name}!"           # greet/1
  def greet(first, last), do: "Hello, #{first} #{last}!"  # greet/2
end

# These are different functions:
Example.greet("Alice")        # calls greet/1
Example.greet("Bob", "Smith") # calls greet/2
```

## Next Steps

Practice these concepts in the `examples/` folder, then complete the exercises before moving to `05_control_flow/`!
