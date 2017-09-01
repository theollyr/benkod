data = File.read!("test/data/archlinux-2017.09.01-x86_64.iso.torrent")

Benchee.run(%{
    "benkod"   => fn -> Benkod.decode(data) end,
    "Bento"    => fn -> Bento.Parser.parse(data) end,
    "bencode"  => fn -> Bencode.decode(data) end,
    "Bencodex" => fn -> Bencodex.decode(data) end,
    "bencoder" => fn -> Bencoder.decode(data) end,
    "bencoded" => fn -> :bencoded.decode(data) end,
}, time: 2)
