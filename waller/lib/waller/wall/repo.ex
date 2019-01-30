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

  def send_vote(%{wall_id: wall_id, user_id: user_id}, votes_count \\ @votes_count_size) do
    wall_with_user_wall(%{wall_id: wall_id, user_id: user_id})
    |> Repo.all()
    |> case do
      [{user_wall, wall}] -> {:ok, persist_vote({user_wall, wall}, votes_count)}
      [] -> {:error, ["This wall or participant does not exists."]}
    end
  end

  defp associate_user_to_wall(changeset, user_list) do
    Ecto.Changeset.put_assoc(changeset, :users, user_list)
  end

  defp wall_with_user_wall(%{user_id: user_id, wall_id: wall_id}) do
    from(user_wall in UserWall,
      join: wall in Wall,
      on: user_wall.wall_id == wall.id,
      where: user_wall.user_id == ^user_id and user_wall.wall_id == ^wall_id,
      select: {user_wall, wall}
    )
  end

  defp persist_vote({_, %{running: running}}, _) when not running do
    {:error, ["This wall is not running anymore..."]}
  end

  defp persist_vote({%UserWall{} = user_wall, _}, votes_count) do
    user_wall
    |> UserWall.changeset(%{votes: user_wall.votes + votes_count})
    |> Repo.update()

    user_wall.votes
  end
end
