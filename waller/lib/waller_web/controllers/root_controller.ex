defmodule WallerWeb.RootController do
  use WallerWeb, :controller

  def index(conn, _params) do
    conn |> json(%{message: "Welcome!"})
  end
end
