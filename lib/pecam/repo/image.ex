defmodule Pecam.Repo.Image do
  @moduledoc """
  The Cam.Image memento schema.
  """
  use Memento.Table,
    attributes: [:id, :time, :data],
    type: :ordered_set,
    autoincrement: true

end
