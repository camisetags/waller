defmodule WallerWeb.Router do
  use WallerWeb, :router

  pipeline :api do
    plug(CORSPlug)
    plug(:accepts, ["json"])
  end

  scope "/api", WallerWeb do
    pipe_through(:api)

    resources("/users", UserController)

    get("/walls", WallsController, :index)
    post("/walls", WallsController, :create)
    post("/walls/vote/:wall_id/to/:user_id", WallsController, :vote)

    options("/walls", WallsController, :options)
  end

  scope "/", WallerWeb do
    pipe_through(:api)

    get("/", RootController, :index)
  end
end
