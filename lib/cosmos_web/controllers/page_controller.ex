defmodule CosmosWeb.PageController do
  use CosmosWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/journals")
    else
      # The home page is often custom made,
      # so skip the default app layout.
      render(conn, :home, layout: false)
    end
  end
end
