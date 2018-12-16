defmodule Waller.Wall.Model do
  use Ecto.Schema
  import Ecto.Changeset
  alias Waller.User.Model, as: User
  alias Waller.Wall.UserWall

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "walls" do
    field :running, :boolean
    field :result_date, :date

    many_to_many :users, User, join_through: UserWall

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

defmodule Waller.Wall.UserWall do
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
