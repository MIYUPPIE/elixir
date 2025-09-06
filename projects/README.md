# 🎯 Beginner Projects to Build Your Elixir Skills

These hands-on projects will help you apply what you've learned and build real Elixir applications.

## Project 1: Command Line Calculator 🧮

**Skills practiced**: Functions, pattern matching, error handling, user input

### Requirements
- Support basic operations (+, -, *, /)
- Handle invalid input gracefully
- Support continuous calculations
- Add memory functions (store/recall)

### Getting Started
```bash
mkdir elixir_calculator
cd elixir_calculator
mix new calculator
cd calculator
```

**Implementation hints**:
- Use pattern matching for different operations
- Create separate modules for parsing and calculation
- Handle division by zero elegantly
- Use recursion for the main program loop

---

## Project 2: Personal Todo List Manager ✅

**Skills practiced**: Data structures, file I/O, CRUD operations, persistence

### Requirements
- Add, complete, and delete tasks
- Categorize tasks (work, personal, shopping)
- Set priorities (high, medium, low)
- Save tasks to file for persistence
- Search and filter tasks

### Features to implement
- `mix todo add "Buy groceries" --category shopping --priority high`
- `mix todo list --category work`
- `mix todo complete 1`
- `mix todo delete 2`

**Implementation hints**:
- Use maps or structs for task representation
- Store data as JSON or Erlang terms
- Create custom Mix tasks for CLI interface
- Use Enum functions for filtering and searching

---

## Project 3: Text File Analyzer 📊

**Skills practiced**: File processing, text analysis, data aggregation, reporting

### Requirements
- Count words, lines, and characters
- Find most common words
- Analyze sentence structure
- Generate reading time estimate
- Support multiple file formats

### Features
- Word frequency analysis
- Reading level assessment
- Longest/shortest sentences
- Character encoding detection
- Export reports to different formats

**Implementation hints**:
- Use Stream for large files
- Create a pipeline with |> operator
- Handle different text encodings
- Use regex for advanced text parsing

---

## Project 4: Simple HTTP Client 🌐

**Skills practiced**: HTTP requests, JSON parsing, error handling, external APIs

### Requirements
- Make GET, POST, PUT, DELETE requests
- Parse JSON responses
- Handle HTTP errors gracefully
- Support request headers and authentication
- Pretty-print responses

### Features
```bash
mix http_client get "https://api.github.com/users/octocat"
mix http_client post "https://api.example.com/users" --data '{"name":"Alice"}'
```

**Dependencies to add**:
```elixir
{:httpoison, "~> 2.0"},
{:jason, "~> 1.4"}
```

---

## Project 5: File Organizer 📁

**Skills practiced**: File system operations, pattern matching, concurrency

### Requirements
- Organize files by type (images, documents, code)
- Rename files with consistent naming
- Remove duplicates based on content hash
- Generate organization reports
- Support undo operations

### Features
- Scan directories recursively
- Group files by extension, size, or date
- Safe operations with backup
- Parallel processing for large directories

---

## Project 6: Password Generator & Manager 🔐

**Skills practiced**: Randomness, cryptography, secure storage, validation

### Requirements
- Generate strong passwords with custom rules
- Store passwords securely (encrypted)
- Check password strength
- Detect compromised passwords
- Master password protection

### Features
- Customizable password policies
- Secure random generation
- Strength meter
- Breach checking against known lists
- Clipboard integration

---

## Project 7: Log File Analyzer 📈

**Skills practiced**: Large data processing, pattern recognition, statistics

### Requirements
- Parse different log formats (Apache, Nginx, custom)
- Extract useful statistics
- Detect patterns and anomalies
- Generate visual reports
- Real-time log monitoring

### Features
- Top requested URLs
- Error rate analysis
- Traffic patterns by time
- Geographic IP analysis
- Alert on threshold breaches

---

## 🚀 Getting Started Tips

### For Each Project:

1. **Plan first** - Write requirements and design before coding
2. **Start simple** - Build MVP first, add features incrementally  
3. **Test everything** - Write tests as you develop
4. **Document** - Add @doc to all public functions
5. **Refactor** - Improve code structure as you learn

### Project Structure Template:
```
my_project/
├── lib/
│   ├── my_project/
│   │   ├── core.ex        # Business logic
│   │   ├── cli.ex         # Command line interface  
│   │   └── storage.ex     # Data persistence
│   └── my_project.ex      # Main module
├── test/
├── README.md
└── mix.exs
```

### Common Dependencies:
```elixir
defp deps do
  [
    {:jason, "~> 1.4"},           # JSON parsing
    {:httpoison, "~> 2.0"},       # HTTP client
    {:ex_doc, "~> 0.29", only: :dev, runtime: false},
    {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
  ]
end
```

## 📝 Project Submission Checklist

For each project, ensure you have:

- [ ] **Working code** - Runs without errors
- [ ] **Tests** - Comprehensive test suite
- [ ] **Documentation** - Clear README and code docs
- [ ] **Error handling** - Graceful failure modes
- [ ] **Code quality** - Follows Elixir conventions
- [ ] **Git history** - Clean commits with good messages

## 🎊 Bonus Challenges

Once you complete the basic projects:

1. **Add concurrency** - Make file operations parallel
2. **Add persistence** - Use SQLite or PostgreSQL
3. **Add web interface** - Build simple Phoenix UI
4. **Add configuration** - Support config files
5. **Package as escript** - Create standalone executables

Remember: The goal is to learn, not to build perfect software. Focus on understanding concepts and applying them correctly!

Happy coding! 🎉
