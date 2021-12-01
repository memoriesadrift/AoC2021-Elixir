defmodule Day1 do
  import Reader

  def run1() do
    solve1()
    |> format_output()
  end

  def run2() do
    solve2()
    |> format_output()
  end

  def solve1() do
    get_input(1, false)
    |> Enum.map(fn elem -> String.to_integer elem end)
    |> compare()
  end

  def solve2() do
    get_input(1, false)
    |> Enum.map(fn elem -> String.to_integer elem end)
    |> compare2()
  end

  def compare([]), do: 0
  def compare([h | t]), do: if(h < Enum.at(t, 0) && Enum.at(t, 0) != nil, do: 1, else: 0) + compare(t)

  def compare2([]), do: 0
  def compare2([h | t]) do
    if Enum.at(t, 2) == nil do
      0
    else
      if(h < Enum.at(t, 2), do: 1, else: 0) + compare2(t)
    end
  end

  def format_output(output) do
      "The measurement increases #{output} times"
  end

end
