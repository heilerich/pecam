defmodule Mix.Tasks.Pecam.Schema do
  use Mix.Task

  @shortdoc "Create memento tables"

  def run(_args) do
    nodes = [ node() ]

    Mix.shell().info("Creating schema on disk")

    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    :code.all_loaded()
      |> Enum.map(fn {name, _path} -> name end)
      |> filter_modules
      |> create_tables(nodes)
  end

  defp create_tables(module_atoms, nodes) do
    module_atoms
    |> Enum.each(fn x ->
      Mix.shell().info("Creating table " <> Atom.to_string(x))
      Memento.Table.create!(x, disc_copies: nodes)
    end)
  end

  defp filter_modules(module_atoms) do
    module_atoms
    |> Enum.filter(fn x ->
      Atom.to_string(x)
      |> String.match?(~r/Pecam\.Repo\..*/)
    end)
  end
end
