defmodule ExpensyWeb.Router do
  alias ExpensyWeb
  # alias Expensy.Wallet.Category
  use ExpensyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExpensyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExpensyWeb do
    pipe_through :browser

    get "/old", PageController, :home
    live "/", Categories.IndexLive
    live "/categories/new", Categories.FormLive, :new
    live "/categories/:id", Categories.ShowLive
    live "/categories/:id/edit", Categories.FormLive, :edit
    live "/categories/:category_id/expenses/new", Expenses.FormLive, :new
    live "/expenses/:id/edit", Expenses.FormLive, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExpensyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:expensy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExpensyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:expensy, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
