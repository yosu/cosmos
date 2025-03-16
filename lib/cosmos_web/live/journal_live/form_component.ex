defmodule CosmosWeb.JournalLive.FormComponent do
  use CosmosWeb, :live_component

  alias Cosmos.Journaling

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="journal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date_at]} type="date" label="日付" />
        <.input
          field={@form[:morning_rate]}
          type="select"
          label="朝☀️"
          options={Journaling.rating_options()}
        />
        <.input
          field={@form[:afternoon_rate]}
          type="select"
          label="昼🕛"
          options={Journaling.rating_options()}
        />
        <.input
          field={@form[:evening_rate]}
          type="select"
          label="夜🌃"
          options={Journaling.rating_options()}
        />
        <:actions>
          <.button phx-disable-with="保存中...">保存</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{journal: journal} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Journaling.change_journal(journal))
     end)}
  end

  @impl true
  def handle_event("validate", %{"journal" => journal_params}, socket) do
    changeset = Journaling.change_journal(socket.assigns.journal, journal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"journal" => journal_params}, socket) do
    save_journal(socket, socket.assigns.action, journal_params)
  end

  defp save_journal(socket, :edit, journal_params) do
    case Journaling.update_journal(socket.assigns.journal, journal_params) do
      {:ok, journal} ->
        notify_parent({:updated, journal})

        {:noreply,
         socket
         |> put_flash(:info, "Journal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_journal(socket, :new, journal_params) do
    case Journaling.create_journal(journal_params) do
      {:ok, journal} ->
        notify_parent({:created, journal})

        {:noreply,
         socket
         |> put_flash(:info, "Journal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
