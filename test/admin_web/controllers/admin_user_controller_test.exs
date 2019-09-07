defmodule AdminWeb.AdminUserControllerTest do
  use AdminWeb.ConnCase
  use Database.DataFixtures, [:admin_user]
  alias AdminWeb.LogInCase

  setup_all _context do
    %{log_in_conn: log_in_conn, admin_user: admin_user} = build_conn()
    |> LogInCase.setup()

    on_exit fn -> LogInCase.exit(admin_user) end

    [log_in_conn: log_in_conn, admin_user: admin_user]
  end

  describe "index" do
    test "lists all admin_users", %{log_in_conn: log_in_conn} do
      conn = get(log_in_conn, Routes.admin_user_path(log_in_conn, :index))
      assert html_response(conn, 200) =~ "Listing Admin users"
    end
  end

  describe "new admin_user" do
    test "renders form", %{log_in_conn: log_in_conn} do
      conn = get(log_in_conn, Routes.admin_user_path(log_in_conn, :new))
      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "create admin_user" do
    test "redirects to show when data is valid", %{log_in_conn: log_in_conn} do
      conn = post(log_in_conn, Routes.admin_user_path(log_in_conn, :create), admin_user: @valid_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, id)

      conn = get(log_in_conn, Routes.admin_user_path(log_in_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Admin user"
    end

    test "renders errors when data is invalid", %{log_in_conn: log_in_conn} do
      conn = post(log_in_conn, Routes.admin_user_path(log_in_conn, :create), admin_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "edit admin_user" do
    setup [:create_admin_user]

    test "renders form for editing chosen admin_user", %{log_in_conn: log_in_conn, admin_user: admin_user} do
      conn = get(log_in_conn, Routes.admin_user_path(log_in_conn, :edit, admin_user))
      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "update admin_user" do
    setup [:create_admin_user]

    test "redirects when data is valid", %{log_in_conn: log_in_conn, admin_user: admin_user} do
      conn =
        put(log_in_conn, Routes.admin_user_path(log_in_conn, :update, admin_user), admin_user: @update_attrs)

      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, admin_user)

      conn = get(log_in_conn, Routes.admin_user_path(log_in_conn, :show, admin_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{log_in_conn: log_in_conn, admin_user: admin_user} do
      conn =
        put(log_in_conn, Routes.admin_user_path(log_in_conn, :update, admin_user), admin_user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "delete admin_user" do
    setup [:create_admin_user]

    test "deletes chosen admin_user", %{log_in_conn: log_in_conn, admin_user: admin_user} do
      conn = delete(log_in_conn, Routes.admin_user_path(log_in_conn, :delete, admin_user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(log_in_conn, Routes.admin_user_path(log_in_conn, :show, admin_user))
      end
    end
  end

  defp create_admin_user(_) do
    admin_user = admin_user_fixture()

    on_exit fn ->
      LogInCase.delete_user_if_found(admin_user.id)
    end

    {:ok, admin_user: admin_user}
  end
end
