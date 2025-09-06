# Control Flow in Elixir

Elixir provides several ways to control program flow. Since it's a functional language, control flow is expression-based (everything returns a value).

## if and unless

```elixir
# if expression
age = 18
status = if age >= 18 do
  "adult"
else
  "minor"
end

# unless (opposite of if)
unless age < 18 do
  IO.puts("You can vote!")
end

# Single-line syntax
status = if age >= 18, do: "adult", else: "minor"
```

## case

`case` allows pattern matching against multiple patterns:

```elixir
defmodule FlightStatus do
  def check_status(status) do
    case status do
      :on_time -> "Flight is on time"
      {:delayed, minutes} -> "Flight delayed by #{minutes} minutes"
      {:cancelled, reason} -> "Flight cancelled: #{reason}"
      _ -> "Unknown status"
    end
  end
end

# Usage
FlightStatus.check_status(:on_time)
FlightStatus.check_status({:delayed, 30})
FlightStatus.check_status({:cancelled, "weather"})
```

## cond

`cond` evaluates conditions until one is true:

```elixir
defmodule WeatherAdvice do
  def clothing_advice(temperature) do
    cond do
      temperature > 30 -> "Wear light clothes and sunscreen"
      temperature > 20 -> "Perfect weather for a t-shirt"
      temperature > 10 -> "You might want a light jacket"
      temperature > 0  -> "Wear a warm coat"
      true -> "Stay inside, it's freezing!"
    end
  end
end
```

## with

`with` provides elegant error handling for chains of operations:

```elixir
defmodule UserRegistration do
  def register_user(params) do
    with {:ok, email} <- validate_email(params["email"]),
         {:ok, password} <- validate_password(params["password"]),
         {:ok, user} <- create_user(email, password),
         {:ok, _profile} <- create_profile(user) do
      {:ok, "User registered successfully"}
    else
      {:error, reason} -> {:error, "Registration failed: #{reason}"}
      _ -> {:error, "Unknown registration error"}
    end
  end
  
  defp validate_email(nil), do: {:error, "Email is required"}
  defp validate_email(email) when byte_size(email) < 3, do: {:error, "Email too short"}
  defp validate_email(email), do: {:ok, email}
  
  defp validate_password(nil), do: {:error, "Password is required"}
  defp validate_password(pwd) when byte_size(pwd) < 6, do: {:error, "Password too short"}
  defp validate_password(pwd), do: {:ok, pwd}
  
  defp create_user(email, password) do
    # Simulate user creation
    {:ok, %{id: :rand.uniform(1000), email: email}}
  end
  
  defp create_profile(user) do
    # Simulate profile creation
    {:ok, %{user_id: user.id, created_at: DateTime.utc_now()}}
  end
end
```

## try, catch, rescue

Error handling for exceptional cases:

```elixir
defmodule FileProcessor do
  def safe_read_file(filename) do
    try do
      content = File.read!(filename)
      {:ok, content}
    rescue
      File.Error -> {:error, "File not found or not readable"}
      e in RuntimeError -> {:error, "Runtime error: #{e.message}"}
    catch
      :exit, reason -> {:error, "Process exited: #{reason}"}
    after
      IO.puts("File read attempt completed")
    end
  end
end
```

## Guards in Detail

Guards are limited expressions that can be used in function heads:

```elixir
defmodule NumberClassifier do
  # Type guards
  def classify(n) when is_integer(n), do: "integer: #{n}"
  def classify(n) when is_float(n), do: "float: #{n}"
  def classify(n) when is_binary(n), do: "string: #{n}"
  
  # Complex guards
  def range_check(n) when is_number(n) and n >= 0 and n <= 100 do
    "Number in valid range: #{n}"
  end
  
  def range_check(_), do: "Invalid input"
  
  # Custom guard macros
  defguard is_even(n) when is_integer(n) and rem(n, 2) == 0
  defguard is_positive(n) when is_number(n) and n > 0
  
  def describe_number(n) when is_even(n) and is_positive(n) do
    "Positive even number: #{n}"
  end
  
  def describe_number(n) when is_positive(n) do
    "Positive odd number: #{n}"
  end
  
  def describe_number(_), do: "Not a positive integer"
end
```

## Conditional Assignment Patterns

```elixir
# Multiple assignment with case
{status, result} = case expensive_operation() do
  {:ok, data} -> {:success, process(data)}
  {:error, _} -> {:failure, "Could not process"}
end

# Using || for default values
name = user_input || "Anonymous"
config = user_config || default_config()

# Using && for conditional execution
user && send_welcome_email(user)
```

## Pattern Matching in Function Parameters

```elixir
defmodule ApiHandler do
  # Pattern match in function parameters
  def handle_request(%{method: "GET", path: "/users"}) do
    "Listing all users"
  end
  
  def handle_request(%{method: "POST", path: "/users", body: user_data}) do
    "Creating user: #{inspect(user_data)}"
  end
  
  def handle_request(%{method: method, path: path}) do
    "Unsupported: #{method} #{path}"
  end
  
  # Complex parameter patterns
  def process_coordinates([{x, y} | rest]) when x > 0 and y > 0 do
    "Valid coordinates starting with (#{x}, #{y}), #{length(rest)} more"
  end
  
  def process_coordinates(_), do: "Invalid coordinates"
end
```

## Next Steps

Master these control flow concepts, then move on to `06_recursion/` to learn about recursive thinking and higher-order functions!
