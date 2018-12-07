defmodule Waller.Walls do
  @moduledoc """
  The Participants context.
  """

  import Ecto.Query, warn: false
  alias Waller.Repo

  alias Waller.Walls.Wall

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_wall()
      [%Wall{}, ...]

  """
  def list_wall do
    Repo.all(Wall)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_wall!(123)
      %Wall{}

      iex> get_wall!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wall!(id), do: Repo.get!(Wall, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_wall(%{field: value})
      {:ok, %Wall{}}

      iex> create_wall(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wall(attrs \\ %{}) do
    %Wall{}
    |> Wall.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_wall(user, %{field: new_value})
      {:ok, %Wall{}}

      iex> update_wall(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wall(%Wall{} = wall, attrs) do
    wall
    |> Wall.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_wall(user)
      {:ok, %Wall{}}

      iex> delete_wall(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wall(%Wall{} = wall) do
    Repo.delete(wall)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_wall(user)
      %Ecto.Changeset{source: %Wall{}}

  """
  def change_wall(%Wall{} = wall) do
    Wall.changeset(wall, %{})
  end
end
