# Benkod

Benkod (from slovak word kód meaning code) is a [Bencode](https://en.wikipedia.org/wiki/Bencode) library that does single-pass decoding. Decoding also has simple error detection (type and byte position).

# Usage

```elixir
iex> Benkod.decode("ld3key5:alohaei32ei-2ee")
{:ok, [%{"key" => "aloha"}, 32, -2]}
iex> Benkod.decode!("ld3key5:alohaei32ei-2ee")
[%{"key" => "aloha"}, 32, -2]

iex> Benkod.encode(["some", [], %{exa: "mple"}])
"l4:someled3:exa4:mpleee"
```

## TODO

* documentation
* hex

## License

See [LICENSE](LICENSE).
