defmodule Pecam.Cam.Image do
  @moduledoc """
  The Cam.Image struct.
  """
  @type t :: %__MODULE__{
    id:   integer,
    time:     DateTime,
    data:     binary
  }

  @enforce_keys [:time, :data]
  defstruct [:id, :time, :data]

end
