# Exercise 1 Solution: Variables and Basic Operations

# Personal information
name = "Your Name Here"  # Replace with your actual name
age = 25  # Replace with your actual age
favorite_color = "blue"  # Replace with your favorite color

# Calculate birth year
current_year = 2025
birth_year = current_year - age

# Create greeting message
greeting = "Hello! My name is #{name}, I'm #{age} years old, and my favorite color is #{favorite_color}."
birth_info = "I was born in #{birth_year}."

# Print all information
IO.puts(greeting)
IO.puts(birth_info)

# Bonus: Some calculations
days_lived = age * 365
IO.puts("I've lived approximately #{days_lived} days!")

# String operations
name_length = String.length(name)
IO.puts("My name has #{name_length} characters.")

upcase_name = String.upcase(name)
IO.puts("My name in uppercase: #{upcase_name}")
