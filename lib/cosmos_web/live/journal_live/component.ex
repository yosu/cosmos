defmodule CosmosWeb.JournalLive.Component do
  use CosmosWeb, :html

  @doc ~S"""
  Renders a list of journals.
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true

  def journal_list(assigns) do
    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="mt-2 w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th class="p-0 pb-4 pr-6 font-normal">日付</th>
            <th class="p-0 pb-4 pr-6 font-normal">☀️朝</th>
            <th class="p-0 pb-4 pr-6 font-normal">🕛昼</th>
            <th class="p-0 pb-4 pr-6 font-normal">🌃夜</th>
            <th class="relative p-0 pb-4 pr-6 "><span class="sr-only">{gettext("Actions")}</span></th>
            <th class="relative p-0 pb-4 pr-6"><span class="sr-only">{gettext("Actions")}</span></th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update="stream"
          class="relative divide-y divide-zinc-200 border-t border-zinc-400 text-sm leading-6 text-zinc-700"
        >
          <tr :for={{row_id, journal} <- @rows} id={row_id} class="group hover:bg-zinc-50">
            <td phx-click={JS.navigate(~p"/journals/#{journal}/edit")}>
              {Calendar.strftime(journal.date_at, "%-m/%d")}
            </td>
            <td phx-click={JS.navigate(~p"/journals/#{journal}")}>{journal.morning_rate}</td>
            <td phx-click={JS.navigate(~p"/journals/#{journal}")}>{journal.afternoon_rate}</td>
            <td phx-click={JS.navigate(~p"/journals/#{journal}")}>{journal.evening_rate}</td>
            <td>
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
                  <div class="sr-only">
                    <.link navigate={~p"/journals/#{journal}"}>見る</.link>
                  </div>
                  <.link patch={~p"/journals/#{journal}/edit"}>変更</.link>
                </span>
              </div>
            </td>
            <td>
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
                  <.link
                    phx-click={JS.push("delete", value: %{id: journal.id}) |> hide("##{row_id}")}
                    data-confirm="Are you sure?"
                  >
                    削除
                  </.link>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
