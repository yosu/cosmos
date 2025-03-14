defmodule Cosmos.Repo.Migrations.CreateJournals do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :date_at, :date, null: false
      add :morning_rate, :integer
      add :afternoon_rate, :integer
      add :evening_rate, :integer
      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:journals, :date_at)
  end
end
