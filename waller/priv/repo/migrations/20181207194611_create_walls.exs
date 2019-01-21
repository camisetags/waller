defmodule Waller.Repo.Migrations.CreateWalls do
  use Ecto.Migration

  def change do
    create table(:walls) do
      add :running, :boolean
      add :result_date, :date

      timestamps()
    end

  end
end
