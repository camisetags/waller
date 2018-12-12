defmodule Waller.Walls.UserWall do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users_walls" do
    field :user_id, :id
    field :wall_id, :id

    field :votes, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(user_wall, attrs) do
    user_wall
    |> cast(attrs, [:votes])
    |> validate_required([:votes])
  end
end
