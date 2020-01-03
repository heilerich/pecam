defmodule Pecam.Cam.Image do
  @moduledoc """
  The Cam.Image struct.
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          time: DateTime.t(),
          data: binary()
        }

  @enforce_keys [:time, :data]
  defstruct [:id, :time, :data]

  @spec from_repo(Pecam.Repo.Image.t()) :: Pecam.Cam.Image.t()
  def from_repo(repo_image = %Pecam.Repo.Image{}) do
    %Pecam.Cam.Image{
      id: repo_image.id,
      time: repo_image.time,
      data: repo_image.data
    }
  end
end
