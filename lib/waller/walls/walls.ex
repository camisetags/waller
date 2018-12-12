defmodule Waller.Walls do
  @moduledoc """
  The Walls context.
  """
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  
  alias Waller.Repo
  alias Waller.Walls.Wall
  alias Waller.Walls.UserWall
  # alias Waller.Participants.User

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> put_user(wall_users)
    |> Repo.insert
  end

  def send_vote(%{wall_id: wall_id, user_id: user_id}) do
    wall_with_user(%{wall_id: wall_id, user_id: user_id})
    |> Repo.all
    |> case do
      [{user_wall, wall}] -> compute_vote({user_wall, wall})
      [] -> {:error, ["This wall or participant does not exists."]}
    end
  end

  defp put_user(changeset, user_list) do
    Changeset.put_assoc(changeset, :users, user_list) 
  end

  defp wall_with_user(%{user_id: user_id, wall_id: wall_id}) do
    from user_wall in UserWall,
      join: wall in Wall, on: user_wall.wall_id == wall.id,
      where: user_wall.user_id == ^user_id and user_wall.wall_id == ^wall_id,
      select: {user_wall, wall}
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
