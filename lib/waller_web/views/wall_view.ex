defmodule WallerWeb.WallView do
  use WallerWeb, :view
  alias WallerWeb.WallView

  def render("index.json", %{wall: wall}) do
    %{data: render_many(wall, WallView, "wall.json")}
  end

  def render("index_user.json", %{ users: users }) do
    %{data: render_many(users, WallerWeb, "user.json")}
  end

  def render("show.json", %{wall: wall}) do
    %{data: render_one(wall, WallView, "wall.json")}
  end

  def render("wall.json", %{wall: wall}) do
    %{id: wall.id,
      name: wall.name,
      age: wall.age}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      age: user.age,
      photo: user.photo
    }
  end
end
