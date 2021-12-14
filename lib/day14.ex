defmodule Day14 do
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
    solve(10, false)
  end

  def solve2() do
    solve(40, false)
  end

  def solve(times, test \\ false) do
    get_input(14, test)
    |> parse_input()
    |> Kernel.then(fn {polymer, rules} ->
      rules
      |> Enum.map(fn {rule, _to} ->
        %{rule => polymer |> Enum.join |> String.split(rule) |> length |> Kernel.then(&(&1 - 1))}
      end)
      |> change_polymer(rules, times, Enum.frequencies(polymer))
      |> Kernel.then(fn {_map, freq} ->
        freq
        |> Enum.map(fn {_k, v} -> v end)
        |> Enum.min_max()
        |> Kernel.then(fn {min, max} -> max - min end)
      end)
    end)
  end

  def change_polymer(map, _rules, 0, letter_counts), do: {map, letter_counts}
  def change_polymer(map, rules, times, letter_counts) do
    counts = map
    |> Enum.map(fn map ->
      k = Map.keys(map) |> Enum.at(0)
      v = Map.get(map, k)
      output = Map.get(rules, k)

      %{output => v}
    end)
    |> Enum.filter(fn map ->
      v = Map.values(map) |> Enum.at(0)
      v > 0
    end)
    |> Enum.reduce(fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 + v1 end)
    end)

    new_counts = Map.merge(counts, letter_counts, fn _k, v1, v2 -> v2 + v1 end)

    map
    |> Enum.flat_map(fn map ->
      k = Map.keys(map) |> Enum.at(0)
      v = Map.get(map, k)
      output = Map.get(rules, k)
      output1 = output <> String.slice(k, 1..1)
      output2 = String.slice(k, 0..0) <> output

      [%{output1 => v}, %{output2 => v}]
    end)
    |> Enum.filter(fn map ->
      v = Map.values(map) |> Enum.at(0)
      v > 0
    end)
    |> Enum.reduce(fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 + v1 end)
    end)
    |> Kernel.then(fn res ->
      res
      |> Enum.map(fn {k, v} ->
        %{k => v}
      end)
      |> change_polymer(rules, times-1, new_counts)
    end)

  end

  def parse_input(input) do
    polymer = Enum.at(input, 0) |> String.split("", trim: true)

    rules = input
    |> Enum.split(1)
    |> Kernel.then(fn {_, row} -> row end)
    |> Enum.map(fn row ->
      String.split(row, " -> ")
    end)
    |> Enum.reduce(%{}, fn [from, to], acc -> Map.put(acc, from, to) end)

    {polymer, rules}
  end

  def format_output(output) do
    output
  end
end
