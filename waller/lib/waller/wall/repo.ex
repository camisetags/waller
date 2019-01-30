defmodule Waller.Wall.WallRepo do
  @moduledoc """
  The Walls context.
  """
  import Enum, only: [map: 2]
  import Ecto.Query, warn: false

  alias Waller.Repo
  alias Waller.Wall.Wall
  alias Waller.Wall.UserWall
  alias Waller.User.User

  @votes_count_size 50

  def get_wall!(id) do
    try do
      Repo.get!(Wall, id)
      |> Repo.preload(:users)
    rescue
      Ecto.NoResultsError -> {:error, ["Wall does not exists."]}
    end
  end

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> associate_user_to_wall(wall_users)
    |> Repo.insert()
  end

  def list(page: page, page_size: page_size) do
    from(w in Wall, preload: [:users])
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def list_doubles(page: page, page_size: page_size) do
    from(w in Wall,
      preload: [:users],
      join: uw in UserWall,
      on: w.id == uw.wall_id,
      join: u in User,
      on: uw.user_id == u.id,
      group_by: w.id,
      having: count(u) == 2,
      select: w
    )
    |> Repo.paginate(page: page, page_size: page_size)
  end

  defp associate_user_to_wall(changeset, user_list) do
    Ecto.Changeset.put_assoc(changeset, :users, user_list)
  end
end
