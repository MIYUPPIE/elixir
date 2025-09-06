# Mix: Elixir's Build Tool and Project Manager

Mix is Elixir's built-in build tool that helps you create, compile, test, and manage dependencies for your projects.

## Creating a New Project

```bash
# Create a new Mix project
mix new my_project
cd my_project

# Create a supervised application
mix new my_app --sup

# Create a library (no application callback)
mix new my_lib --module MyLib
```

## Project Structure

A typical Mix project structure:
```
my_project/
├── lib/
│   └── my_project.ex          # Main module
├── test/
│   ├── my_project_test.exs    # Tests
│   └── test_helper.exs        # Test configuration
├── config/
│   └── config.exs             # Configuration
├── mix.exs                    # Project definition
├── README.md
└── .gitignore
```

## mix.exs - Project Definition

```elixir
defmodule MyProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_project,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      
      # Optional project metadata
      description: "My awesome Elixir project",
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" for more info
  def application do
    [
      extra_applications: [:logger],
      mod: {MyProject.Application, []}  # If using --sup
    ]
  end

  # Dependencies
  defp deps do
    [
      {:jason, "~> 1.4"},        # JSON library
      {:httpoison, "~> 2.0"},    # HTTP client
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}  # Documentation
    ]
  end
  
  defp package do
    [
      name: "my_project",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/user/my_project"}
    ]
  end
  
  defp docs do
    [
      main: "MyProject",
      extras: ["README.md"]
    ]
  end
end
```

## Common Mix Commands

```bash
# Compile the project
mix compile

# Get dependencies
mix deps.get

# Run tests
mix test

# Run the application
mix run

# Start interactive shell with project loaded
iex -S mix

# Format code
mix format

# Check for security vulnerabilities
mix deps.audit

# Generate documentation
mix docs

# Create releases
mix release
```

## Managing Dependencies

### Adding Dependencies

Edit `mix.exs` and add to the `deps` function:
```elixir
defp deps do
  [
    {:poison, "~> 5.0"},           # JSON library
    {:httpoison, "~> 2.0"},        # HTTP client
    {:phoenix, "~> 1.7.0"},        # Web framework
    {:ecto, "~> 3.9"},             # Database wrapper
    
    # Development and test only
    {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
    {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
  ]
end
```

Then run:
```bash
mix deps.get
mix deps.compile
```

### Version Constraints
```elixir
{:my_dep, "~> 1.2"}      # >= 1.2.0 and < 2.0.0
{:my_dep, "~> 1.2.3"}    # >= 1.2.3 and < 1.3.0  
{:my_dep, ">= 1.2.0"}    # >= 1.2.0
{:my_dep, "== 1.2.0"}    # Exactly 1.2.0
{:my_dep, github: "user/repo"}  # From GitHub
```

## Mix Environments

Mix supports different environments:

```elixir
# config/config.exs
import Config

# Shared configuration
config :my_app,
  debug_mode: false

# Environment-specific config
import_config "#{config_env()}.exs"

# config/dev.exs
import Config

config :my_app,
  debug_mode: true,
  database_url: "ecto://localhost/my_app_dev"

# config/prod.exs  
import Config

config :my_app,
  debug_mode: false,
  database_url: System.get_env("DATABASE_URL")
```

Run with different environments:
```bash
MIX_ENV=prod mix compile
MIX_ENV=test mix test
MIX_ENV=dev iex -S mix
```

## Custom Mix Tasks

Create custom tasks in `lib/mix/tasks/`:

```elixir
# lib/mix/tasks/hello.ex
defmodule Mix.Tasks.Hello do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function"

  def run(args) do
    # This will start our application
    Mix.Task.run("app.start")
    
    case args do
      [] -> Hello.say()
      [name] -> Hello.say(name)
      _ -> IO.puts("Usage: mix hello [name]")
    end
  end
end
```

Run with: `mix hello` or `mix hello Alice`

## Mix Aliases

Define shortcuts in `mix.exs`:
```elixir
def project do
  [
    # ... other config
    aliases: aliases()
  ]
end

defp aliases do
  [
    "test.ci": ["format --check-formatted", "credo --strict", "test"],
    "setup": ["deps.get", "ecto.create", "ecto.migrate"],
    "reset": ["ecto.drop", "setup"]
  ]
end
```

## Project Templates

### Library Template
```elixir
# lib/my_lib.ex
defmodule MyLib do
  @moduledoc """
  Documentation for `MyLib`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MyLib.hello()
      :world

  """
  def hello do
    :world
  end
end
```

### Application Template
```elixir
# lib/my_app/application.ex
defmodule MyApp.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      # Add your supervised processes here
      {MyApp.Server, []}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Best Practices

1. **Keep mix.exs clean** - Use private functions for complex configurations
2. **Use semantic versioning** - Follow semver for releases
3. **Lock your dependencies** - Commit `mix.lock` to version control
4. **Test everything** - Aim for high test coverage
5. **Document your public API** - Use `@doc` and `@moduledoc`
6. **Use Mix environments** - Separate dev, test, and prod configurations

## Next Steps

Create your first Mix project and explore the examples, then move on to `09_testing/` to learn about testing with ExUnit!
