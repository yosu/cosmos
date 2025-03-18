defmodule Cosmos.Journaling do
  @moduledoc """
  The Journaling context.
  """

  import Ecto.Query, warn: false
  alias Cosmos.Repo

  alias Cosmos.Journaling.Journal

  @doc """
  Returns the list of journals order by date_at.

  ## Examples

      iex> list_journals()
      [%Journal{}, ...]

  """
  def list_journals do
    Repo.all(Journal |> order_by(:date_at))
  end

  def get_chart_data_for(:all) do
    journals = Repo.all(Journal |> order_by(:date_at))

    dates = Enum.map(journals, & &1.date_at) |> Cosmos.Date.pad_dates()

    labels =
      Enum.reduce(dates, [], fn d, acc ->
        date = Calendar.strftime(d, "%-m/%d")
        ["#{date} 夜", "#{date} 昼", "#{date} 朝" | acc]
      end)

    journal_map =
      for j <- journals, into: %{} do
        {j.date_at, j}
      end

    data =
      Enum.reduce(dates, [], fn d, acc ->
        if j = journal_map[d] do
          [j.evening_rate, j.afternoon_rate, j.morning_rate | acc]
        else
          [nil, nil, nil | acc]
        end
      end)

    line_chart(Enum.reverse(labels), Enum.reverse(data))
  end

  def get_chart_data_for(rate_name) do
    journals = Repo.all(Journal |> order_by(:date_at))

    dates = Enum.map(journals, & &1.date_at) |> Cosmos.Date.pad_dates()

    labels =
      Enum.reduce(dates, [], fn d, acc ->
        date = Calendar.strftime(d, "%-m/%d")
        [date | acc]
      end)

    journal_map =
      for j <- journals, into: %{} do
        {j.date_at, j}
      end

    data =
      Enum.reduce(dates, [], fn d, acc ->
        if j = journal_map[d] do
          [Map.get(j, rate_name) | acc]
        else
          [nil | acc]
        end
      end)

    line_chart(Enum.reverse(labels), Enum.reverse(data))
  end

  # Returns Chart.js configuration with given data and labels
  defp line_chart(labels, data) do
    %{
      type: "line",
      data: %{
        labels: labels,
        datasets: [
          %{
            data: data,
            borderWidth: 1
          }
        ]
      },
      options: %{
        plugins: %{
          legend: %{
            display: false
          }
        },
        scales: %{
          y: %{
            suggestedMin: 0,
            suggestedMax: 10
          }
        }
      }
    }
  end

  @doc """
  Gets a single journal.

  Raises `Ecto.NoResultsError` if the Journal does not exist.

  ## Examples

      iex> get_journal!(123)
      %Journal{}

      iex> get_journal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_journal!(id), do: Repo.get!(Journal, id)

  @doc """
  Returns today's journal changeset
  """
  def today_journal() do
    today = DateTime.now!("Asia/Tokyo") |> DateTime.to_date()

    %Journal{date_at: today}
  end

  @doc """
  Returns select options of ratings.
  """
  def rating_options() do
    [nil | Range.to_list(0..10)]
  end

  @doc """
  Creates a journal.

  ## Examples

      iex> create_journal(%{field: value})
      {:ok, %Journal{}}

      iex> create_journal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_journal(attrs \\ %{}) do
    %Journal{}
    |> Journal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a journal.

  ## Examples

      iex> update_journal(journal, %{field: new_value})
      {:ok, %Journal{}}

      iex> update_journal(journal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_journal(%Journal{} = journal, attrs) do
    journal
    |> Journal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a journal.

  ## Examples

      iex> delete_journal(journal)
      {:ok, %Journal{}}

      iex> delete_journal(journal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_journal(%Journal{} = journal) do
    Repo.delete(journal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journal changes.

  ## Examples

      iex> change_journal(journal)
      %Ecto.Changeset{data: %Journal{}}

  """
  def change_journal(%Journal{} = journal, attrs \\ %{}) do
    Journal.changeset(journal, attrs)
  end
end
