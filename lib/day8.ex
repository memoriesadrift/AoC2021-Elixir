defmodule Day8 do
  import Reader

  def run1() do
    solve1()
    |> format_output
  end

  def run2() do
    solve2()
    |> format_output
  end

  def solve1() do
    get_input(8)
    |> extract_input()
    |> Enum.map(fn pair ->
      Enum.at(pair, 1)
      |> Enum.count(fn elem ->
        len = String.length(elem)
        len == 2 || len == 4 || len == 3 || len == 7
      end)
    end)
    |> Enum.sum()
  end

  def extract_input(input) do
    input
    |> Enum.map(&(String.split(&1, " | ")))
    |> Enum.map(fn block ->
      Enum.map(block, &String.split/1)
    end)
  end

  def format_output(output) do
    output
  end
end
