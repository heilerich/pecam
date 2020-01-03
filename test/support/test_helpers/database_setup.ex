defmodule Pecam.TestHelpers.SetupDatabase do
  @spec setup :: :ok
  def setup do
    :code.all_loaded()
    |> Enum.map(fn {name, _path} -> name end)
    |> filter_modules
    |> create_tables
    :ok
  end

  defp create_tables(module_atoms) do
    module_atoms
    |> Enum.each(fn x ->
      Memento.Table.create(x)
      Memento.Table.clear(x)
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
