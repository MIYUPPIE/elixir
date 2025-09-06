# Pattern Matching Deep Dive

# Run this file with: elixir pattern_matching.exs

IO.puts("=== PATTERN MATCHING EXAMPLES ===")

# The match operator =
IO.puts("\n--- Basic Matching ---")

# This assigns the value 42 to the variable x
x = 42
IO.puts("x = #{x}")

# This matches the pattern {a, b} with the tuple {1, 2}
{a, b} = {1, 2}
IO.puts("a = #{a}, b = #{b}")

# Matching with existing variables
x = 10
{x, y} = {10, 20}  # This works because x already equals 10
IO.puts("After matching: x = #{x}, y = #{y}")

# Pin operator ^ - use existing value in pattern
IO.puts("\n--- Pin Operator ---")
value = 5
{^value, new_value} = {5, 10}  # Must match exactly 5
IO.puts("new_value = #{new_value}")

# List pattern matching
IO.puts("\n--- List Patterns ---")

# Head and tail
[head | tail] = [1, 2, 3, 4]
IO.puts("Head: #{head}, Tail: #{inspect(tail)}")

# Multiple elements
[first, second | rest] = [:a, :b, :c, :d, :e]
IO.puts("First: #{first}, Second: #{second}, Rest: #{inspect(rest)}")

# Exact length matching
[one, two, three] = [1, 2, 3]
IO.puts("Matched exactly three elements: #{one}, #{two}, #{three}")

# Map pattern matching
IO.puts("\n--- Map Patterns ---")

person = %{name: "Alice", age: 30, profession: "engineer", city: "NYC"}

# Extract specific keys
%{name: person_name, age: person_age} = person
IO.puts("Name: #{person_name}, Age: #{person_age}")

# Pattern match with some keys
%{profession: job} = person
IO.puts("Job: #{job}")

# Nested pattern matching
IO.puts("\n--- Nested Patterns ---")

nested_data = %{
  user: %{
    id: 123,
    profile: %{name: "Bob", settings: %{theme: "dark"}}
  },
  posts: [
    %{title: "First Post", likes: 10},
    %{title: "Second Post", likes: 25}
  ]
}

# Extract nested values
%{
  user: %{
    id: user_id,
    profile: %{name: username, settings: %{theme: user_theme}}
  },
  posts: [%{title: first_post_title} | _other_posts]
} = nested_data

IO.puts("User ID: #{user_id}")
IO.puts("Username: #{username}")
IO.puts("Theme: #{user_theme}")
IO.puts("First post: #{first_post_title}")

# Function pattern matching
IO.puts("\n--- Function Patterns ---")

defmodule PatternExample do
  # Multiple function clauses with different patterns
  def process_result({:ok, data}) do
    "Success: #{data}"
  end

  def process_result({:error, reason}) do
    "Error: #{reason}"
  end

  def process_result(:pending) do
    "Still processing..."
  end

  # List processing with patterns
  def sum_list([]), do: 0
  def sum_list([head | tail]), do: head + sum_list(tail)

  # Map processing
  def greet_person(%{name: name, age: age}) when age >= 18 do
    "Hello, #{name}! You're an adult."
  end

  def greet_person(%{name: name, age: age}) when age < 18 do
    "Hi, #{name}! You're a minor."
  end
end

# Test the pattern matching functions
IO.puts(PatternExample.process_result({:ok, "Data loaded"}))
IO.puts(PatternExample.process_result({:error, "Network timeout"}))
IO.puts(PatternExample.process_result(:pending))

IO.puts("Sum of [1,2,3,4]: #{PatternExample.sum_list([1, 2, 3, 4])}")

alice = %{name: "Alice", age: 25}
bob = %{name: "Bob", age: 16}
IO.puts(PatternExample.greet_person(alice))
IO.puts(PatternExample.greet_person(bob))

IO.puts("\n=== END OF PATTERN MATCHING EXAMPLES ===")
