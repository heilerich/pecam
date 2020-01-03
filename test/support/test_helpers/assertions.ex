defmodule Pecam.TestHelpers.Assertions do
  import ExUnit.Assertions

  def assert_approx_now(time, delta \\ 1)
  def assert_approx_now(time = %DateTime{}, delta) when is_integer(delta) do
    {:ok, now} = DateTime.now("Etc/UTC")
    assert DateTime.diff(time, now) < delta
  end
  def assert_approx_now(time, delta) when is_integer(delta) when is_bitstring(time) do
    with {:ok, datetime, _utc_offset} <- DateTime.from_iso8601(time),
      do: assert_approx_now(datetime, delta)
  end
end
