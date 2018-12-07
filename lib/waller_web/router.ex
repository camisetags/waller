defmodule WallerWeb.Router do
  use WallerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WallerWeb do
    pipe_through :api

    resources "/users", UserController
  end

  scope "", WallerWeb do
    pipe_through :api

    get "", RootController, :index
  end
end
