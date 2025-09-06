# Exercise 2 Solution: Working with Collections

# 1. List of top 5 favorite movies
favorite_movies = [
  "The Matrix",
  "Inception", 
  "Interstellar",
  "The Shawshank Redemption",
  "Pulp Fiction"
]

IO.puts("My favorite movies:")
Enum.each(favorite_movies, fn movie -> IO.puts("- #{movie}") end)

# 2. Map representing a book
book = %{
  title: "Programming Elixir",
  author: "Dave Thomas", 
  year: 2018,
  pages: 390
}

IO.puts("\nBook information:")
IO.puts("Title: #{book.title}")
IO.puts("Author: #{book.author}")
IO.puts("Year: #{book.year}")
IO.puts("Pages: #{book.pages}")

# 3. Tuple representing coordinates
coordinates = {40.7128, -74.0060}  # New York City
IO.puts("\nCoordinates: #{inspect(coordinates)}")

# 4. Pattern matching - extract first movie
[first_movie | _rest] = favorite_movies
IO.puts("\nFirst movie using pattern matching: #{first_movie}")

# 5. Pattern matching - extract book's author
%{author: book_author} = book
IO.puts("Book author using pattern matching: #{book_author}")

# Bonus: More pattern matching examples
[_first, second_movie | remaining_movies] = favorite_movies
IO.puts("Second movie: #{second_movie}")
IO.puts("Remaining movies: #{inspect(remaining_movies)}")

# Extract coordinates
{latitude, longitude} = coordinates
IO.puts("Latitude: #{latitude}, Longitude: #{longitude}")

# Partial map matching
%{title: book_title, pages: page_count} = book
IO.puts("#{book_title} has #{page_count} pages")
