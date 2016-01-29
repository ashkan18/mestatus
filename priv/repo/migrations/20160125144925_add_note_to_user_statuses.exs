defmodule Mestatus.Repo.Migrations.AddNoteToUserStatuses do
  use Ecto.Migration

  def change do
    alter table(:user_statuses) do
      add :note, :string
    end
  end
end
