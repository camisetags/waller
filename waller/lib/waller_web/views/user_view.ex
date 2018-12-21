defmodule WallerWeb.UserView do
  use WallerWeb, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
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
