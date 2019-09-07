defmodule AdminWeb.PageControllerTest do
  use AdminWeb.ConnCase
  alias AdminWeb.LogInCase

  setup_all _context do
    %{log_in_conn: log_in_conn, admin_user: admin_user} = build_conn()
    |> LogInCase.setup()

    on_exit fn -> LogInCase.exit(admin_user) end

    [log_in_conn: log_in_conn, admin_user: admin_user]
  end

  test "GET /", %{log_in_conn: log_in_conn} do
    conn = get(log_in_conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
