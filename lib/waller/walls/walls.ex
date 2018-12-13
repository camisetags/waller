defmodule Waller.Walls do
  @moduledoc """
  The Walls context.
  """
  import Enum, only: [map: 2]
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  
  alias Waller.Repo
  alias Waller.Walls.Wall
  alias Waller.Walls.UserWall
  alias Waller.Participants.User

  def get_wall!(id), do: Repo.get!(Wall, id)

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> put_user(wall_users)
    |> Repo.insert()
  end

  def send_vote(%{wall_id: wall_id, user_id: user_id}) do
    wall_with_user_wall(%{wall_id: wall_id, user_id: user_id})
    |> Repo.all()
    |> case do
      [{user_wall, wall}] -> compute_vote({user_wall, wall})
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
    |> build_complete_wall()
  end

  defp put_user(changeset, user_list) do
    Changeset.put_assoc(changeset, :users, user_list)
  end
  
  defp complete_wall(wall_id) do
    from wall in Wall,
      join: user_wall in UserWall, on: wall.id == user_wall.wall_id,
      join: user in User, on: user_wall.user_id == user.id,
      where: wall.id == ^wall_id,
      select: %{ wall: wall, user: user, user_wall: user_wall}
  end
  
  defp wall_with_user_wall(%{user_id: user_id, wall_id: wall_id}) do
    from user_wall in UserWall,
      join: wall in Wall, on: user_wall.wall_id == wall.id,
      where: user_wall.user_id == ^user_id and user_wall.wall_id == ^wall_id,
      select: {user_wall, wall}
  end

  defp build_complete_wall(query_result) do
    [%{wall: wall, user: _, user_wall: _} | _] = query_result
    %Wall{
      id: wall.id,
      running: wall.running,
      result_date: wall.result_date,
      users: query_result |> map(fn result -> 
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

  defp compute_vote({_, %{running: running}}) when not running do
    {:error, ["This wall is not running anymore..."]}
  end

  defp compute_vote({%UserWall{} = user_wall, _}) do
    user_wall
    |> UserWall.changeset(%{votes: user_wall.votes + 1})
    |> Repo.update()
  end
end
