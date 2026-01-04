defmodule WebElixirWeb.Router do
  use WebElixirWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {WebElixirWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", WebElixirWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
    resources("/products", ProductController)
  end

  scope "/api", WebElixirWeb do
    pipe_through(:api)

    resources("/products", ProductAPIController, except: [:new, :edit])
  end
end
