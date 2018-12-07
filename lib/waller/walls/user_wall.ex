defmodule Waller.Walls.UserWall do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users_walls" do
    field :user_id, :id
    field :wall_id, :id

    field :votes, :integer

    timestamps()
  end

  @doc false
  def changeset(user_wall, attrs) do
    user_wall
    |> cast(attrs, [])
    |> validate_required([])
  end
end
