defmodule PecamWeb.ImageView do
  use PecamWeb, :view
  alias PecamWeb.ImageView

  def render("index.json", %{images: images}) do
    %{data: render_many(images, ImageView, "image.json")}
  end

  def render("show.json", %{image: image}) do
    %{data: render_one(image, ImageView, "image.json")}
  end

  def render("image.json", %{image: image}) do
    %{number: image.number,
      time: image.time,
      data: image.data}
  end
end
