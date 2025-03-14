defmodule CosmosWeb.JournalLive.Index do
  use CosmosWeb, :live_view

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
    |> assign(:page_title, "Edit Journal")
    |> assign(:journal, Journaling.get_journal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Journal")
    |> assign(:journal, Journaling.today_journal())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Journals")
    |> assign(:journal, nil)
  end

  @impl true
  def handle_info({CosmosWeb.JournalLive.FormComponent, {:saved, journal}}, socket) do
    {:noreply, stream_insert(socket, :journals, journal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    journal = Journaling.get_journal!(id)
    {:ok, _} = Journaling.delete_journal(journal)

    {:noreply, stream_delete(socket, :journals, journal)}
  end
end
