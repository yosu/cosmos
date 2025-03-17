defmodule CosmosWeb.ChartController do
  use CosmosWeb, :controller

  alias Cosmos.Journaling

  def chart(conn, _param) do
    all_chart = Journaling.get_chart_data_for(:all)
    morning_chart = Journaling.get_chart_data_for(:morning_rate)
    afternoon_chart = Journaling.get_chart_data_for(:afternoon_rate)
    evening_chart = Journaling.get_chart_data_for(:evening_rate)

    conn
    |> assign(:all_chart, Jason.encode!(all_chart))
    |> assign(:morning_chart, Jason.encode!(morning_chart))
    |> assign(:afternoon_chart, Jason.encode!(afternoon_chart))
    |> assign(:evening_chart, Jason.encode!(evening_chart))
    |> render(:chart)
  end
end
