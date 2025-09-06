# Recursion and Higher-Order Functions

In functional programming, recursion replaces loops. Elixir is optimized for tail recursion and provides powerful higher-order functions.

## Understanding Recursion

Recursion has two key components:
1. **Base case** - when to stop recursing
2. **Recursive case** - how to break down the problem

### Simple Recursion Examples

```elixir
defmodule BasicRecursion do
  # Calculate factorial
  def factorial(0), do: 1
  def factorial(n) when n > 0 do
    n * factorial(n - 1)
  end
  
  # Calculate sum of a list
  def sum([]), do: 0
  def sum([head | tail]) do
    head + sum(tail)
  end
  
  # Count elements in a list
  def count([]), do: 0
  def count([_head | tail]) do
    1 + count(tail)
  end
end
```

## Tail Recursion

Tail recursion is more memory-efficient because it can be optimized:

```elixir
defmodule TailRecursion do
  # Tail-recursive factorial with accumulator
  def factorial(n), do: factorial(n, 1)
  defp factorial(0, acc), do: acc
  defp factorial(n, acc) when n > 0 do
    factorial(n - 1, acc * n)
  end
  
  # Tail-recursive sum
  def sum(list), do: sum(list, 0)
  defp sum([], acc), do: acc
  defp sum([head | tail], acc) do
    sum(tail, acc + head)
  end
  
  # Tail-recursive reverse
  def reverse(list), do: reverse(list, [])
  defp reverse([], acc), do: acc
  defp reverse([head | tail], acc) do
    reverse(tail, [head | acc])
  end
end
```

## Higher-Order Functions with Enum

The `Enum` module provides many higher-order functions:

### Map, Filter, Reduce
```elixir
numbers = [1, 2, 3, 4, 5]

# Map - transform each element
squared = Enum.map(numbers, fn x -> x * x end)
# or using capture syntax: Enum.map(numbers, &(&1 * &1))

# Filter - keep elements that match a condition
evens = Enum.filter(numbers, fn x -> rem(x, 2) == 0 end)
# or: Enum.filter(numbers, &(rem(&1, 2) == 0))

# Reduce - combine all elements into a single value
sum = Enum.reduce(numbers, 0, fn x, acc -> x + acc end)
# or: Enum.reduce(numbers, 0, &+/2)

# Find - get first matching element
first_even = Enum.find(numbers, fn x -> rem(x, 2) == 0 end)
```

### Advanced Enum Functions
```elixir
# Group by a function
words = ["apple", "apricot", "banana", "blueberry", "cherry"]
by_first_letter = Enum.group_by(words, &String.first/1)
# %{"a" => ["apple", "apricot"], "b" => ["banana", "blueberry"], "c" => ["cherry"]}

# Chunk - split into groups
Enum.chunk_every([1, 2, 3, 4, 5, 6], 3)
# [[1, 2, 3], [4, 5, 6]]

# Zip - combine two lists
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
Enum.zip(names, ages)
# [{"Alice", 25}, {"Bob", 30}, {"Charlie", 35}]

# Flat map - map and flatten
nested = [[1, 2], [3, 4], [5, 6]]
Enum.flat_map(nested, &(&1))
# [1, 2, 3, 4, 5, 6]
```

## Stream Module (Lazy Evaluation)

Streams are lazy enumerables - they don't execute until materialized:

```elixir
# Streams are composable and memory-efficient
result = 1..1_000_000
         |> Stream.filter(&(rem(&1, 2) == 0))    # Lazy filter
         |> Stream.map(&(&1 * &1))               # Lazy map
         |> Stream.take(10)                      # Lazy take
         |> Enum.to_list()                       # Execute the pipeline

# Infinite streams
fibonacci = Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
first_10_fib = Enum.take(fibonacci, 10)
```

## Function Composition Patterns

```elixir
defmodule DataProcessor do
  # Compose functions using pipe operator
  def process_text(text) do
    text
    |> String.trim()
    |> String.downcase()
    |> String.split(" ")
    |> Enum.filter(&(String.length(&1) > 2))
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
  
  # Higher-order function that takes another function
  def apply_to_all(list, fun) do
    Enum.map(list, fun)
  end
  
  # Function that returns a function
  def multiplier(factor) do
    fn x -> x * factor end
  end
  
  # Combine multiple operations
  def complex_processing(data, operations) do
    Enum.reduce(operations, data, fn operation, acc ->
      operation.(acc)
    end)
  end
end

# Examples
sample_text = "  hello WORLD elixir programming  "
IO.puts("Original: '#{sample_text}'")
IO.puts("Processed: '#{DataProcessor.process_text(sample_text)}'")

# Using higher-order functions
double = DataProcessor.multiplier(2)
triple = DataProcessor.multiplier(3)

numbers = [1, 2, 3, 4]
IO.puts("Doubled: #{inspect(DataProcessor.apply_to_all(numbers, double))}")
IO.puts("Tripled: #{inspect(DataProcessor.apply_to_all(numbers, triple))}")

# Complex processing pipeline
operations = [
  &Enum.filter(&1, fn x -> rem(x, 2) == 0 end),  # Keep evens
  &Enum.map(&1, fn x -> x * x end),               # Square them
  &Enum.sum/1                                     # Sum the result
]

data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
result = DataProcessor.complex_processing(data, operations)
IO.puts("Complex processing result: #{result}")
