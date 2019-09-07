defmodule AdminWeb.LogInCase do
  use Database.DataFixtures, [:admin_user]

  alias Database.{AdminUsers, AdminUsers.AdminUser, Common.AdminGuardian, Repo}

  @spec setup(Plug.Conn.t()) :: %{admin_user: any, log_in_conn: Plug.Conn.t()}
  def setup(conn) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, :auto)

    admin_user = admin_user_fixture(@login_attrs)
    # log_in_conn = do_log_in(conn)
    log_in_conn = AdminGuardian.Plug.sign_in(conn, admin_user)
    %{log_in_conn: log_in_conn, admin_user: admin_user}
  end

  def exit(admin_user) do
    # this callback needs to checkout its own connection since it runs in its own process
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, :auto)

    # we also need to re-fetch the %Tenant struct since Ecto otherwise complains it's "stale"
    delete_user_if_found(admin_user.id)
    :ok
  end

  def delete_user_if_found(id) do
    with %AdminUser{} = admin_user <- AdminUsers.get_admin_user(id) do
      AdminUsers.delete_admin_user(admin_user)
    else
      _ -> :deleted
    end
  end

  # defp do_log_in(conn) do
  #   {:ok, admin_user} = PasswordHandler.authenticate_admin_user(@login_attrs.email, @login_attrs.password)
  #   AdminGuardian.Plug.sign_in(conn, admin_user)
  # end
end
