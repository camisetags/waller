defmodule WallerWeb.WallsController do
  use WallerWeb, :controller

  alias Waller.Participants
  alias Waller.Participants.User
  
  alias Waller.Walls
  alias Waller.Walls.Wall

  action_fallback WallerWeb.FallbackController

  def create(conn, %{"_json" => params}) do
    conn |> json(%{content: params})
  end
end
