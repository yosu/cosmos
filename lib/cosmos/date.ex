defmodule Cosmos.Date do
  @moduledoc """
  Date utilities.
  """

  @doc """
  Padding dates into the given sparse dates
  """
  def pad_dates([]), do: []

  def pad_dates(dates) do
    last_date = Enum.max(dates)
    first_date = Enum.min(dates)

    Stream.unfold({first_date, last_date}, fn
      {a, b} ->
        if Date.after?(a, b) do
          nil
        else
          {a, {Date.add(a, 1), b}}
        end
    end)
    |> Enum.to_list()
  end
end
