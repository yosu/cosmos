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
