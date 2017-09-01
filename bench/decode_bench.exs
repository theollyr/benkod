defmodule DecodeBench do
    use Benchfella

    setup_all do
        File.read("example.torrent")
    end

    bench "benkod" do
        Benkod.decode(bench_context)
    end

    bench "Bento" do
        Bento.Parser.parse(bench_context)
    end

    bench "bencode" do
        Bencode.decode(bench_context)
    end

    bench "Bencodex" do
        Bencodex.decode(bench_context)
    end

    bench "bencoder" do
        Bencoder.decode(bench_context)
    end

    bench "bencoded" do
        :bencoded.decode(bench_context)
    end
end
