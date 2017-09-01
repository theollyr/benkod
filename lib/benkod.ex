defmodule Benkod do
  @moduledoc """
  Documentation for Benkod.
  """

  alias Benkod.Encoder
  alias Benkod.Decoder

  def encode(data) do
    data |> Encoder.encode |> IO.iodata_to_binary
  end

  def decode(data) do
    Decoder.decode(data)
  end

  def decode!(data) do
    case decode(data) do
      {:ok, result} -> result
      {:error, e} -> raise e
    end
  end
end
