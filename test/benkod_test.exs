defmodule BenkodTest do
  use ExUnit.Case
  # doctest Benkod

  import Benkod

  test "encoding decoded string should bring us back to beginning" do
    msg = File.read!("example.torrent")
    assert msg |> decode |> elem(1) |> encode == msg
  end
end
