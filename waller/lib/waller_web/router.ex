defmodule WallerWeb.Router do
  use WallerWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/", WallerWeb do
    pipe_through :api

    get "/", RootController, :index
  end
end
