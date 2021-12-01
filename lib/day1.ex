defmodule Day1 do
  import Reader

  def run1() do
    solve1()
    |> format_output()
  end

  def solve1() do
    get_input(1, false)
    |> Enum.map(fn elem -> String.to_integer elem end)
    |> compare()
  end
  def compare([]), do: 0
  def compare([h | t]), do: if(h < Enum.at(t, 0) && Enum.at(t, 0) != nil, do: 1, else: 0) + compare(t)

  def format_output(output) do
      "The measurement increases #{output} times"
  end

end
