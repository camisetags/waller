defmodule Waller.Repo.Migrations.AddVotesToUsersVotesTable do
  use Ecto.Migration

  def change do
    alter table(:users_walls) do
      add :votes, :integer
    end
  end
end
