defmodule AdminWeb.AdminUserControllerTest do
  use AdminWeb.ConnCase
  use Database.DataFixtures, [:admin_user]
  alias AdminWeb.AuthCase

  setup_all do
    %{auth_conn: auth_conn, admin_user: admin_user} = AuthCase.setup()

    on_exit(fn -> AuthCase.delete_user_if_found(admin_user.id) end)

    [auth_conn: auth_conn, admin_user: admin_user]
  end

  describe "index" do
    test "lists all admin_users", %{auth_conn: auth_conn} do
      conn = get(auth_conn, Routes.admin_user_path(auth_conn, :index))
      assert html_response(conn, 200) =~ "Listing Admin users"
    end
  end

  describe "new admin_user" do
    test "renders form", %{auth_conn: auth_conn} do
      conn = get(auth_conn, Routes.admin_user_path(auth_conn, :new))
      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "create admin_user" do
    test "redirects to show when data is valid", %{auth_conn: auth_conn} do
      conn = post(auth_conn, Routes.admin_user_path(auth_conn, :create), admin_user: @valid_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, id)

      conn = get(auth_conn, Routes.admin_user_path(auth_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Admin user"
      AuthCase.delete_user_if_found(id)
    end

    test "renders errors when data is invalid", %{auth_conn: auth_conn} do
      conn =
        post(auth_conn, Routes.admin_user_path(auth_conn, :create), admin_user: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Admin user"
    end
  end

  describe "edit admin_user" do
    setup [:create_admin_user]

    test "renders form for editing chosen admin_user", %{
      auth_conn: auth_conn,
      admin_user: admin_user
    } do
      conn = get(auth_conn, Routes.admin_user_path(auth_conn, :edit, admin_user))
      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "update admin_user" do
    setup [:create_admin_user]

    test "redirects when data is valid", %{auth_conn: auth_conn, admin_user: admin_user} do
      conn =
        put(auth_conn, Routes.admin_user_path(auth_conn, :update, admin_user),
          admin_user: @update_attrs
        )

      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, admin_user)

      conn = get(auth_conn, Routes.admin_user_path(auth_conn, :show, admin_user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{auth_conn: auth_conn, admin_user: admin_user} do
      conn =
        put(auth_conn, Routes.admin_user_path(auth_conn, :update, admin_user),
          admin_user: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Admin user"
    end
  end

  describe "delete admin_user" do
    setup [:create_admin_user]

    test "deletes chosen admin_user", %{auth_conn: auth_conn, admin_user: admin_user} do
      conn = delete(auth_conn, Routes.admin_user_path(auth_conn, :delete, admin_user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(auth_conn, Routes.admin_user_path(auth_conn, :show, admin_user))
      end
    end
  end

  defp create_admin_user(_) do
    admin_user = admin_user_fixture()

    on_exit(fn -> AuthCase.delete_user_if_found(admin_user.id) end)

    {:ok, admin_user: admin_user}
  end
end
