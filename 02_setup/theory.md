# Setting Up Your Elixir Environment

## Installing Elixir

### Method 1: Using Package Manager (Recommended)

#### On Ubuntu/Debian:
```bash
# Add Erlang Solutions repository
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update

# Install Erlang and Elixir
sudo apt-get install esl-erlang elixir
```

#### On macOS:
```bash
# Using Homebrew
brew install elixir
```

#### On Windows:
- Download installer from https://elixir-lang.org/install.html
- Or use Chocolatey: `choco install elixir`

### Method 2: Using asdf (Version Manager)
```bash
# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Add plugins
asdf plugin add erlang
asdf plugin add elixir

# Install latest versions
asdf install erlang latest
asdf install elixir latest
asdf global erlang latest
asdf global elixir latest
```

## Verify Installation

Run these commands to verify everything is working:

```bash
# Check Elixir version
elixir --version

# Check IEx (Interactive Elixir)
iex

# In IEx, try:
# IO.puts("Hello, Elixir!")
# System.version()
```

## Development Tools

### Code Editor Setup

#### VS Code (Recommended)
Install the ElixirLS extension:
- Extension ID: `jakebecker.elixir-ls`
- Provides syntax highlighting, autocomplete, and debugging

#### Other Options
- **Vim/Neovim** - elixir-lang/vim-elixir plugin
- **Emacs** - elixir-lang/emacs-elixir
- **IntelliJ/RubyMine** - Elixir plugin

### Essential Tools

1. **Mix** - Build tool (comes with Elixir)
2. **IEx** - Interactive shell
3. **ExUnit** - Testing framework
4. **Hex** - Package manager

## Your First Elixir Command

Open a terminal and run:
```bash
iex
```

Then try:
```elixir
IO.puts("Welcome to Elixir!")
1 + 2
"hello" <> " " <> "world"
```

Press `Ctrl+C` twice to exit.

## Next Steps

Once you have Elixir installed and working, move on to `03_basics/` to learn the fundamental syntax and data types!
