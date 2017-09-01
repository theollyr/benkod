{bench_data, _} = Code.eval_file("bench_helper.exs", "bench")

inputs = %{
  "Torrent (single)" => bench_data[:single_torrent],
  "Torrent (multi)"  => bench_data[:multi_torrent],
  "List"             => Benkod.encode(bench_data[:list]),
  "List (numbers)"   => Benkod.encode(bench_data[:list_numbers]),
  "List (combined)"  => Benkod.encode(bench_data[:list_combined]),
  "Map"              => Benkod.encode(bench_data[:map]),
}

Benchee.run(%{
  "benkod"   => fn data -> Benkod.decode(data) end,
  "Bento"    => fn data -> Bento.Parser.parse(data) end,
  "bencode"  => fn data -> Bencode.decode(data) end,
  "Bencodex" => fn data -> Bencodex.decode(data) end,
  "bencoder" => fn data -> Bencoder.decode(data) end,
  "bencoded" => fn data -> :bencoded.decode(data) end,
}, time: 2, warmup: 1, inputs: inputs)
