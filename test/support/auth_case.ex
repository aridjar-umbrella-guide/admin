defmodule AdminWeb.AuthCase do
  use ExUnit.CaseTemplate
  use Database.DataFixtures, [:admin_user]

  alias Database.{AdminUsers, AdminUsers.AdminUser, Common.AdminGuardian, Repo}

  using do
    quote do
      use Database.DataFixtures, [:admin_user]
      use Phoenix.ConnTest
      alias AdminWeb.Router.Helpers, as: Routes

      @endpoint AdminWeb.Endpoint

      defp create_admin_user(_) do
        admin_user = admin_user_fixture()

        on_exit(fn -> unquote(__MODULE__).delete_user_if_found(admin_user.id) end)

        {:ok, admin_user: admin_user}
      end
    end
  end

  setup _tags do
    :ok
  end

  setup_all _tags do
    conn = Phoenix.ConnTest.build_conn()
    super_admin_user = admin_user_fixture(@super_admin_attrs)
    auth_conn = AdminGuardian.Plug.sign_in(conn, super_admin_user)

    {:ok, conn: conn, auth_conn: auth_conn, super_admin_user: super_admin_user}
  end

  def delete_user_if_found(id) do
    with %AdminUser{} = admin_user <- AdminUsers.get_admin_user(id) do
      Repo.delete(admin_user)
      :deleted
    else
      _ -> :already_deleted
    end
  end
end
