defmodule Waller.User.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Waller.Wall.Wall
  alias Waller.Wall.UserWall

  # @derive {Poison.Encoder, except: [:__meta__]}
  @derive {Poison.Encoder, only: [ :age, :name, :photo, :votes ]}
  schema "users" do 
    field :age, :integer
    field :name, :string
    field :photo, :string
    field :votes, :integer, virtual: true

    many_to_many(:walls, Wall, join_through: UserWall)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user_fields = [:name, :age, :photo]

    user
    |> cast(attrs, user_fields)
    |> validate_required(user_fields)
  end
end
