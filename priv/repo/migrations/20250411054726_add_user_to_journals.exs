defmodule Cosmos.Repo.Migrations.AddUserToJournals do
  use Ecto.Migration

  def change do
    alter table(:journals) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:journals, :user_id)
    create unique_index(:journals, [:user_id, :date_at])
    drop unique_index(:journals, :date_at)
  end
end
