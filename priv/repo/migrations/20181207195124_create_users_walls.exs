defmodule Waller.Repo.Migrations.CreateUsersWalls do
  use Ecto.Migration

  def change do
    create table(:users_walls) do
      add :user_id, references(:users, on_delete: :nothing)
      add :wall_id, references(:walls, on_delete: :nothing)

      timestamps()
    end

    create index(:users_walls, [:user_id])
    create index(:users_walls, [:wall_id])
  end
end
