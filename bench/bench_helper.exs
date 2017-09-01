generate_bencode = fn base ->
  base |> Stream.cycle |> Enum.take(500)
end

%{
  single_torrent: File.read!("test/data/archlinux-2017.09.01-x86_64.iso.torrent"),
  multi_torrent: File.read!("test/data/LibrivoxM4bCollectionAudiobooksMain_archive.torrent"),
  list: generate_bencode.([[]]),
  list_numbers: generate_bencode.([0, -1, 1_234_567, -890]),
  list_combined: generate_bencode.([1, "1", [], %{}]),
  map: ?A..?z |> Stream.map(&<<&1>>) |> Stream.with_index |> Enum.into(%{}),
}
