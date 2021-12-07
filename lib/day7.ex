defmodule Day7 do
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
    get_single_line_input_as_int_list(7, false)
    |> solve(&dist/2)
  end

  def solve2() do
    get_single_line_input_as_int_list(7, false)
    |> solve(&sum_dist/2)
  end

  def solve(input, comp_fun) do
    Enum.map(
      Enum.min_max(input) |> Kernel.then(fn {min, max} -> min..max end),
      fn point ->
        Enum.map(input, &(comp_fun.(point, &1)))
        |> Enum.sum()
    end)
    |> Enum.min()
  end

  def dist(a, b), do: abs(a - b)

  def sum_dist(a, b) when abs(a - b) == 0, do: 0
  def sum_dist(a, b), do: trunc((abs(a - b) * (abs(a - b) + 1)) / 2)

  def format_output(output) do
    "The optimal crab-gathering spot is #{output}."
  end
end
