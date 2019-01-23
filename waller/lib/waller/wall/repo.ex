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

  def get_wall!(id), do: Repo.get!(Wall, id)

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> put_user(wall_users)
    |> Repo.insert()
  end

  def send_vote(%{wall_id: wall_id, user_id: user_id}, votes_count \\ @votes_count_size) do
    wall_with_user_wall(%{wall_id: wall_id, user_id: user_id})
    |> Repo.all()
    |> case do
      [{user_wall, wall}] -> compute_vote({user_wall, wall}, votes_count)
      [] -> {:error, ["This wall or participant does not exists."]}
    end
  end

  def close_wall(wall_id) do
    get_wall!(wall_id)
    |> Wall.changeset(%{running: false})
    |> Repo.update()
  end

  def status(wall_id) do
    complete_wall(wall_id)
    |> Repo.all()
    |> case do
      [] -> {:error, ["There is no wall with this id"]}
      wall_data -> build_complete_wall(wall_data)
    end
  end

  def all_paginated(page: page, page_size: page_size) do
    from(w in Wall, preload: [:users])
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def only_double(page: page, page_size: page_size) do
    from(w in Wall,
      preload: [:users],
      join: uw in UserWall,
      on: w.id == uw.wall_id,
      join: u in User,
      on: uw.user_id == u.id,
      group_by: w.id,
      having: count(u) == 2,
      select: [w]
    )
    |> Repo.paginate(page: page, page_size: page_size)
  end

  defp put_user(changeset, user_list) do
    Ecto.Changeset.put_assoc(changeset, :users, user_list)
  end

  defp complete_wall(wall_id) do
    from wall in Wall,
      join: user_wall in UserWall,
      on: wall.id == user_wall.wall_id,
      join: user in User,
      on: user_wall.user_id == user.id,
      where: wall.id == ^wall_id,
      select: %{wall: wall, user: user, user_wall: user_wall}
  end

  defp wall_with_user_wall(%{user_id: user_id, wall_id: wall_id}) do
    from user_wall in UserWall,
      join: wall in Wall,
      on: user_wall.wall_id == wall.id,
      where: user_wall.user_id == ^user_id and user_wall.wall_id == ^wall_id,
      select: {user_wall, wall}
  end

  defp build_complete_wall(query_result) do
    [%{wall: wall, user: _, user_wall: _} | _] = query_result

    %Wall{
      id: wall.id,
      running: wall.running,
      result_date: wall.result_date,
      users:
        query_result
        |> map(fn result ->
          %{
            id: result.user.id,
            name: result.user.name,
            photo: result.user.photo,
            age: result.user.age,
            votes: result.user_wall.votes
          }
        end)
    }
  end

  defp compute_vote({_, %{running: running}}, _) when not running do
    {:error, ["This wall is not running anymore..."]}
  end

  defp compute_vote({%UserWall{} = user_wall, _}, votes_count) do
    user_wall
    |> UserWall.changeset(%{votes: user_wall.votes + votes_count})
    |> Repo.update()

    user_wall.votes
  end
end

defmodule Waller.Wall.CacheLayer do
  import Enum, only: [map: 2]

  alias Waller.Wall.WallRepo
  alias Waller.RedixPool
  alias Waller.Wall.Wall

  @votes_count_size 90
  @cache_time 5 * 60

  def status(wall_id) do
    case RedixPool.command(["GET", "status_#{wall_id}"]) do
      {:ok, nil} ->
        WallRepo.status(wall_id)
        |> set_status_cache()
        |> sum_votes_mem_with_cache()

      {:ok, value} ->
        value
        |> Poison.decode(%{keys: :atoms!})
        |> elem(1)
        |> sum_votes_mem_with_cache()

      {:error, error} ->
        {:error, error}
    end
  end

  def send_vote(%{wall_id: wall_id, user_id: user_id}) do
    cache_key = "votes_from_mem_#{wall_id}_#{user_id}"
    votes_count = votes_from_mem(%{wall_id: wall_id, user_id: user_id}) + 1

    if votes_count === @votes_count_size do
      set_mem_votes(cache_key, 0)
      RedixPool.command(["DEL", "status_#{wall_id}"])

      {:ok,
       WallRepo.send_vote(
         %{wall_id: wall_id, user_id: user_id},
         votes_count
       )}
    else
      set_mem_votes(cache_key, votes_count)
    end
  end

  defp set_mem_votes(cache_key, votes_count) do
    case RedixPool.command(["SET", cache_key, votes_count]) do
      {:ok, "OK"} -> {:ok, votes_count}
      {:error, error} -> {:error, error}
    end
  end

  defp set_status_cache({:error, message}) do
    {:error, message}
  end

  defp set_status_cache(status) do
    cache_key = "status_#{status.id}"
    encoded_value = Poison.encode(status) |> elem(1)

    status =
      case RedixPool.command(["SET", cache_key, encoded_value]) do
        {:ok, "OK"} -> status
        {:error, error} -> {:error, error}
      end

    RedixPool.command(["EXPIRE", cache_key, @cache_time])

    status
  end

  defp sum_votes_mem_with_cache({:error, message}) do
    {:error, message}
  end

  defp sum_votes_mem_with_cache(cached_wall) do
    %Wall{
      id: cached_wall.id,
      running: cached_wall.running,
      result_date: cached_wall.result_date,
      users:
        cached_wall.users
        |> map(fn user ->
          %{
            id: user.id,
            name: user.name,
            photo: user.photo,
            age: user.age,
            votes:
              user.votes +
                votes_from_mem(%{
                  wall_id: cached_wall.id,
                  user_id: user.id
                })
          }
        end)
    }
  end

  defp votes_from_mem(%{wall_id: wall_id, user_id: user_id}) do
    cache_key = "votes_from_mem_#{wall_id}_#{user_id}"

    case RedixPool.command(["GET", cache_key]) do
      {:ok, nil} -> 0
      {:ok, "0"} -> 0
      {:ok, value} -> Integer.parse(value) |> elem(0)
      {:error, error} -> {:error, error}
    end
  end
end
