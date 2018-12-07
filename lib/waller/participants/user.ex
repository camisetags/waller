defmodule Waller.Participants.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :age, :integer
    field :name, :string
    field :photo, :string

    many_to_many :walls, Waller.Walls.Wall, join_through: Waller.Walls.UserWall

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
