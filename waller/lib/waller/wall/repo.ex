defmodule Waller.Wall.WallRepo do
  @moduledoc """
  The Walls context.
  """
  import Enum, only: [map: 2]
  import Ecto.Query, warn: false

  alias Waller.Repo
  alias Waller.Wall.Wall

  @votes_count_size 50

  def get_wall!(id), do: Repo.get!(Wall, id)

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> associate_user_to_wall(wall_users)
    |> Repo.insert()
  end

  defp associate_user_to_wall(changeset, user_list) do
    Ecto.Changeset.put_assoc(changeset, :users, user_list)
  end
end
