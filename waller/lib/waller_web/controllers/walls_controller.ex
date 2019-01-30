defmodule WallerWeb.WallsController do
  use WallerWeb, :controller

  alias Ecto
  alias Waller.User.UserRepo
  alias Scrivener.Page

  alias Waller.Wall.WallRepo
  alias Waller.Wall.Wall
  alias Waller.Wall.CacheLayer, as: WallCacheLayer

  action_fallback(WallerWeb.FallbackController)

  def create(conn, %{"user_ids" => ids, "result_date" => result}) do
    UserRepo.list_user_in(ids)
    |> form_wall(result, conn)
  end

  defp form_wall(wall_users, _, conn) when length(wall_users) < 2 do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "You need at least 2 participants to form a wall"})
  end

  defp form_wall(wall_users, result, conn) do
    with {:ok, datetime, _} <- DateTime.from_iso8601(result) do
      wall = %{
        running: true,
        result_date: datetime
      }

      create_new_wall(conn, wall, wall_users)
    else
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error})
    end
  end

  defp create_new_wall(conn, wall, wall_users) do
    case WallRepo.form_wall(wall, wall_users) do
      {:ok, created_wall} ->
        conn
        |> put_status(:created)
        |> render("show.json", wall: created_wall)

      {:error, %Ecto.Changeset{} = error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error.errors})
    end
  end
end
