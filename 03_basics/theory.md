# Elixir Basics: Syntax and Data Types

## Variables

In Elixir, variables are immutable and use snake_case naming:

```elixir
# Variable assignment
name = "Alice"
age = 25
pi = 3.14159

# Variables are immutable - this creates a new binding
age = age + 1  # age is now 26, but the original 25 is unchanged
```

## Data Types

### Numbers
```elixir
# Integers
integer = 42
large_number = 1_000_000  # Underscores for readability

# Floats
pi = 3.14159
scientific = 1.5e-3  # Scientific notation
```

### Strings
```elixir
# Strings (UTF-8 encoded)
greeting = "Hello, World!"
multiline = """
This is a
multiline string
"""

# String interpolation
name = "Bob"
message = "Hello, #{name}!"  # "Hello, Bob!"

# String concatenation
full_name = "John" <> " " <> "Doe"
```

### Atoms
```elixir
# Atoms (constants/symbols)
:ok
:error
:success
:atom_with_underscores

# Atoms are their own value
:hello == :hello  # true
```

### Booleans
```elixir
# Booleans are actually atoms
true   # same as :true
false  # same as :false
nil    # same as :nil
```

### Tuples
```elixir
# Fixed-size containers
point = {3, 4}
person = {"Alice", 25, :engineer}
result = {:ok, "Success!"}
error = {:error, "Something went wrong"}

# Accessing elements (0-indexed)
elem(point, 0)  # 3
elem(point, 1)  # 4
```

### Lists
```elixir
# Dynamic arrays (linked lists)
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", :atom, true]
empty = []

# List operations
[head | tail] = [1, 2, 3, 4]  # head = 1, tail = [2, 3, 4]
new_list = [0 | numbers]      # [0, 1, 2, 3, 4, 5]

# Common functions
length([1, 2, 3])    # 3
hd([1, 2, 3])        # 1 (head)
tl([1, 2, 3])        # [2, 3] (tail)
```

### Maps
```elixir
# Key-value pairs
person = %{name: "Alice", age: 30, city: "New York"}
grades = %{"math" => 95, "science" => 87, "english" => 92}

# Accessing values
person[:name]        # "Alice"
person.name          # "Alice" (atom keys only)
grades["math"]       # 95

# Updating maps
updated_person = %{person | age: 31}
new_subject = Map.put(grades, "history", 89)
```

### Keyword Lists
```elixir
# Lists of tuples with atom keys
options = [timeout: 5000, retries: 3]
config = [host: "localhost", port: 4000, ssl: false]

# Often used for function options
Enum.map([1, 2, 3], fn x -> x * 2 end, timeout: 1000)
```

## Pattern Matching

Pattern matching is Elixir's superpower:

```elixir
# Basic matching
{:ok, result} = {:ok, "Success!"}
# result = "Success!"

# List matching
[first, second | rest] = [1, 2, 3, 4, 5]
# first = 1, second = 2, rest = [3, 4, 5]

# Map matching
%{name: person_name} = %{name: "Bob", age: 40}
# person_name = "Bob"

# Function pattern matching
def greet({:ok, name}) do
  "Hello, #{name}!"
end

def greet({:error, reason}) do
  "Error: #{reason}"
end
```

## Basic Operators

```elixir
# Arithmetic
1 + 2      # 3
10 - 5     # 5
3 * 4      # 12
15 / 3     # 5.0 (always returns float)
div(15, 3) # 5 (integer division)
rem(15, 4) # 3 (remainder)

# Comparison
1 == 1.0   # true (value equality)
1 === 1.0  # false (strict equality)
1 != 2     # true
1 < 2      # true

# Boolean
true and false   # false
true or false    # true
not true         # false

# String operations
"hello" <> " world"  # "hello world"
String.length("hello")  # 5
```

## Comments

```elixir
# This is a single-line comment

# This is a
# multi-line comment
# using multiple single-line comments
```

## Next Steps

Practice these concepts in the `examples/` folder, then complete the exercises in `exercises/` before moving to `04_functions/`!
