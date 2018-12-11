defmodule Waller.Walls.Wall do
  use Ecto.Schema
  import Ecto.Changeset


  schema "walls" do
    field :running, :boolean
    field :result_date, :date

    many_to_many :users, Waller.Participants.User, join_through: Waller.Walls.UserWall

    timestamps()
  end

  @doc false
  def changeset(wall, attrs) do
    fields = [:running, :result_date]
    wall
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
