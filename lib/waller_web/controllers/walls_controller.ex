defmodule WallerWeb.WallsController do
  use WallerWeb, :controller
  # require IEx

  alias Waller.Participants
  alias Waller.Participants.User
  
  # alias Waller.Walls
  # alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  def create(conn, %{"user_ids" => params}) do
    users = Participants.list_user_in(params)

    case Participants.list_user_in(params) do
      { :ok, users } -> conn |> form_wall(%{content: users}) 
      { :error, error } -> conn |> json(%{error: error})
    end
  end

  defp form_wall(conn, wall_users) when length(wall_users) < 2 do
    conn |> json(%{error: "You need at least 2 participants to form a wall"})
  end

  defp form_wall(conn, wall_users) do

  end
end
