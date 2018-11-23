defmodule Waller.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :age, :integer

      timestamps()
    end

  end
end
