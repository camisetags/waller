defmodule WallerWeb.WallsView do
  use WallerWeb, :view
  # alias WallerWeb.WallsView
  alias Waller.Participants.User

  def render("index.json", %{wall: wall}) do
    %{data: render_many(wall, __MODULE__, "wall.json")}
  end

  def render("wall_users.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "wall_user.json", as: :wall_user)}
  end

  def render("show.json", %{wall: wall}) do
    %{data: render_one(wall, __MODULE__, "wall.json", as: :wall)}
  end

  def render("wall.json", %{wall: wall}) do
    %{
      id: wall.id,
      running: wall.running,
      result_date: wall.result_date,
      users: render_many(wall.users, __MODULE__, "wall_user.json", as: :wall_user)
    }
  end

  def render("wall_user.json", %{wall_user: wall_user}) do
    %{
      id: wall_user.id,
      name: wall_user.name,
      age: wall_user.age,
      photo: wall_user.photo
    }
  end
end
