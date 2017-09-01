defmodule BenkodTest do
  use ExUnit.Case
  # doctest Benkod

  import Benkod

  test "encoding decoded string should bring us back to beginning" do
    msg = File.read!("test/data/archlinux-2017.09.01-x86_64.iso.torrent")
    assert msg |> decode |> elem(1) |> encode == msg
  end
end
