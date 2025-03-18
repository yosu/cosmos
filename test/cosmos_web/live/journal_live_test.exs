defmodule CosmosWeb.JournalLiveTest do
  use CosmosWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cosmos.JournalingFixtures

  @create_attrs %{date_at: "2025-03-14", morning_rate: 10, afternoon_rate: 10, evening_rate: 10}
  @update_attrs %{date_at: "2025-03-15", morning_rate: 0, afternoon_rate: 0, evening_rate: 0}
  @invalid_attrs %{date_at: nil, morning_rate: nil, afternoon_rate: nil, evening_rate: nil}

  defp create_journal(_) do
    journal = journal_fixture()
    %{journal: journal}
  end

  describe "Index" do
    setup [:create_journal, :register_and_log_in_user]

    test "lists all journals", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/journals")

      assert html =~ "記録リスト"
    end

    test "saves new journal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/journals")

      assert index_live |> element("a", "つける") |> render_click() =~
               "つける"

      assert_patch(index_live, ~p"/journals/new")

      assert index_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "入力してください"

      assert index_live
             |> form("#journal-form", journal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journals")

      html = render(index_live)
      assert html =~ "成功"
    end

    test "updates journal in listing", %{conn: conn, journal: journal} do
      {:ok, index_live, _html} = live(conn, ~p"/journals")

      assert index_live |> element("#journals-#{journal.id} a", "変更") |> render_click() =~
               "記録の変更"

      assert_patch(index_live, ~p"/journals/#{journal}/edit")

      assert index_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "入力してください"

      assert index_live
             |> form("#journal-form", journal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/journals")

      html = render(index_live)
      assert html =~ "成功"
    end

    test "deletes journal in listing", %{conn: conn, journal: journal} do
      {:ok, index_live, _html} = live(conn, ~p"/journals")

      assert index_live |> element("#journals-#{journal.id} a", "削除") |> render_click()
      refute has_element?(index_live, "#journals-#{journal.id}")
    end
  end

  describe "Show" do
    setup [:create_journal, :register_and_log_in_user]

    test "displays journal", %{conn: conn, journal: journal} do
      {:ok, _show_live, html} = live(conn, ~p"/journals/#{journal}")

      assert html =~ "見る"
    end

    test "updates journal within modal", %{conn: conn, journal: journal} do
      {:ok, show_live, _html} = live(conn, ~p"/journals/#{journal}")

      assert show_live |> element("a", "変更") |> render_click() =~
               "変更"

      assert_patch(show_live, ~p"/journals/#{journal}/show/edit")

      assert show_live
             |> form("#journal-form", journal: @invalid_attrs)
             |> render_change() =~ "入力してください"

      assert show_live
             |> form("#journal-form", journal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/journals/#{journal}")

      html = render(show_live)
      assert html =~ "成功"
    end
  end
end
