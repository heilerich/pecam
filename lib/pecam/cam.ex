defmodule Pecam.Cam do
  @moduledoc """
  The Cam context.
  """

  alias Pecam.Cam.Image
  alias Pecam.Repo.Image, as: RImage

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    case Memento.transaction!(fn -> Memento.Query.all(Pecam.Repo.Image) end) do
      result = [_ | _] -> Enum.map(result, fn x -> Image.from_repo(x) end)
      {:no_exists, Pecam.Repo.Image} -> []
      error -> error
    end
  end

  @doc """
  Gets a single image.

  Raises if the Image does not exist.

  ## Examples

      iex> get_image(123)
      {:ok, %Image{}}

  """
  def get_image(id) when is_integer(id) do
    case Memento.transaction!(fn -> Memento.Query.read(RImage, id) end) do
      rimage = %RImage{} -> {:ok, Image.from_repo(rimage)}
      nil -> {:error, :not_found}
      error -> error
    end
  end
  def get_image(id) do
    case Integer.parse(id) do
      {id, ""} -> get_image(id)
      _ -> {:error, :invalid_id}
    end
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, ...}

  """
  def create_image(attrs) do
    write_image(attrs)
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, ...}

  """
  def update_image(%Image{:id => id}, attrs) do
    with {:ok, _image} <- get_image(id),
      do: write_image(attrs, id)
  end

  @spec write_image(%{:data => binary(), :time => DateTime.t()}, integer() | nil) :: {:ok, Image.t()} | {:error, :invalid_params, String.t()}
  defp write_image(attrs, id \\ nil)
  defp write_image(%{:data => data, :time => %DateTime{} = time}, id) when is_binary(data) do
    {:ok, Memento.transaction!(fn ->
      %Image{id: id, time: time, data: data}
      |> RImage.from_image
      |> Memento.Query.write
    end)
    |> Image.from_repo}
  end
  defp write_image(%{:data => data, :time => time}, _id) when is_binary(data), do:
    {:error, :invalid_params, "Value of key time must be DateTime, got " <> inspect(time)}
  defp write_image(%{:data => data, :time => %DateTime{} = _time}, _id), do:
    {:error, :invalid_params, "Value of key data must be binary, got " <> inspect(data)}
  defp write_image(attrs = %{:data => _data, :time => _time} ,_id), do:
    {:error, :invalid_params, "Value of key data must be binary, value of key time must be DateTime, got " <> inspect(attrs)}
  defp write_image(attrs, _id), do: {:error, :invalid_params, "Attributes must contain data and time keys, got " <> inspect(attrs)}

  @doc """
  Deletes a Image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, ...}

  """
  def delete_image(%Image{:id => id} = _image) do
    Memento.transaction!(fn ->
      Memento.Query.read(RImage, id)
      |> Memento.Query.delete_record
    end)
  end
end
