defmodule Pecam.CamTest do
  use Pecam.DataCase

  alias Pecam.Cam

  describe "images" do
    alias Pecam.Cam.Image

    @valid_attrs %{data: "some data", time: "2010-04-17T14:00:00Z"}
    @update_attrs %{data: "some updated data", time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{data: nil, time: nil}

    def image_fixture(attrs \\ %{}) do
      {:ok, image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cam.create_image()

      image
    end

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Cam.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Cam.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = Cam.create_image(@valid_attrs)
      assert image.data == "some data"
      assert image.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_image/1 with invalid data returns error" do
      assert {:error, _message} = Cam.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      assert {:ok, %Image{} = image} = Cam.update_image(image, @update_attrs)
      assert image.data == "some updated data"
      assert image.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_image/2 with invalid data returns error" do
      image = image_fixture()
      assert {:error, _message} = Cam.update_image(image, @invalid_attrs)
      assert image == Cam.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Cam.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Cam.get_image!(image.id) end
    end
  end
end
