defmodule PecamWeb.ErrorJsonView do
  use PecamWeb, :view

  def render("error.json", %{message: message}) when is_bitstring(message) do
    %{errors: [message] }
  end
end
