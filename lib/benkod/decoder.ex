defmodule Benkod.Decoder do
  defmodule Error do
    defexception [:type, :at, :invalid]

    def message(%{type: type, at: at, invalid: invalid}) do
      case type do
        :number -> "invalid number `#{invalid}' at position #{at}"
        :unexpected -> "unexpected character `#{invalid}' at position #{at}"
        :extra -> "extra input at position #{at}"
        :eoi -> "end of input while parsing"
      end
    end
  end

  def decode(data) do
    case do_decode(data) do
      {result, ""} -> {:ok, result}
      {_, rest} -> err(:extra, rest, rest)
    end
  catch
    :eoi -> {:error, Error.exception(type: :eoi, at: -1)}
    {type, msg, rest, offset} ->
      at = byte_size(data) - byte_size(rest) - offset
      msg = IO.iodata_to_binary([msg])

      {:error, Error.exception(type: type, at: at, invalid: msg)}
  end

  defp do_decode("i" <> rest), do: decode_number(rest)
  defp do_decode("l" <> rest), do: decode_list(rest, [])
  defp do_decode("d" <> rest), do: decode_map(rest, [])
  defp do_decode(<<c>> <> _ = rest) when c in ?0..?9, do: decode_string(rest)
  defp do_decode(rest), do: err_rest(rest)

  ## Decode number

  defp decode_number("0e" <> rest), do: {0, rest}
  defp decode_number("e" <> _ = rest), do: err(:number, "ie", rest, 1)
  defp decode_number("-e" <> _ = rest), do: err(:number, "i-e", rest, 1)
  defp decode_number("-0" <> _ = rest), do: err(:number, "i-0...", rest, 1)
  defp decode_number(<<digit>> <> rest) when digit in '-123456789',
    do: continue_number(rest, [digit])
  defp decode_number(rest), do: err_rest(rest)

  defp continue_number("e" <> rest, digits) do
    {rev_digits_to_integer(digits), rest}
  end
  defp continue_number(<<digit>> <> rest, digits) when digit in ?0..?9,
    do: continue_number(rest, [digit | digits])
  defp continue_number(rest, _), do: err_rest(rest)

  ## Decode string

  defp decode_string("0:" <> rest), do: {"", rest}
  defp decode_string(<<digit>> <> rest) when digit in ?1..?9,
    do: continue_string(rest, [digit])
  defp decode_string(rest), do: err_rest(rest)

  defp continue_string(":" <> rest, digits) do
    length = rev_digits_to_integer(digits)
    <<string :: binary-size(length)>> <> rest = rest
    {string, rest}
  rescue
    MatchError -> err(:eoi)
  end

  defp continue_string(<<digit>> <> rest, digits) when digit in ?0..?9,
    do: continue_string(rest, [digit | digits])
  defp continue_string(rest, _), do: err_rest(rest)

  ## Decode list

  defp decode_list("e" <> rest, acc), do: {Enum.reverse(acc), rest}
  defp decode_list(rest, acc) do
    {result, rest} = do_decode(rest)
    decode_list(rest, [result | acc])
  end

  ## Decode map

  defp decode_map("e" <> rest, acc), do: {Map.new(acc), rest}
  defp decode_map(rest, acc) do
    with {key, rest} <- decode_string(rest),
         {value, rest} <- do_decode(rest),
    do:  decode_map(rest, [{key, value} | acc])
  end

  ## Other

  defp rev_digits_to_integer(digits) do
    digits |> Enum.reverse |> List.to_integer
  end

  ## Error handling

  defp err(type), do: throw type
  defp err(type, msg, rest, offset \\ 0), do: throw {type, msg, rest, offset}
  defp err_rest(""), do: err(:eoi)
  defp err_rest(<<other>> <> _ = rest), do: err(:unexpected, other, rest)
end
