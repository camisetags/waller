defmodule WallerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WallerWeb, :controller

  def call(conn, {:ok, result}) do
    conn
    |> put_status(:ok)
    |> json(%{data: result})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WallerWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(WallerWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(WallerWeb.ErrorView)
    |> render("error.json", error: error)
  end
end
