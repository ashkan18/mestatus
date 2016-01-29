defmodule Mestatus.Repo.Migrations.AddAppToUserStataus do
  use Ecto.Migration

  def change do
    alter table(:user_statuses) do
      add :app, :string
    end
  end
end
