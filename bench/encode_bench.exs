defmodule EncodeBench do
  use Benchfella

  setup_all do
    msg = File.read!("example.torrent")
    Benkod.Decoder.decode(msg)
  end

  bench "benkod" do
    Benkod.encode(bench_context)
  end

  bench "Bento" do
    Bento.encode!(bench_context)
  end

  bench "bencode" do
    Bencode.encode!(bench_context)
  end

  bench "Bencodex" do
    Bencodex.encode(bench_context)
  end

  bench "bencoder" do
    Bencoder.encode(bench_context)
  end

  bench "bencoded" do
    :bencoded.encode(bench_context)
  end
end
