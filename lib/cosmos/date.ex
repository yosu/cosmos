defmodule Cosmos.Date do
  @moduledoc """
  Date utilities.
  """

  @doc """
  Padding dates into the given sparse dates
  """
  def pad_dates([]), do: []

  def pad_dates(dates) do
    last_date = Enum.max(dates, Date)
    first_date = Enum.min(dates, Date)

    Date.range(first_date, last_date)
    |> Enum.to_list()
  end
end
