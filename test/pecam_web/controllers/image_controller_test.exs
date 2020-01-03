defmodule PecamWeb.ImageControllerTest do
  use PecamWeb.ConnCase

  import Pecam.TestHelpers.Assertions

  alias Pecam.Cam
  alias Pecam.Cam.Image

  @create_attrs %{
    data: "some data"
  }
  @update_attrs %{
    data: "some updated data"
  }
  @invalid_attrs %{data: nil}

  def fixture(:image) do
    {:ok, now} = DateTime.now("Etc/UTC")
    {:ok, image} = Cam.create_image(%{data: @create_attrs.data, time: now})
    image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists empty when no images", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all images", %{conn: conn} do
      fixture(:image)
      fixture(:image)
      conn = get(conn, Routes.image_path(conn, :index))
      assert Kernel.length(json_response(conn, 200)["data"]) == 2
    end
  end

  describe "show image" do
    setup [:create_image]

    test "returns bad_request when id is not a parsable int", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :show, "not_an_integer"))
      assert json_response(conn, 400)["errors"] == ["invalid id"]
    end
  end

  describe "create image" do
    test "renders image when data is valid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.image_path(conn, :show, id))

      assert %{
               "id" => id,
               "data" => "some data",
               "time" => time
             } = json_response(conn, 200)
      assert_approx_now(time)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] == ["Value of key data must be binary, got nil"]
    end
  end

  describe "update image" do
    setup [:create_image]

    test "renders image when data is valid", %{conn: conn, image: %Image{id: id} = image} do
      conn = put(conn, Routes.image_path(conn, :update, image), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.image_path(conn, :show, id))

      assert %{
               "id" => id,
               "data" => "some updated data",
               "time" => time
             } = json_response(conn, 200)
      assert_approx_now(time)
    end

    test "renders errors when data is invalid", %{conn: conn, image: image} do
      conn = put(conn, Routes.image_path(conn, :update, image), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != []
    end
  end

  describe "delete image" do
    setup [:create_image]

    test "deletes chosen image", %{conn: conn, image: image} do
      conn = delete(conn, Routes.image_path(conn, :delete, image))
      assert response(conn, 204)

      conn = get(conn, Routes.image_path(conn, :show, image))
      assert json_response(conn, 404)["errors"] != ["not found"]
    end

    test "non existent image cannot be deleted", %{conn: conn} do
      conn = delete(conn, Routes.image_path(conn, :show, "0"))
      assert response(conn, 404)
    end
  end

  defp create_image(_) do
    image = fixture(:image)
    {:ok, image: image}
  end
end
