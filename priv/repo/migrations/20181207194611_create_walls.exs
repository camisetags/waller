defmodule Waller.Repo.Migrations.CreateWalls do
  use Ecto.Migration

  def change do
    create table(:walls) do
      add :number, :integer

      timestamps()
    end

  end
end
