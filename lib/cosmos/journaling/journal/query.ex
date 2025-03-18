defmodule Cosmos.Journaling.Journal.Query do
  @moduledoc """
  The query module for Journal
  """
  import Ecto.Query

  alias Cosmos.Journaling.Journal

  def by_date(base \\ Journal, date) do
    where(base, [j], j.date_at == ^date)
  end
end
