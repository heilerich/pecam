defmodule Pecam.Repo.Image do
  @moduledoc """
  The Cam.Image memento schema.
  """
  use Memento.Table,
    attributes: [:id, :time, :data],
    type: :ordered_set,
    autoincrement: true

  @spec from_image(Pecam.Cam.Image.t()) :: Pecam.Repo.Image.t()
  def from_image(image = %Pecam.Cam.Image{}) do
    %Pecam.Repo.Image{
      id: image.id,
      time: image.time,
      data: image.data
    }
  end
end
