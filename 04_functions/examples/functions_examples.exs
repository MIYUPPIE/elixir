# Functions and Modules Examples

# Run with: elixir functions_examples.exs

IO.puts("=== FUNCTIONS AND MODULES EXAMPLES ===")

# Anonymous functions
IO.puts("\n--- Anonymous Functions ---")

# Basic anonymous function
square = fn x -> x * x end
IO.puts("Square of 5: #{square.(5)}")

# Anonymous function with pattern matching
process_response = fn
  {:ok, data} -> "Success: #{data}"
  {:error, reason} -> "Failed: #{reason}"
  {:warning, msg} -> "Warning: #{msg}"
end

IO.puts(process_response.({:ok, "User created"}))
IO.puts(process_response.({:error, "Network timeout"}))

# Short syntax for anonymous functions
double = &(&1 * 2)
add = &(&1 + &2)

IO.puts("Double 7: #{double.(7)}")
IO.puts("Add 3 + 4: #{add.(3, 4)}")

# Named functions in modules
IO.puts("\n--- Named Functions in Modules ---")

defmodule MathUtils do
  @moduledoc "Utility functions for mathematical operations"
  
  # Simple function
  def add(a, b), do: a + b
  
  # Function with multiple clauses and guards
  def factorial(0), do: 1
  def factorial(n) when is_integer(n) and n > 0 do
    n * factorial(n - 1)
  end
  
  # Function with default parameters
  def power(base, exponent \\ 2) do
    :math.pow(base, exponent)
  end
  
  # Private function
  defp is_even?(n), do: rem(n, 2) == 0
  
  # Public function using private function
  def classify_number(n) when is_integer(n) do
    cond do
      n == 0 -> :zero
      n > 0 and is_even?(n) -> :positive_even
      n > 0 -> :positive_odd
      n < 0 and is_even?(n) -> :negative_even
      n < 0 -> :negative_odd
    end
  end
end

# Test the functions
IO.puts("5 + 3 = #{MathUtils.add(5, 3)}")
IO.puts("Factorial of 5: #{MathUtils.factorial(5)}")
IO.puts("2^3 = #{MathUtils.power(2, 3)}")
IO.puts("3^2 (default): #{MathUtils.power(3)}")
IO.puts("Classify 8: #{MathUtils.classify_number(8)}")
IO.puts("Classify -7: #{MathUtils.classify_number(-7)}")

# String processing module
IO.puts("\n--- String Processing Module ---")

defmodule TextProcessor do
  def clean_and_format(text) do
    text
    |> String.trim()
    |> String.downcase()
    |> String.replace(~r/\s+/, "_")
  end
  
  def word_count(text) do
    text
    |> String.trim()
    |> String.split(~r/\s+/)
    |> length()
  end
  
  def title_case(text) do
    text
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end

sample_text = "  HELLO elixir WORLD  "
IO.puts("Original: '#{sample_text}'")
IO.puts("Cleaned: '#{TextProcessor.clean_and_format(sample_text)}'")
IO.puts("Word count: #{TextProcessor.word_count(sample_text)}")
IO.puts("Title case: '#{TextProcessor.title_case("hello world")}'")

# List processing with pattern matching
IO.puts("\n--- List Processing ---")

defmodule ListUtils do
  # Calculate sum using recursion and pattern matching
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
  
  # Find maximum element
  def max([head | tail]), do: max(tail, head)
  def max([], current_max), do: current_max
  def max([head | tail], current_max) when head > current_max do
    max(tail, head)
  end
  def max([_head | tail], current_max) do
    max(tail, current_max)
  end
  
  # Reverse a list
  def reverse(list), do: reverse(list, [])
  def reverse([], acc), do: acc
  def reverse([head | tail], acc), do: reverse(tail, [head | acc])
  
  # Check if list contains an element
  def contains?([], _), do: false
  def contains?([target | _], target), do: true
  def contains?([_ | tail], target), do: contains?(tail, target)
end

numbers = [1, 2, 3, 4, 5]
IO.puts("Numbers: #{inspect(numbers)}")
IO.puts("Sum: #{ListUtils.sum(numbers)}")
IO.puts("Max: #{ListUtils.max(numbers)}")
IO.puts("Reversed: #{inspect(ListUtils.reverse(numbers))}")
IO.puts("Contains 3? #{ListUtils.contains?(numbers, 3)}")
IO.puts("Contains 10? #{ListUtils.contains?(numbers, 10)}")

# Higher-order functions with Enum
IO.puts("\n--- Higher-Order Functions ---")

# Map, filter, reduce examples
IO.puts("Original: #{inspect(numbers)}")
IO.puts("Doubled: #{inspect(Enum.map(numbers, &(&1 * 2)))}")
IO.puts("Even numbers: #{inspect(Enum.filter(numbers, &(rem(&1, 2) == 0)))}")
IO.puts("Sum with Enum: #{Enum.reduce(numbers, 0, &+/2)}")

# Chaining operations
result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
         |> Enum.filter(&(rem(&1, 2) == 0))  # Keep even numbers
         |> Enum.map(&(&1 * &1))             # Square them
         |> Enum.sum()                       # Sum the results

IO.puts("Even numbers squared and summed: #{result}")

IO.puts("\n=== END OF FUNCTIONS EXAMPLES ===")
