defmodule PecamWeb.ApiFallbackController do
  @moduledoc """
  Fallback Controller for api Endpoints
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PecamWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(PecamWeb.ErrorJsonView)
    |> render("error.json", message: "not_found")
  end

  def call(conn, {:error, message}) when is_bitstring(message) do
    conn
    |> put_status(:bad_request)
    |> put_view(PecamWeb.ErrorJsonView)
    |> render("error.json", message: message)
  end

  def call(conn, {:error, :invalid_params, message}) when is_bitstring(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(PecamWeb.ErrorJsonView)
    |> render("error.json", message: message)
  end

  def call(conn, _any) do
    conn
    |> put_status(:bad_request)
    |> put_view(PecamWeb.ErrorJsonView)
    |> render("error.json", message: "Internal server fault")
  end
end
