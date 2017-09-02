defmodule Benkod.Encoder do
  def encode(bitstring) when is_bitstring(bitstring) do
    size = bitstring |> byte_size |> Integer.to_string
    [size, ?:, bitstring]
  end
  def encode(atom) when is_atom(atom), do: encode(Atom.to_string(atom))
  def encode(number) when is_integer(number), do: [?i, Integer.to_string(number), ?e]
  def encode(list) when is_list(list), do: do_encode_list(list, [])
  def encode(map) when is_map(map), do: do_encode_map(map)

  defp do_encode_list([], acc) do
    [?l, Enum.reverse(acc), ?e]
  end
  defp do_encode_list([e | rest], acc), do: do_encode_list(rest, [encode(e) | acc])

  defp do_encode_map(map) do
    map
    |> Map.to_list
    |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
    |> Enum.reduce([?e], fn {key, value}, acc ->
      [[encode(key), encode(value)] | acc]
    end)
    |> (&[?d | &1]).()
  end
end
