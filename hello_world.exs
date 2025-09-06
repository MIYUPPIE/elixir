# Your First Elixir Program

Let's start with a simple "Hello, World!" program to make sure everything is working.

# Run this file with: elixir hello_world.exs

defmodule HelloWorld do
  @moduledoc """
  Your very first Elixir module!
  
  This module demonstrates basic Elixir concepts:
  - Module definition
  - Function definition
  - String interpolation
  - IO operations
  """

  @doc """
  Says hello to the world or a specific person.
  """
  def hello(name \\ "World") do
    "Hello, #{name}!"
  end

  @doc """
  Demonstrates basic Elixir features.
  """
  def demo do
    IO.puts("=== Welcome to Elixir! ===")
    
    # String interpolation
    name = "Elixir Developer"
    greeting = hello(name)
    IO.puts(greeting)
    
    # Basic arithmetic
    result = 2 + 2
    IO.puts("2 + 2 = #{result}")
    
    # List operations
    numbers = [1, 2, 3, 4, 5]
    doubled = Enum.map(numbers, &(&1 * 2))
    IO.puts("Original numbers: #{inspect(numbers)}")
    IO.puts("Doubled numbers: #{inspect(doubled)}")
    
    # Pattern matching
    {:ok, message} = {:ok, "Pattern matching works!"}
    IO.puts(message)
    
    # Atoms
    status = :success
    IO.puts("Status: #{status}")
    
    IO.puts("=== Elixir Demo Complete! ===")
  end
end

# Run the demo when this file is executed
HelloWorld.demo()

# Try these in IEx:
# HelloWorld.hello()
# HelloWorld.hello("Alice")
# HelloWorld.demo()
