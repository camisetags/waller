defmodule WallerWeb.WallsController do
  use WallerWeb, :controller

  alias Ecto
  alias Waller.User.UserRepo
  alias Scrivener.Page

  alias Waller.Wall.WallRepo
  alias Waller.Wall.Wall
  alias Waller.Wall.CacheLayer, as: WallCacheLayer

  action_fallback(WallerWeb.FallbackController)

  def index(conn, params) do
    case params do
      %{"only_doubles" => "true"} ->
        take_doubles(conn, page: 1)

      %{"only_doubles" => "true", "page" => page} ->
        take_doubles(conn, page: page)

      %{"page" => page} ->
        take_all(conn, page: page)

      _ ->
        take_all(conn, page: 1)
    end
  end

  def create(conn, %{"user_ids" => ids, "result_date" => result}) do
    UserRepo.list_user_in(ids)
    |> form_wall(result, conn)
  end

  def vote(conn, %{"wall_id" => wall_id, "user_id" => user_id}) do
    user_or_wall_exists =
      WallCacheLayer.check_wall_or_user_exists(wall_id: wall_id, user_id: user_id)

    vote_sent = WallCacheLayer.send_vote(%{wall_id: wall_id, user_id: user_id})

    with {:ok, true} <- user_or_wall_exists,
         {:ok, _} <- vote_sent do
      conn
      |> put_status(:ok)
      |> json(%{message: "Your vote was computed!"})
    else
      {:error, %Ecto.Changeset{} = error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error.errors})

      {:error, errors} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def close(conn, %{"wall_id" => wall_id}) do
    case WallRepo.close_wall(wall_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "The wall were closed"})

      {:error, ["Wall does not exists."]} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["Wall does not exists."]})

      {:error, error} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: error})
    end
  end

  def status(conn, %{"wall_id" => wall_id}) do
    with %Wall{} = wall <- WallCacheLayer.status(wall_id) do
      conn
      |> put_status(:ok)
      |> json(%{data: wall})
    else
      {:error, error} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: error})
    end
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

  defp take_doubles(conn, page: page) do
    case WallCacheLayer.list_doubles(page: page, page_size: 30) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(%{data: result})

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: "An internal server error has occured."})
    end
  end

  defp take_all(conn, page: page) do
    case WallCacheLayer.list(page: page, page_size: 30) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(%{data: result})

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: "An internal server error has occured."})
    end
  end
end
