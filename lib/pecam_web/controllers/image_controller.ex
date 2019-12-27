defmodule PecamWeb.ImageController do
  use PecamWeb, :controller

  alias Pecam.Cam
  alias Pecam.Cam.Image

  action_fallback PecamWeb.FallbackController

  def index(conn, _params) do
    images = Cam.list_images()
    render(conn, "index.json", images: images)
  end

  def create(conn, %{"image" => image_params}) do
    with {:ok, %Image{} = image} <- Cam.create_image(image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> render("show.json", image: image)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Cam.get_image!(id)
    render(conn, "show.json", image: image)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Cam.get_image!(id)

    with {:ok, %Image{} = image} <- Cam.update_image(image, image_params) do
      render(conn, "show.json", image: image)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Cam.get_image!(id)

    with {:ok, %Image{}} <- Cam.delete_image(image) do
      send_resp(conn, :no_content, "")
    end
  end
end
