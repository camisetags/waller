defmodule Waller.Walls do
  @moduledoc """
  The Participants context.
  """

  import Ecto.Query, warn: false
  alias Waller.Repo

  alias Waller.Walls.Wall
  alias Waller.Participants.User

  def form_wall(wall_params) do
    # wall = Wall.changeset(%Wall{}, wall_params)
    # users = User.changeset(%User{}, users_params)
    # Ecto.Changeset.put_assoc(wall, :users, users)
    # |> Repo.insert
    wall = Repo.preload(wall_params, :users)
    users = wall.users |> Enum.map(&Ecto.Changeset.change/1)

    wall
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:users, users)
    |> Repo.insert!
  end
end
