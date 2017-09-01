defmodule BenkodTest do
  use ExUnit.Case, async: true
  # doctest Benkod

  import Benkod

  test "single torrent: decoded == encoded" do
    torrent = File.read!("test/data/archlinux-2017.09.01-x86_64.iso.torrent")
    assert torrent |> decode! |> encode == torrent
  end

  test "multi torrent: decoded == encoded" do
    torrent = File.read!("test/data/LibrivoxM4bCollectionAudiobooksMain_archive.torrent")
    assert torrent |> decode! |> encode == torrent
  end
end
