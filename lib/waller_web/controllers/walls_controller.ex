defmodule WallerWeb.WallsController do
  use WallerWeb, :controller
  # require IEx
  # import Ecto.Query, warn: false
  alias Ecto
  alias Waller.Participants
  # alias Waller.Participants.User

  alias Waller.Walls
  alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  def create(conn, %{"user_ids" => params, "result_date" => result}) do
    Participants.list_user_in(params)
    |> form_wall(result, conn)
  end

  def vote(conn, %{"wall_id" => wall_id, "user_id" => user_id}) do
    case Walls.send_vote(%{wall_id: wall_id, user_id: user_id}) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Your vote was computed!"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def close(conn, %{"wall_id" => wall_id}) do
    case Walls.close_wall(wall_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "The wall was closed"})

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: ["There was an internal error"]})
    end
  end

  def status(conn, %{"wall_id" => wall_id}) do
    case Walls.status(wall_id) do
      %Wall{} = wall ->
        conn
        |> put_status(:ok)
        |> json(%{data: wall})
      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: ["There was an internal error"]})
    end
  end

  defp form_wall(wall_users, _, conn) when length(wall_users) < 2 do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "You need at least 2 participants to form a wall"})
  end

  defp form_wall(wall_users, result, conn) do
    wall = %{
      running: true,
      result_date: Date.from_iso8601!(result)
    }

    create_new_wall(conn, wall, wall_users)
  end

  defp create_new_wall(conn, wall, wall_users) do
    case Walls.form_wall(wall, wall_users) do
      {:ok, created_wall} ->
        conn
        |> put_status(:created)
        |> render("show.json", wall: created_wall)

      {:error, %Ecto.Changeset{} = _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: ["Cannot create wall"]})
    end
  end
end
