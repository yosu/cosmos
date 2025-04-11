defmodule Cosmos.JournalingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cosmos.Journaling` context.
  """
  import Cosmos.AccountFixtures

  @doc """
  Generate a journal.
  """
  def journal_fixture(attrs \\ %{}) do
    {:ok, journal} =
      attrs
      |> Enum.into(%{
        afternoon_rate: 10,
        date_at: ~D[2025-03-13],
        evening_rate: 10,
        morning_rate: 10,
        user_id: user_fixture().id
      })
      |> Cosmos.Journaling.create_journal()

    journal
  end
end
