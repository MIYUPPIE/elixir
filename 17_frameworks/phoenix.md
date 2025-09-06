# Phoenix Web Framework

Phoenix is Elixir's most popular web framework. It's designed for building scalable, real-time web applications that can handle millions of connections.

## Why Phoenix?

- **Productivity** - Rails-like developer experience
- **Performance** - Handle millions of connections
- **Real-time** - Built-in WebSocket support via Channels
- **Fault Tolerance** - Inherits Elixir's crash-resistance
- **Live View** - Build interactive UIs without JavaScript

## Getting Started with Phoenix

### Installation
```bash
# Install Phoenix generator
mix archive.install hex phx_new

# Create a new Phoenix app
mix phx.new my_app
cd my_app

# Setup database (PostgreSQL by default)
mix ecto.create

# Start the server
mix phx.server
```

### Project Structure
```
my_app/
├── lib/
│   ├── my_app/           # Business logic
│   └── my_app_web/       # Web interface
│       ├── controllers/
│       ├── views/
│       ├── templates/
│       ├── channels/
│       └── router.ex
├── assets/               # Frontend assets
├── test/
├── config/
└── priv/
    ├── repo/migrations/  # Database migrations
    └── static/          # Static files
```

## Routing

```elixir
# lib/my_app_web/router.ex
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/users", UserController
    get "/profile/:id", UserController, :profile
  end

  scope "/api", MyAppWeb do
    pipe_through :api
    
    resources "/users", UserApiController, except: [:new, :edit]
    post "/auth/login", AuthController, :login
  end
end
```

## Controllers

```elixir
# lib/my_app_web/controllers/user_controller.ex
defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller
  
  alias MyApp.Accounts
  alias MyApp.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_flash(:error, "User not found")
        |> redirect(to: ~p"/users")
      
      user ->
        render(conn, :show, user: user)
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
```

## Live View - Interactive UIs

LiveView lets you build interactive UIs with server-side rendering:

```elixir
# lib/my_app_web/live/counter_live.ex
defmodule MyAppWeb.CounterLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def render(assigns) do
    ~H"""
    <div class="counter">
      <h1>Count: <%= @count %></h1>
      <button phx-click="inc">+</button>
      <button phx-click="dec">-</button>
    </div>
    """
  end
end
```

## Channels - Real-time Communication

```elixir
# lib/my_app_web/channels/room_channel.ex
defmodule MyAppWeb.RoomChannel do
  use MyAppWeb, :channel

  def join("room:lobby", _params, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id, %{"user_id" => user_id}, socket) do
    if authorized?(room_id, user_id) do
      socket = assign(socket, :room_id, room_id)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_message", %{"message" => message}, socket) do
    broadcast(socket, "new_message", %{
      message: message,
      user: socket.assigns.user_id,
      timestamp: DateTime.utc_now()
    })
    {:noreply, socket}
  end

  def handle_in("typing", _params, socket) do
    broadcast_from(socket, "user_typing", %{user: socket.assigns.user_id})
    {:noreply, socket}
  end

  defp authorized?(_room_id, _user_id), do: true
end

# Add to socket handler
defmodule MyAppWeb.UserSocket do
  use Phoenix.Socket

  channel "room:*", MyAppWeb.RoomChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    case verify_token(token) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _} -> :error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
```

## Context Pattern

Organize business logic into contexts:

```elixir
# lib/my_app/accounts.ex
defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context - handles user-related business logic.
  """
  
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(user) do
    Repo.delete(user)
  end

  def change_user(user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil -> {:error, "Invalid credentials"}
      user -> verify_password(user, password)
    end
  end

  defp get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Invalid credentials"}
    end
  end
end
```

## Database with Ecto

```elixir
# lib/my_app/accounts/user.ex
defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    
    has_many :posts, MyApp.Blog.Post

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
```

## Testing Phoenix

```elixir
# test/my_app_web/controllers/user_controller_test.exs
defmodule MyAppWeb.UserControllerTest do
  use MyAppWeb.ConnCase

  import MyApp.AccountsFixtures

  describe "index" do
    test "lists all users", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/users")
      assert html_response(conn, 200) =~ user.name
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      valid_attrs = %{name: "Alice", email: "alice@example.com", password: "password123"}
      
      conn = post(conn, ~p"/users", user: valid_attrs)
      
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/users/#{id}"
      
      conn = get(conn, ~p"/users/#{id}")
      assert html_response(conn, 200) =~ "Alice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{name: "", email: "invalid", password: "123"}
      conn = post(conn, ~p"/users", user: invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end
end

# Test LiveView
defmodule MyAppWeb.CounterLiveTest do
  use MyAppWeb.ConnCase
  import Phoenix.LiveViewTest

  test "counter increments", %{conn: conn} do
    {:ok, view, html} = live(conn, "/counter")
    
    assert html =~ "Count: 0"
    
    html = view |> element("button", "+") |> render_click()
    assert html =~ "Count: 1"
  end
end
```

## Deployment

### Production Configuration
```elixir
# config/prod.exs
import Config

config :my_app, MyAppWeb.Endpoint,
  url: [host: "myapp.com", port: 443, scheme: "https"],
  http: [port: 4000],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: System.get_env("SSL_CERT_PATH"),
    keyfile: System.get_env("SSL_KEY_PATH")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :my_app, MyApp.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
```

### Release
```bash
# Build a release
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix compile
MIX_ENV=prod mix release

# Run the release
_build/prod/rel/my_app/bin/my_app start
```

## Phoenix Best Practices

1. **Use contexts** - Keep business logic separate from web logic
2. **Validate at boundaries** - Use changesets for data validation
3. **Handle errors gracefully** - Use proper error pages and logging
4. **Optimize queries** - Use Ecto's preloading and query optimization
5. **Monitor performance** - Use telemetry and proper logging
6. **Test thoroughly** - Test controllers, live views, and contexts

## Advanced Features

- **Phoenix PubSub** - Distributed real-time messaging
- **Phoenix Presence** - Track who's online across nodes
- **Phoenix LiveDashboard** - Real-time application monitoring
- **Telemetry** - Metrics and observability
- **Guardian** - JWT authentication
- **Oban** - Background job processing

## Next Steps

Phoenix is a deep framework with many advanced features. Start with a simple CRUD application, then explore real-time features with LiveView and Channels!
