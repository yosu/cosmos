defmodule CosmosWeb.JournalLive.Index do
  use CosmosWeb, :live_view
  import CosmosWeb.JournalLive.Component

  alias Cosmos.Journaling

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :journals, Journaling.list_journals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "記録の変更")
    |> assign(:journal, Journaling.get_journal!(id))
  end

  defp apply_action(socket, :new, _params) do
    journal = Journaling.today_journal()

    case journal.id do
      nil ->
        socket
        |> assign(:page_title, "新規記録")
        |> assign(:journal, Journaling.today_journal())

      _ ->
        socket
        |> push_patch(to: ~p"/journals/#{journal}/edit")
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "記録リスト")
    |> assign(:journal, nil)
  end

  @impl true
  def handle_info({CosmosWeb.JournalLive.FormComponent, {:created, _journal}}, socket) do
    # Use stream/4 with reset option to keep the list order
    {:noreply, stream(socket, :journals, Journaling.list_journals(), reset: true)}
  end

  @impl true
  def handle_info({CosmosWeb.JournalLive.FormComponent, {:updated, journal}}, socket) do
    {:noreply, stream_insert(socket, :journals, journal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    journal = Journaling.get_journal!(id)
    {:ok, _} = Journaling.delete_journal(journal)

    {:noreply, stream_delete(socket, :journals, journal)}
  end
end
