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
end
