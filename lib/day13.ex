defmodule Day13 do
  import Reader

  def run1() do
    solve1()
    |> format_output
  end

  def run2() do
    solve2()
  end

  def solve1() do
    {coords, instructions} = get_input(13, false) |> parse_input()

    coords
    |> fold([Enum.at(instructions, 0)])
    |> Enum.count
  end

  def solve2() do
    {coords, instructions} = get_input(13, false) |> parse_input()
    folded = coords |> fold(instructions)
    max_x = folded |> Enum.max_by(&(&1[:x])) |> Kernel.then(&(&1[:x]))
    max_y = folded |> Enum.max_by(&(&1[:y])) |> Kernel.then(&(&1[:y]))

    # The input is rotated left and mirrored horizontally.
    # Rotate right, then mirror horizontally to see output
    for x <- 0..max_x  do
      for y <- 0..max_y do
        point = folded |> Enum.filter(&(&1[:x] == x)) |> Enum.filter(&(&1[:y] == y)) |> Kernel.then(fn point ->
          if length(point) < 1 do
            " "
          else
            "#"
          end
        end)
        IO.write(point)
      end
      IO.puts(" ")
    end
  end

  def fold(points, instructions)

  def fold(points, []), do: points
  def fold(points, [ix | t]) do
    dir = if(ix.dir == "x", do: :x, else: :y)
    pos = ix.pos
    points
    |> Enum.filter(fn point -> !(point[dir] == pos) end)
    |> Enum.map(fn point ->
      if point[dir] > pos do
        dist = point[dir] - pos
        if dir == :x do
          %{x: point[dir] - dist*2, y: point[:y]}
        else
          %{y: point[dir] - dist*2, x: point[:x]}
        end
      else
        point
      end
    end)
    |> Enum.uniq()
    |> fold(t)
  end

  def parse_input(input) do
    instructions = input
    |> Enum.drop_while(&(String.contains?(&1, ",")))
    |> Enum.map(fn row ->
      String.slice(row, 11..-1)
      |> String.split("=")
      |> Kernel.then(fn [dir, pos] ->
        %{dir: dir, pos: String.to_integer(pos)}
      end)
    end)

    coords = input
    |> Enum.take_while(&(String.contains?(&1, ",")))
    |> Enum.map(&(String.split(&1, ",")))
    |> Enum.map(fn row ->
      %{x: Enum.at(row, 0) |> String.to_integer(),
        y: Enum.at(row, 1) |> String.to_integer()}
    end)

    {coords, instructions}
  end

  def format_output(output) do
    output
  end
end
