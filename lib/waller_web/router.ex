defmodule WallerWeb.Router do
  use WallerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WallerWeb do
    pipe_through :api
  end
end
