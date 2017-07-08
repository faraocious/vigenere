defmodule Vig do
  use Application
  require Logger
  @moduledoc """
  Documentation for Vig.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Vig.hello
      :world

  """
  def start(_type, _args) do
    {:ok}
  end

  def cipher(text, key) do
    do_ciphering(text, key, get_cipher_table())
  end

  def decipher(text, key) do
    do_ciphering(text, key, get_decipher_table())
  end

  def do_ciphering(text, key, table) do
    alpha = String.codepoints("abcdefghijklmnopqrstuvwxyz") 
      |> Enum.with_index 
      |> Enum.into(%{})
    prepared_text = String.codepoints(String.downcase(text))
    prepared_key = String.codepoints(
      String.duplicate(
        String.downcase(key), 
        div(
          length(prepared_text), 
          String.length(key)
        )
      )
    )

    {final, _} = Enum.reduce(
      prepared_text, {"", prepared_key},
      fn x, {acc, [key | rest]} ->
        case Map.has_key?(alpha, x) do
          true -> {"#{acc}#{Enum.at(table[key], alpha[x])}", rest}
          false -> {"#{acc}#{x}", [key | rest]}
        end
      end
    )
    to_string(final)
  end

  def get_decipher_table do
    alpha = "abcdefghijklmnopqrstuvwxyz"
    alpha_codepoints = String.codepoints(alpha)
    Enum.reduce(
      1..String.length(alpha), 
      %{},
      fn x, acc ->
        {a, b} = String.split_at(alpha, String.length(alpha) - x)
        row = "#{b}#{a}"
        Map.put(acc, Enum.at(alpha_codepoints, x, "a"), String.codepoints(row))
      end
    )
  end


  def get_cipher_table do 
    alpha = "abcdefghijklmnopqrstuvwxyz"
    Enum.reduce(
      1..String.length(alpha), 
      %{},
      fn x, acc ->
        {a, b} = String.split_at(alpha, x)
        row = "#{b}#{a}"
        Map.put(acc, String.first(row), String.codepoints(row))
      end
    )
  end
end
