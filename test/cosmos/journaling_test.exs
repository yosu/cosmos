defmodule Cosmos.JournalingTest do
  use Cosmos.DataCase

  alias Cosmos.Journaling

  describe "journals" do
    alias Cosmos.Journaling.Journal

    import Cosmos.JournalingFixtures

    @invalid_attrs %{date_at: nil, morning_rate: nil, afternoon_rate: nil, evening_rate: nil}
    @invalid_morning_rate %{date_at: ~D[2025-03-13], morning_rate: -1}

    test "list_journals/0 returns all journals" do
      journal = journal_fixture()
      assert Journaling.list_journals() == [journal]
    end

    test "get_journal!/1 returns the journal with given id" do
      journal = journal_fixture()
      assert Journaling.get_journal!(journal.id) == journal
    end

    test "create_journal/1 with valid data creates a journal" do
      valid_attrs = %{date_at: ~D[2025-03-13], morning_rate: 10, afternoon_rate: 10, evening_rate: 10}

      assert {:ok, %Journal{} = journal} = Journaling.create_journal(valid_attrs)
      assert journal.date_at == ~D[2025-03-13]
      assert journal.morning_rate == 10
      assert journal.afternoon_rate == 10
      assert journal.evening_rate == 10
    end

    test "create_journal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journaling.create_journal(@invalid_attrs)
    end

    test "create_journal/1 with duplicate date returns error changeset" do
      attrs = %{date_at: ~D[2025-03-13], morning_rate: 10, afternoon_rate: 10, evening_rate: 10}

      assert {:ok, %Journal{}} = Journaling.create_journal(attrs)
      assert {:error, %Ecto.Changeset{}} = Journaling.create_journal(attrs)
    end

    test "create_journal/1 with invalid morning_rate returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journaling.create_journal(@invalid_morning_rate)
    end

    test "update_journal/2 with valid data updates the journal" do
      journal = journal_fixture()
      update_attrs = %{date_at: ~D[2025-03-14], morning_rate: 0, afternoon_rate: 0, evening_rate: 0}

      assert {:ok, %Journal{} = journal} = Journaling.update_journal(journal, update_attrs)
      assert journal.date_at == ~D[2025-03-14]
      assert journal.morning_rate == 0
      assert journal.afternoon_rate == 0
      assert journal.evening_rate == 0
    end

    test "update_journal/2 with nil data updates the journal" do
      journal = journal_fixture()
      update_attrs = %{date_at: ~D[2025-03-14], morning_rate: nil, afternoon_rate: nil, evening_rate: nil}

      assert {:ok, %Journal{} = journal} = Journaling.update_journal(journal, update_attrs)
      assert journal.date_at == ~D[2025-03-14]
      assert journal.morning_rate == nil
      assert journal.afternoon_rate == nil
      assert journal.evening_rate == nil
    end

    test "update_journal/2 with invalid data returns error changeset" do
      journal = journal_fixture()
      assert {:error, %Ecto.Changeset{}} = Journaling.update_journal(journal, @invalid_attrs)
      assert journal == Journaling.get_journal!(journal.id)
    end

    test "delete_journal/1 deletes the journal" do
      journal = journal_fixture()
      assert {:ok, %Journal{}} = Journaling.delete_journal(journal)
      assert_raise Ecto.NoResultsError, fn -> Journaling.get_journal!(journal.id) end
    end

    test "change_journal/1 returns a journal changeset" do
      journal = journal_fixture()
      assert %Ecto.Changeset{} = Journaling.change_journal(journal)
    end
  end
end
