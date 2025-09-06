# Testing with ExUnit

ExUnit is Elixir's built-in testing framework. It provides powerful features for unit testing, integration testing, and test organization.

## Basic Test Structure

```elixir
# test/my_module_test.exs
defmodule MyModuleTest do
  use ExUnit.Case
  doctest MyModule  # Test examples in documentation

  test "greets the world" do
    assert MyModule.hello() == :world
  end
  
  test "adds two numbers" do
    result = MyModule.add(2, 3)
    assert result == 5
  end
end
```

## Assertions

ExUnit provides various assertion macros:

```elixir
defmodule AssertionExamples do
  use ExUnit.Case

  test "equality assertions" do
    assert 1 + 1 == 2
    refute 1 + 1 == 3
    assert_in_delta 3.14, :math.pi(), 0.01  # Float comparison
  end

  test "pattern matching assertions" do
    result = {:ok, "success"}
    assert {:ok, message} = result
    assert message == "success"
  end

  test "exception assertions" do
    assert_raise ArgumentError, fn ->
      String.to_integer("not_a_number")
    end
    
    assert_raise ArgumentError, "argument error", fn ->
      raise ArgumentError, "argument error"
    end
  end

  test "output assertions" do
    assert capture_io(fn -> IO.puts("hello") end) == "hello\n"
  end
end
```

## Test Organization

### describe blocks
```elixir
defmodule UserTest do
  use ExUnit.Case

  describe "create/1" do
    test "creates user with valid data" do
      user_data = %{name: "Alice", email: "alice@example.com"}
      assert {:ok, user} = User.create(user_data)
      assert user.name == "Alice"
    end

    test "returns error with invalid data" do
      assert {:error, _reason} = User.create(%{})
    end
  end

  describe "update/2" do
    setup do
      {:ok, user} = User.create(%{name: "Bob", email: "bob@example.com"})
      %{user: user}
    end

    test "updates user successfully", %{user: user} do
      assert {:ok, updated} = User.update(user, %{name: "Robert"})
      assert updated.name == "Robert"
    end
  end
end
```

### Setup and Teardown
```elixir
defmodule DatabaseTest do
  use ExUnit.Case

  # Run before each test in this module
  setup do
    # Setup code here
    user = create_test_user()
    
    # Return context that will be available in tests
    %{user: user}
  end

  # Run before all tests in this module
  setup_all do
    # One-time setup
    start_database()
    
    # Cleanup function
    on_exit(fn -> stop_database() end)
    
    :ok
  end

  test "user operations", %{user: user} do
    # Test using the user from setup
    assert user.name != nil
  end

  defp create_test_user do
    %{id: 1, name: "Test User", email: "test@example.com"}
  end
  
  defp start_database, do: :ok
  defp stop_database, do: :ok
end
```

## Property-Based Testing

Use StreamData for property-based testing:

```elixir
# Add to mix.exs deps:
# {:stream_data, "~> 0.5", only: :test}

defmodule PropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  property "string concatenation is associative" do
    check all a <- string(:printable),
              b <- string(:printable),
              c <- string(:printable) do
      assert (a <> b) <> c == a <> (b <> c)
    end
  end

  property "list reversal is involutive" do
    check all list <- list_of(integer()) do
      assert list == list |> Enum.reverse() |> Enum.reverse()
    end
  end
end
```

## Mocking and Testing External Dependencies

```elixir
# Using Mox for mocking
# Add to mix.exs: {:mox, "~> 1.0", only: :test}

defmodule HttpClientMock do
  @behaviour HttpClient
  
  def get(url) do
    # Mock implementation
    case url do
      "http://success.com" -> {:ok, %{status: 200, body: "success"}}
      "http://error.com" -> {:error, :timeout}
      _ -> {:ok, %{status: 404, body: "not found"}}
    end
  end
end

defmodule ApiServiceTest do
  use ExUnit.Case
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "handles successful API response" do
    expect(HttpClientMock, :get, fn _url -> 
      {:ok, %{status: 200, body: "success"}}
    end)
    
    assert {:ok, "success"} = ApiService.fetch_data("http://test.com")
  end
end
```

## Test Configuration

```elixir
# test/test_helper.exs
ExUnit.start()

# Configure test environment
Application.put_env(:my_app, :environment, :test)

# Enable property-based testing
ExUnitProperties.start()
```

## Running Tests

```bash
# Run all tests
mix test

# Run specific test file
mix test test/user_test.exs

# Run specific test by line number
mix test test/user_test.exs:42

# Run tests matching a pattern
mix test --only integration

# Run tests with coverage
mix test --cover

# Run tests in watch mode
mix test.watch  # Requires mix_test_watch dependency
```

## Test Tags and Filtering

```elixir
defmodule SlowTest do
  use ExUnit.Case

  @tag :slow
  test "this test takes a long time" do
    :timer.sleep(5000)
    assert true
  end

  @tag :integration
  test "integration test" do
    # Test external integration
    assert true
  end

  @tag timeout: 60_000
  test "test with custom timeout" do
    # Long running test
    assert true
  end
end
```

Run specific tags:
```bash
mix test --only slow          # Only slow tests
mix test --exclude slow       # Exclude slow tests
mix test --only integration   # Only integration tests
```

## Doctests

Test examples in your documentation:

```elixir
defmodule Calculator do
  @doc """
  Adds two numbers together.
  
  ## Examples
  
      iex> Calculator.add(2, 3)
      5
      
      iex> Calculator.add(-1, 1)
      0
  """
  def add(a, b), do: a + b
  
  @doc """
  Divides two numbers.
  
  ## Examples
  
      iex> Calculator.divide(10, 2)
      {:ok, 5.0}
      
      iex> Calculator.divide(10, 0)
      {:error, "Cannot divide by zero"}
  """
  def divide(_, 0), do: {:error, "Cannot divide by zero"}
  def divide(a, b), do: {:ok, a / b}
end

# In test file:
defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator  # This will run the examples as tests!
end
```

## Test Best Practices

1. **Test behavior, not implementation**
2. **Use descriptive test names** 
3. **Follow AAA pattern** - Arrange, Act, Assert
4. **Test edge cases and error conditions**
5. **Use setup for common test data**
6. **Keep tests independent and isolated**
7. **Use tags to organize different types of tests**

## Next Steps

Practice writing tests for the code you've created so far, then move on to `10_error_handling/` to learn robust error handling patterns!
