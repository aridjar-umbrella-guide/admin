defmodule AdminWeb.Router do
  use AdminWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Database.Common.Pipelines.AdminAuth
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", AdminWeb do
    pipe_through [:browser, :auth]

    get "/login", AuthController, :login_page
    post "/login", AuthController, :login
  end

  scope "/", AdminWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/", PageController, :index
    post "/logout", AuthController, :logout
  end

  scope "/admin_user/", AdminWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/", AdminUserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", AdminWeb do
  #   pipe_through :api
  # end
end
