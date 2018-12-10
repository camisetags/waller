defmodule Waller.Walls.Wall do
  use Ecto.Schema
  import Ecto.Changeset


  schema "walls" do
    field :number, :integer

    many_to_many :users, Waller.Participants.User, join_through: Waller.Participants.User

    timestamps()
  end

  @doc false
  def changeset(wall, attrs) do
    wall
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end

  def form_wall_changeset() do
  end
end
