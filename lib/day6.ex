defmodule Day6 do
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
    get_single_line_input_as_int_list(6)
    |> Enum.frequencies()
    |> advance_age(80)
    |> Map.values()
    |> Enum.sum()
  end

  def solve2() do
    get_single_line_input_as_int_list(6)
    |> Enum.frequencies()
    |> advance_age(256)
    |> Map.values()
    |> Enum.sum()
  end

  def advance_age(school, 0), do: school
  def advance_age(school, times) do
    Map.pop(school, 0)
    |> Kernel.then(fn {spawn, school} ->
      Enum.map(school, fn {key, val} -> {key - 1, val} end)
      |> Enum.into(%{})
      |> Map.merge(%{6 => spawn, 8 => spawn},
        fn _k, v1, v2 ->
          cond do
            v1 == nil && v2 == nil -> 0
            v1 != nil && v2 == nil -> v1
            v1 == nil && v2 != nil -> v2
            v1 != nil && v2 != nil -> v1 + v2
          end
        end)
    end)
    |> advance_age(times - 1)
  end

  def format_output(output) do
    "After the given number of days there will be #{output} lanternfish schooling around the submarine."
  end
end
