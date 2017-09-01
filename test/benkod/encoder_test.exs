defmodule Benkod.EncoderTest do
  use ExUnit.Case, async: true
  import Benkod

  test "encode numbers" do
    assert encode(0) == "i0e"
    assert encode(-1) == "i-1e"
    assert encode(1234567890) == "i1234567890e"
    assert encode(1_000_000_000) == "i1000000000e"
    assert encode(-1_000_000_000) == "i-1000000000e"
  end

  test "encode strings" do
    assert encode("") == "0:"
    assert encode("hello") == "5:hello"
    assert encode("🗺") == "4:🗺"
  end

  test "encode list" do
    assert encode([]) == "le"
    assert encode([[],[]]) == "llelee"
    assert encode([0, 1, 2]) == "li0ei1ei2ee"
    assert encode([0, [0]]) == "li0eli0eee"
    assert encode(["adele", "", "hello"]) == "l5:adele0:5:helloe"
    assert encode([[0], ["hello"]]) == "lli0eel5:helloee"
    assert encode([%{}, %{in: []}]) == "lded2:inleee"
  end

  test "encode map" do
    assert encode(%{}) == "de"
    assert encode(%{adele: "hello"}) == "d5:adele5:helloe"
    assert encode(%{b: 1, a: 2}) == "d1:ai2e1:bi1ee"
    assert encode(%{aaa: 0, aa: 1, a: 2}) == "d1:ai2e2:aai1e3:aaai0ee"
    assert encode(%{ab: [0], cd: ["nil"]}) == "d2:abli0ee2:cdl3:nilee"
    assert encode(%{adele: %{"25" => "Hello", "21" => "Rumour Has It"}, list: [0, -1]}) ==
      "d5:adeled2:2113:Rumour Has It2:255:Helloe4:listli0ei-1eee"
  end
end
