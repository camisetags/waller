defmodule Waller.Wall.CacheLayer do
  import Enum, only: [map: 2]

  alias Waller.Wall.WallRepo
  alias Waller.RedixPool
  alias Waller.Wall.Wall
  alias Waller.User.UserRepo

  @votes_count_size 90
  @cache_time 5 * 60

  def send_vote(%{wall_id: wall_id, user_id: user_id}) do
    cache_key = "votes_from_mem_#{wall_id}_#{user_id}"
    votes_count = votes_from_mem(%{wall_id: wall_id, user_id: user_id}) + 1
    user_or_wall_exists = check_wall_or_user_exists(wall_id: wall_id, user_id: user_id)

    if user_or_wall_exists do
      if votes_count === @votes_count_size do
        set_mem_votes(cache_key, 0)
        RedixPool.command(["DEL", "status_#{wall_id}"])

        persist_vote(%{wall_id: wall_id, user_id: user_id}, votes_count)
      else
        set_mem_votes(cache_key, votes_count)
      end
    else
      {:error, ["Wall or user does not exists."]}
    end
  end

  defp persist_vote(%{wall_id: wall_id, user_id: user_id}, votes_count) do
    vote_data = %{wall_id: wall_id, user_id: user_id}

    with {:ok, result} <- WallRepo.send_vote(vote_data, votes_count) do
      {:ok, result}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp set_mem_votes(cache_key, votes_count) do
    with {:ok, "OK"} <- RedixPool.command(["SET", cache_key, votes_count]) do
      {:ok, votes_count}
    else
      {:error, error} -> {:error, error}
    end
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

  defp check_wall_or_user_exists(wall_id: wall_id, user_id: user_id) do
    with {:ok, _} <- get_user(user_id),
         {:ok, _} <- get_wall(wall_id) do
      true
    else
      {:error, _} -> false
    end
  end

  defp get_user(user_id) do
    case RedixPool.command(["GET", "user_id_#{user_id}"]) do
      {:ok, nil} ->
        try do
          user = UserRepo.get_user!(user_id)
          RedixPool.command(["SET", "user_id_#{user_id}", Poison.encode!(user)])
          {:ok, user}
        rescue
          Ecto.NoResultsError -> {:error, false}
        end

      {:ok, value} ->
        {:ok, Poison.decode!(value)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp get_wall(wall_id) do
    case(RedixPool.command(["GET", "wall_id_#{wall_id}"])) do
      {:ok, nil} ->
        try do
          wall = WallRepo.get_wall!(wall_id)
          RedixPool.command(["SET", "wall_id_#{wall_id}", Poison.encode!(wall)])
          {:ok, wall}
        rescue
          Ecto.NoResultsError -> {:error, false}
        end

      {:ok, value} ->
        {:ok, Poison.decode!(value)}

      {:error, error} ->
        {:error, error}
    end
  end
end
