defmodule PecamWeb.ImageController do
  use PecamWeb, :controller

  alias Pecam.Cam
  alias Pecam.Cam.Image

  action_fallback PecamWeb.ApiFallbackController

  def index(conn, _params) do
    images = Cam.list_images()
    render(conn, "index.json", images: images)
  end

  def create(conn, params) do
    {:ok, now} = DateTime.now("Etc/UTC")
    image_params = params
      |> Map.new(fn {k,v} -> {String.to_atom(k),v} end)
      |> Map.put(:time, now)

    with {:ok, %Image{} = image} <- Cam.create_image(image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> render("image.json", image: image)
    end
  end

  def show(conn, %{"id" => id}) do
    case Cam.get_image(id) do
      {:ok, image} -> render(conn, "image.json", image: image)
      {:error, :invalid_id} ->
        {:error, "invalid id"}
      {:error, error} ->
        {:error, error}
      error ->
        {:error, error}
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, image} <- Cam.get_image(id) do
      {:ok, now} = DateTime.now("Etc/UTC")
      image_params = params
        |> Map.new(fn {k,v} -> {String.to_atom(k),v} end)
        |> Map.put(:time, now)

      with {:ok, %Image{} = image} <- Cam.update_image(image, image_params) do
        render(conn, "image.json", image: image)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, image} <- Cam.get_image(id),
         :ok <- Cam.delete_image(image) do
      send_resp(conn, :no_content, "")
    end
  end
end
