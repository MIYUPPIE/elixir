# Elixir Basics Exercises

Complete these exercises to practice what you've learned about Elixir data types and pattern matching.

## Exercise 1: Variable Assignment and Basic Operations

Write Elixir code to:
1. Create variables for your name, age, and favorite color
2. Calculate your birth year (use current year 2025)
3. Create a greeting message using string interpolation
4. Print all the information

**Solution location**: `solutions/exercise1.exs`

---

## Exercise 2: Working with Collections

1. Create a list of your top 5 favorite movies
2. Create a map representing a book with title, author, year, and pages
3. Create a tuple representing coordinates (latitude, longitude)
4. Use pattern matching to extract the first movie from your list
5. Use pattern matching to extract the book's author

**Solution location**: `solutions/exercise2.exs`

---

## Exercise 3: Pattern Matching Challenge

Create a function that takes a tuple and returns different messages based on the pattern:
- `{:ok, data}` should return "Success: {data}"
- `{:error, reason}` should return "Error: {reason}"
- `{:warning, message}` should return "Warning: {message}"
- Any other pattern should return "Unknown result"

Test your function with different inputs.

**Solution location**: `solutions/exercise3.exs`

---

## Exercise 4: List Processing

1. Create a list of numbers from 1 to 10
2. Use pattern matching to separate the list into head and tail
3. Create a function that calculates the length of a list using recursion
4. Create a function that finds the maximum number in a list

**Solution location**: `solutions/exercise4.exs`

---

## Exercise 5: Map Manipulation

Create a map representing a student with name, grades (map of subjects), and year.
1. Add a new subject and grade
2. Update an existing grade
3. Use pattern matching to extract the student's name and math grade
4. Calculate the student's average grade

**Solution location**: `solutions/exercise5.exs`

---

## Tips for Solving

- Remember that variables in Elixir are immutable
- Use the pin operator `^` when you want to match against an existing variable
- Practice pattern matching in IEx (Interactive Elixir)
- Use `inspect/1` to print complex data structures
- Don't be afraid to experiment!

## Running Your Solutions

```bash
# Run individual exercise
elixir solutions/exercise1.exs

# Or start IEx and load the file
iex
c("solutions/exercise1.exs")
```

Good luck! 🍀
