defmodule Mestatus.Repo.Migrations.CreateUserStatus do
  use Ecto.Migration

  def change do
    create table(:user_statuses) do
      add :username, :string
      add :status, :string

      timestamps
    end

  end
end
