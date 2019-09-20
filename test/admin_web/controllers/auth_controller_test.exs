defmodule AdminWeb.AuthControllerTest do
  use AdminWeb.AuthCase

  describe "login" do
    setup [:create_admin_user]

    test "get login page", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :login_page))
      assert html_response(conn, 200) =~ "Login page"
    end

    test "post login with valid data", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), admin_user: @valid_attrs)
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
    test "try to logout when not connected", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :logout))
      assert text_response(conn, 401) =~ "unauthenticated"
    end

    test "logout when connected", %{auth_conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :logout))
      assert redirected_to(conn) == Routes.auth_path(conn, :login_page)
    end
  end
end
