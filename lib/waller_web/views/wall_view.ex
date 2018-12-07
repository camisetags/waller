defmodule WallerWeb.WallView do
  use WallerWeb, :view
  alias WallerWeb.WallView

  def render("index.json", %{wall: wall}) do
    %{data: render_many(wall, WallView, "wall.json")}
  end

  def render("show.json", %{wall: wall}) do
    %{data: render_one(wall, WallView, "wall.json")}
  end

  def render("wall.json", %{wall: wall}) do
    %{id: wall.id,
      name: wall.name,
      age: wall.age}
  end
end
