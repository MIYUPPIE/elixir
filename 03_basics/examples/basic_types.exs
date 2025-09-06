# Basic Data Types Examples

# Run this file with: elixir basic_types.exs

IO.puts("=== ELIXIR BASICS EXAMPLES ===")

# Numbers
IO.puts("\n--- Numbers ---")
integer = 42
float = 3.14159
large_number = 1_000_000

IO.puts("Integer: #{integer}")
IO.puts("Float: #{float}")
IO.puts("Large number: #{large_number}")

# Arithmetic
IO.puts("Addition: #{10 + 5}")
IO.puts("Division: #{15 / 3}")
IO.puts("Integer division: #{div(15, 3)}")
IO.puts("Remainder: #{rem(15, 4)}")

# Strings
IO.puts("\n--- Strings ---")
greeting = "Hello"
name = "Elixir"
message = "#{greeting}, #{name}!"
IO.puts(message)

# String operations
IO.puts("Length: #{String.length(message)}")
IO.puts("Uppercase: #{String.upcase(message)}")
IO.puts("Concatenation: #{"Hello" <> " " <> "World"}")

# Atoms
IO.puts("\n--- Atoms ---")
status = :ok
error_type = :not_found
IO.puts("Status atom: #{status}")
IO.puts("Are atoms equal? #{:ok == :ok}")

# Tuples
IO.puts("\n--- Tuples ---")
point = {3, 4}
person = {"Alice", 25, :developer}
IO.puts("Point: #{inspect(point)}")
IO.puts("Person: #{inspect(person)}")
IO.puts("First element of point: #{elem(point, 0)}")

# Lists
IO.puts("\n--- Lists ---")
numbers = [1, 2, 3, 4, 5]
fruits = ["apple", "banana", "orange"]
mixed = [1, "hello", :atom, true]

IO.puts("Numbers: #{inspect(numbers)}")
IO.puts("Fruits: #{inspect(fruits)}")
IO.puts("Mixed list: #{inspect(mixed)}")
IO.puts("List length: #{length(numbers)}")
IO.puts("First element: #{hd(numbers)}")
IO.puts("Rest of list: #{inspect(tl(numbers))}")

# List operations
new_list = [0 | numbers]
IO.puts("Prepended list: #{inspect(new_list)}")

# Maps
IO.puts("\n--- Maps ---")
person_map = %{name: "Bob", age: 30, city: "Austin"}
grades = %{"math" => 95, "science" => 87}

IO.puts("Person map: #{inspect(person_map)}")
IO.puts("Person name: #{person_map.name}")
IO.puts("Math grade: #{grades["math"]}")

# Updating maps
updated_person = %{person_map | age: 31}
IO.puts("Updated person: #{inspect(updated_person)}")

# Pattern matching examples
IO.puts("\n--- Pattern Matching ---")

# Tuple matching
{x, y} = {10, 20}
IO.puts("x: #{x}, y: #{y}")

# List matching
[first, second | rest] = [1, 2, 3, 4, 5]
IO.puts("First: #{first}, Second: #{second}, Rest: #{inspect(rest)}")

# Map matching
%{name: person_name, age: person_age} = %{name: "Charlie", age: 35, city: "Portland"}
IO.puts("Matched name: #{person_name}, age: #{person_age}")

IO.puts("\n=== END OF EXAMPLES ===")
