defmodule Template do
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
    get_input(1)
  end

  def solve2() do
    get_input(1)
  end

  def format_output(output) do
    output
  end
end
