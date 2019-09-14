defmodule AdminWeb.PageControllerTest do
  use AdminWeb.ConnCase
  alias AdminWeb.AuthCase

  setup_all _context do
    %{auth_conn: auth_conn, admin_user: admin_user} = AuthCase.setup()

    on_exit(fn -> AuthCase.delete_user_if_found(admin_user.id) end)

    [auth_conn: auth_conn, admin_user: admin_user]
  end

  test "GET /", %{auth_conn: auth_conn} do
    conn = get(auth_conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
