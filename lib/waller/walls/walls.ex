defmodule Waller.Walls do
  @moduledoc """
  The Participants context.
  """

  # import Ecto.Query, warn: false
  alias Ecto
  alias Waller.Repo

  alias Waller.Walls.Wall
  alias Waller.Participants.User

  def form_wall(wall_params \\ %{}, wall_users) do
    %Wall{}
    |> Wall.changeset(wall_params)
    |> put_user(wall_users)
    |> Repo.insert
  end

  defp put_user(changeset, user_list) do
    Ecto.Changeset.put_assoc(changeset, :users, user_list) 
  end
end
