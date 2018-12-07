defmodule WallerWeb.WallsController do
  use WallerWeb, :controller

  alias Waller.Participants
  alias Waller.Participants.User
  
  alias Waller.Walls
  alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  # def index(conn, _params) do
  #   user = Participants.list_user()
  #   render(conn, "index.json", user: user)
  # end

  def create_wall(conn, %{wall: wall_params}) do
    "to complete"
    # conn

    # with {:ok, %Wall{} = wall} <- Walls.create_wall(wall_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", Routes.user_path(conn, :show, user))
    #   |> render("show.json", user: user)
    # end
  end
end
