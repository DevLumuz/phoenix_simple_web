defmodule WebElixirWeb.PageController do
  use WebElixirWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
