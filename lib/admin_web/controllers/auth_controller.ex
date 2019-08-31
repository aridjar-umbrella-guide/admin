# apps/admin/lib/admin_web/controllers/auth_controller.ex
defmodule AdminWeb.AuthController do
  use AdminWeb, :controller

  alias Database.{AdminUsers, AdminUsers.AdminUser, Common.PasswordHandler, Common.AdminGuardian}

  def login_page(conn, _) do
    # We try to get the logged user
    changeset = AdminUsers.change_admin_user(%AdminUser{})
    logged_user = AdminGuardian.Plug.current_resource(conn)

    # if there is a logged user, we redirect him to the front page. Otherwise he can access the login form.
    if logged_user do
      redirect(conn, to: "/")
    else
      render(conn, "login.html", changeset: changeset, action: AdminWeb.Router.Helpers.page_path(conn, :index))
    end
  end

  def login(conn, %{"admin_user" => %{"email" => email, "password" => password}}) do
    # Ask the PasswordHandler if there is a matching email and password in the database
    with {:ok, user} <- PasswordHandler.authenticate_admin_user(email, password) do
      login_reply({:ok, user}, conn)
    else
      {:error, reason} -> login_reply({:error, reason}, conn)
    end
  end

  defp login_reply({:ok, user}, conn),
    do: redirect(AdminGuardian.Plug.sign_in(conn, user), to: "/")
  defp login_reply({:error, reason}, conn),
    do: put_flash(conn, :info, "Error: #{reason}")

  def logout(conn, _) do
    conn
    |> AdminGuardian.Plug.sign_out()
    |> redirect(to: "/login")
  end
end
