defmodule AdminWeb.AuthCase do
  use Database.DataFixtures, [:admin_user]

  alias Phoenix.ConnTest
  alias Database.{AdminUsers, AdminUsers.AdminUser, Common.AdminGuardian, Repo}

  def setup(is_for_case \\ true) do
    if is_for_case do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Repo, :auto)
    end
    conn = ConnTest.build_conn()

    admin_user = admin_user_fixture(@super_admin_attrs)
    auth_conn = AdminGuardian.Plug.sign_in(conn, admin_user)
    %{auth_conn: auth_conn, admin_user: admin_user}
  end

  def delete_user_if_found(id) do
    with %AdminUser{} = admin_user <- AdminUsers.get_admin_user(id) do
      Repo.delete(admin_user)
    else
      _ -> :deleted
    end

    :ok
  end
end
