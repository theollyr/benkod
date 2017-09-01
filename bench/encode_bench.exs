raw_data = File.read!("test/data/archlinux-2017.09.01-x86_64.iso.torrent")
{:ok, data} = Benkod.decode(raw_data)

Benchee.run(%{
    "benkod"   => fn -> Benkod.encode(data) end,
    "Bento"    => fn -> Bento.encode!(data) end,
    "bencode"  => fn -> Bencode.encode!(data) end,
    "Bencodex" => fn -> Bencodex.encode(data) end,
    "bencoder" => fn -> Bencoder.encode(data) end,
    "bencoded" => fn -> :bencoded.encode(data) end,
}, time: 2)
