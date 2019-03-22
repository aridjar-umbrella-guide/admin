defmodule AdminWeb.AdminUserControllerTest do
  use AdminWeb.ConnCase
  use Database.DataFixtures, [:admin_user]

  alias Database.AdminUsers

  describe "index" do
    test "lists all admin_users", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Admin users"
    end
  end

  describe "new admin_user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "create admin_user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), admin_user: @valid_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, id)

      conn = get(conn, Routes.admin_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Admin user"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), admin_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "edit admin_user" do
    setup [:create_admin_user]

    test "renders form for editing chosen admin_user", %{conn: conn, admin_user: admin_user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, admin_user))
      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "update admin_user" do
    setup [:create_admin_user]

    test "redirects when data is valid", %{conn: conn, admin_user: admin_user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, admin_user), admin_user: @update_attrs)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, admin_user)

      conn = get(conn, Routes.admin_user_path(conn, :show, admin_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, admin_user: admin_user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, admin_user), admin_user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "delete admin_user" do
    setup [:create_admin_user]

    test "deletes chosen admin_user", %{conn: conn, admin_user: admin_user} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, admin_user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_user_path(conn, :show, admin_user))
      end
    end
  end

  defp create_admin_user(_) do
    admin_user = admin_user_fixture()
    {:ok, admin_user: admin_user}
  end
end
