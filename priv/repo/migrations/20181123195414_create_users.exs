defmodule Waller.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :photo, :string

      timestamps()
    end

  end
end
