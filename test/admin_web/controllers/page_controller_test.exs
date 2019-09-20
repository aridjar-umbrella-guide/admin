defmodule AdminWeb.PageControllerTest do
  use AdminWeb.AuthCase

  test "GET /", %{auth_conn: auth_conn} do
    conn = get(auth_conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
