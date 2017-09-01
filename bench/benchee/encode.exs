raw_data = File.read!("example.torrent")
{:ok, data} = Benkod.decode(raw_data)

Benchee.run(%{
    "benkod"   => fn -> Benkod.encode(data) end,
    "Bento"    => fn -> Bento.encode!(data) end,
    "bencode"  => fn -> Bencode.encode!(data) end,
    "Bencodex" => fn -> Bencodex.encode(data) end,
    "bencoder" => fn -> Bencoder.encode(data) end,
    "bencoded" => fn -> :bencoded.encode(data) end,
}, time: 2)
