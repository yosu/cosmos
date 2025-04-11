defmodule Cosmos.Repo.Migrations.AddNotNullConstraintToJournalsUserId do
  use Ecto.Migration

  def change do
    alter table(:journals) do
      modify :user_id, references(:users, on_delete: :delete_all),
        null: false,
        from: references(:users, on_delete: :delete_all)
    end
  end
end
