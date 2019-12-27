defmodule PecamWeb.PageController do
  use PecamWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
