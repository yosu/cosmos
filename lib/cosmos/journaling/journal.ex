defmodule Cosmos.Journaling.Journal do
  @moduledoc """
  Schema of the daily journal log.
  """
  use Cosmos.Schema, prefix: "jnl_"
  import Ecto.Changeset

  schema "journals" do
    field :date_at, :date
    field :morning_rate, :integer
    field :afternoon_rate, :integer
    field :evening_rate, :integer
    belongs_to :user, Cosmos.Account.User

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(journal, attrs) do
    journal
    |> cast(attrs, [:date_at, :morning_rate, :afternoon_rate, :evening_rate, :user_id])
    |> validate_required([:date_at, :user_id])
    |> unique_constraint([:user_id, :date_at])
    |> validate_rates()
  end

  def update_changeset(journal, attrs) do
    journal
    |> cast(attrs, [:morning_rate, :afternoon_rate, :evening_rate])
    |> validate_rates()
  end

  defp validate_rates(changeset) do
    changeset
    |> validate_inclusion(:morning_rate, 0..10)
    |> validate_inclusion(:afternoon_rate, 0..10)
    |> validate_inclusion(:evening_rate, 0..10)
  end
end
