defmodule WallerWeb.WallsController do
  use WallerWeb, :controller

  alias Ecto
  alias Waller.User.UserRepo
  alias Scrivener.Page

  alias Waller.Wall.WallRepo
  alias Waller.Wall.Wall
  alias Waller.Wall.CacheLayer, as: WallCacheLayer

  action_fallback WallerWeb.FallbackController

  def index(conn, %{"only_double" => only_double, "page" => page}) when only_double == "true" do
    take_doubles(conn, page: page)
  end

  def index(conn, %{"page" => page}) do
    take_all(conn, page: page)
  end

  def index(conn, _params) do
    take_all(conn, page: 1)
  end

  def create(conn, %{"user_ids" => params, "result_date" => result}) do
    UserRepo.list_user_in(params)
    |> form_wall(result, conn)
  end

  def vote(conn, %{"wall_id" => wall_id, "user_id" => user_id}) do
    case WallCacheLayer.send_vote(%{wall_id: wall_id, user_id: user_id}) do
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
    case WallRepo.close_wall(wall_id) do
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
    case WallCacheLayer.status(wall_id) do
      %Wall{} = wall ->
        conn
        |> put_status(:ok)
        |> json(%{data: wall})

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
    wall = %{
      running: true,
      result_date: Date.from_iso8601!(result)
    }

    create_new_wall(conn, wall, wall_users)
  end

  defp create_new_wall(conn, wall, wall_users) do
    case WallRepo.form_wall(wall, wall_users) do
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

  defp take_doubles(conn, %{page: page}) do
    case WallRepo.only_double(page, 30) do
      %Page{} = result ->
        conn
        |> put_status(:ok)
        |> json(result)

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: "An internal server error has occured."})
    end
  end

  defp take_all(conn, %{page: page}) do
    case WallRepo.all_paginated(page: page, page_size: 30) do
      %Page{} = result ->
        conn
        |> put_status(:ok)
        |> json(%{data: result})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: "An internal server error has occured."})
    end
  end
end
