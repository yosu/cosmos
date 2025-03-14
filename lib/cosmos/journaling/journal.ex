defmodule Cosmos.Journaling.Journal do
  use Cosmos.Schema
  import Ecto.Changeset

  schema "journals" do
    field :date_at, :date
    field :morning_rate, :integer
    field :afternoon_rate, :integer
    field :evening_rate, :integer

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:date_at, :morning_rate, :afternoon_rate, :evening_rate])
    |> validate_required([:date_at])
    |> validate_inclusion(:morning_rate, 0..10)
    |> validate_inclusion(:afternoon_rate, 0..10)
    |> validate_inclusion(:evening_rate, 0..10)
  end
end
