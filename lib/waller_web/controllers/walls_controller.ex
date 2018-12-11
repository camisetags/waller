defmodule WallerWeb.WallsController do
  use WallerWeb, :controller
  # require IEx
  alias Waller.Participants
  alias Waller.Participants.User
  
  alias Waller.Walls
  alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  def create(conn, %{"user_ids" => params, "result_date" => result}) do
    Participants.list_user_in(params)
    |> form_wall(result, conn)
  end

  defp form_wall(wall_users, result, conn) when length(wall_users) < 2 do
    conn 
    |> put_status(:unprocessable_entity)
    |> json(%{error: "You need at least 2 participants to form a wall"})
  end
  
  defp form_wall(wall_users, result, conn) do
    wall = %{
      running: true,
      result_date: Date.from_iso8601!(result), 
      users: wall_users,
    }

    case Walls.form_wall(wall) do
      {:ok, created_wall} -> 
        conn
        |> put_status(:created)
        |> render("show.json", wall: created_wall)
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: ["Cannot create wall"]})
    end
  end
end
