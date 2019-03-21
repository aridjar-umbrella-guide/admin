defmodule AdminWeb.AdminUserController do
  use AdminWeb, :controller

  alias Database.AdminUsers
  alias Database.AdminUsers.AdminUser

  def index(conn, _params) do
    admin_users = AdminUsers.list_admin_users()
    render(conn, "index.html", admin_users: admin_users)
  end

  def new(conn, _params) do
    changeset = AdminUsers.change_admin_user(%AdminUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin_user" => admin_user_params}) do
    case AdminUsers.create_admin_user(admin_user_params) do
      {:ok, admin_user} ->
        conn
        |> put_flash(:info, "Admin user created successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :show, admin_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    admin_user = AdminUsers.get_admin_user!(id)
    render(conn, "show.html", admin_user: admin_user)
  end

  def edit(conn, %{"id" => id}) do
    admin_user = AdminUsers.get_admin_user!(id)
    changeset = AdminUsers.change_admin_user(admin_user)
    render(conn, "edit.html", admin_user: admin_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "admin_user" => admin_user_params}) do
    admin_user = AdminUsers.get_admin_user!(id)

    case AdminUsers.update_admin_user(admin_user, admin_user_params) do
      {:ok, admin_user} ->
        conn
        |> put_flash(:info, "Admin user updated successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :show, admin_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", admin_user: admin_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin_user = AdminUsers.get_admin_user!(id)
    {:ok, _admin_user} = AdminUsers.delete_admin_user(admin_user)

    conn
    |> put_flash(:info, "Admin user deleted successfully.")
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
