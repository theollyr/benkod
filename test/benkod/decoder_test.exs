defmodule Benkod.DecoderTest do
  use ExUnit.Case

  import Benkod
  alias Benkod.Decoder.Error

  defp make_error(base, extend \\ []) do
    {:error, struct(base, extend)}
  end

  test "error messages" do
    assert_raise Error, "invalid number `ie' at position 0", fn -> decode!("ie") end
    assert_raise Error, "unexpected character `g' at position 1", fn -> decode!("lg") end
    assert_raise Error, "end of input while parsing", fn -> decode!("") end
    assert_raise Error, "extra input at position 2", fn -> decode!("lele") end
  end

  test "invalid input" do
    number_error = Error.exception(type: :number, at: 0)
    unexpected_error = Error.exception(type: :unexpected)
    eoi_error = Error.exception(type: :eoi, at: -1)
    extra_error = Error.exception(type: :extra)

    assert decode("ie") == make_error(number_error, invalid: "ie")
    assert decode("i-0e") == make_error(number_error, invalid: "i-0...")
    assert decode("i-01e") == make_error(number_error, invalid: "i-0...")
    assert decode("i-e") == make_error(number_error, invalid: "i-e")

    assert decode("i5i") == make_error(unexpected_error, invalid: "i", at: 2)
    assert decode("i04e") == make_error(unexpected_error, invalid: "0", at: 1)
    assert decode("2hi") == make_error(unexpected_error, invalid: "h", at: 1)
    assert decode("l2:hise") == make_error(unexpected_error, invalid: "s", at: 5)
    assert decode("dde") == make_error(unexpected_error, invalid: "d", at: 1)
    assert decode("dl2:hi") == make_error(unexpected_error, invalid: "l", at: 1)
    assert decode("di42ei42ee") == make_error(unexpected_error, invalid: "i", at: 1)
    assert decode("d2:hi:") == make_error(unexpected_error, invalid: ":", at: 5)

    assert decode("i5") == make_error(eoi_error)
    assert decode("i-5") == make_error(eoi_error)
    assert decode("5:adel") == make_error(eoi_error)
    assert decode("l") == make_error(eoi_error)
    assert decode("li42e") == make_error(eoi_error)
    assert decode("l5:adele5:helle") == make_error(eoi_error)
    assert decode("lle") == make_error(eoi_error)
    assert decode("d") == make_error(eoi_error)
    assert decode("d1:") == make_error(eoi_error)
    assert decode("d1:ad") == make_error(eoi_error)

    assert decode("i42ei42e") == make_error(extra_error, invalid: "i42e", at: 4)
    assert decode("2:hi4:what") == make_error(extra_error, invalid: "4:what", at: 4)
    assert decode("4:adele") == make_error(extra_error, invalid: "e", at: 6)
    assert decode("lele") == make_error(extra_error, invalid: "le", at: 2)
    assert decode("dede") == make_error(extra_error, invalid: "de", at: 2)
  end

  test "valid input" do
    assert decode("i0e") == {:ok, 0}
    assert decode("i45e") == {:ok, 45}
    assert decode("i-45e") == {:ok, -45}
    assert decode("i123456789012345678901234567890e") == {:ok, 123456789012345678901234567890}
    assert decode("i-123456789012345678901234567890e") == {:ok, -123456789012345678901234567890}

    assert decode("0:") == {:ok, ""}
    assert decode("5:hello") == {:ok, "hello"}
    assert decode("4:🗺") == {:ok, "🗺"}

    assert decode("llee") == {:ok, [[]]}
    assert decode("l5:adele5:helloe") == {:ok, ["adele", "hello"]}
    assert decode("li42e5:helloe") == {:ok, [42, "hello"]}

    assert decode("de") == {:ok, %{}}
    assert decode("d5:adele5:hello4:fromi0ee") == {:ok, %{"adele" => "hello", "from" => 0}}
  end
end
