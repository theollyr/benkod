{bench_data, _} = Code.eval_file("bench_helper.exs", "bench")

inputs = %{
  "Torrent (single)" => Benkod.decode!(bench_data[:single_torrent]),
  "Torrent (multi)"  => Benkod.decode!(bench_data[:multi_torrent]),
  "List"             => bench_data[:list],
  "List (numbers)"   => bench_data[:list_numbers],
  "List (combined)"  => bench_data[:list_combined],
  "Map"              => bench_data[:map],
}

Benchee.run(%{
  "benkod"   => fn data -> Benkod.encode(data) end,
  "Bento"    => fn data -> Bento.encode!(data) end,
  "bencode"  => fn data -> Bencode.encode!(data) end,
  "Bencodex" => fn data -> Bencodex.encode(data) end,
  "bencoder" => fn data -> Bencoder.encode(data) end,
  "bencoded" => fn data -> :bencoded.encode(data) end,
}, time: 2, warmup: 1, inputs: inputs)
