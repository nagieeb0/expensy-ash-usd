defmodule ExpensyWeb.PageControllerTest do
  use ExpensyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/old")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
