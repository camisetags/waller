defmodule WallerWeb.WallsController do
  use WallerWeb, :controller
  require IEx

  alias Waller.Participants
  # alias Waller.Participants.User
  
  # alias Waller.Walls
  # alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  def create(conn, %{"_json" => params}) do
    # case Participants.list_user_in(params) do
    #   { :ok, users } -> conn |> json(%{content: users})
    #   { :error, error} -> conn |> json(%{error: error})
    # end
    users = Participants.list_user_in(params)
    render(conn, "index_user.json", users: users)
  end
end
