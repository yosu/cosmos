defmodule Cosmos.Repo.Migrations.AddUserToJournals do
  use Ecto.Migration

  def change do
    alter table(:journals) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:journals, :user_id)
  end
end
