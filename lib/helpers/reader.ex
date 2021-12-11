defmodule Reader do
  @moduledoc """
  Module that reads input from AoC puzzle input files.
  Files are to be held in an `input` folder in the root of the
  mix project and should have the file extension `.in` or `.in.test`
  for puzzle inputs and example inputs respectively.

  ## Examples
  ```
  iex>get_input_as_int_list(1, true)
  [
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263
  ]
  ```
  """
  defp get_input_from_file(day, test) do
    extension = if test, do: ".in.test", else: ".in"
    File.read!(Path.relative("input/day#{day}" <> extension))
  end

  def get_input(day, test \\ false) do
    get_input_from_file(day, test)
    |> String.split("\n", trim: true)
  end

  def get_input_as_int_list(day, test \\ false) do
    get_input(day, test)
    |> Enum.map(&(String.to_integer(&1)))
  end

  def get_single_line_input_as_int_list(day, test \\ false) do
    get_input_from_file(day, test)
    |> String.split(",", trim: true)
    |> Enum.map(&(String.to_integer(&1)))
  end

  def get_input_as_binary_number_list(day, test \\ false) do
    get_input(day, test)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn row -> Enum.map(row, fn e -> String.to_integer(e) end) end)
  end
end
