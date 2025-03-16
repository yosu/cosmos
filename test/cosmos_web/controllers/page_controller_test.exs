defmodule CosmosWeb.PageControllerTest do
  use CosmosWeb.ConnCase

  describe "Guest user" do
    test "GET /", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Cosmos"
    end
  end

  describe "Loggend in user" do
    setup :register_and_log_in_user

    test "Get /", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert redirected_to(conn) == ~p"/journals"
    end
  end
end
