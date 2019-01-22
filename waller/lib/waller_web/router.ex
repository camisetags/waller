defmodule WallerWeb.Router do
  use WallerWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/api", WallerWeb do
    pipe_through :api

    resources "/users", UserController
    
    get "/walls", WallsController, :index
    post "/walls", WallsController, :create
    post "/walls/vote/:wall_id/to/:user_id", WallsController, :vote
    post "/walls/close/:wall_id", WallsController, :close
    get "/walls/status/:wall_id", WallsController, :status
    options "/walls/status/:wall_id", WallsController, :options
  end

  scope "/", WallerWeb do
    pipe_through :api

    get "/", RootController, :index
    post "/verify-captcha", RootController, :verify_captcha
    options "/verify-captcha", RootController, :options
  end
end
