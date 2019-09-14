defmodule AdminWeb.AuthControllerTest do
  use AdminWeb.ConnCase
  use Database.DataFixtures, [:admin_user]
  alias AdminWeb.AuthCase
  alias Database.Repo

  setup_all _context do
    %{auth_conn: auth_conn, admin_user: admin_user} = AuthCase.setup()

    on_exit(fn -> AuthCase.delete_user_if_found(admin_user.id) end)

    [auth_conn: auth_conn, admin_user: admin_user]
  end

  describe "login" do
    setup [:create_admin_user]

    test "get login page", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :login_page))
      assert html_response(conn, 200) =~ "Login page"
    end

    test "post login with valid data", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), admin_user: @valid_attrs)

      Repo.all(Database.AdminUsers.AdminUser)
      |> IO.inspect()

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "post login with invalid data", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), admin_user: @invalid_attrs)
      assert get_flash(conn, :info) == "Error: invalid_credentials"
    end

    test "try to get login page when connected", %{auth_conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :login_page))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "logout" do
    setup [:create_admin_user]

    test "try to logout when not connected", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :logout))
      assert text_response(conn, 401) =~ "unauthenticated"
    end

    test "logout when connected", %{auth_conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :logout))
      assert redirected_to(conn) == Routes.auth_path(conn, :login_page)
    end
  end

  defp create_admin_user(_) do
    admin_user = admin_user_fixture()

    on_exit(fn -> AuthCase.delete_user_if_found(admin_user.id) end)

    :ok
  end
end
