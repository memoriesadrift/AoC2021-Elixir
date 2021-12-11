defmodule Day9 do
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
    get_input(9)
    |> Helpers.Matrix.create_map()
    |> find_lowest_points()
    |> Enum.map(fn {value, {_x, _y}} -> value + 1 end)
    |> Enum.sum()
  end

  def solve2() do
    get_input(9)
    |> Helpers.Matrix.create_map()
    |> Helpers.Matrix.with_mask()
    |> Kernel.then(fn {map, mask} ->
      find_basins(mask, map, find_lowest_points(map), [])
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def find_basins(_mask, _map, [], basin_sizes) do basin_sizes end
  def find_basins(mask, map, [h | t], basin_sizes) do
    {_value, {x, y}} = h

    {new_mask, basin_size} = Helpers.Matrix.flood_fill(mask, map, x, y, fn e -> e == 9 end)
    find_basins(new_mask, map, t, [basin_size | basin_sizes])
  end

  def find_lowest_points(map, x \\ 0, y \\ 0, points \\ []) do
    point = map[x][y]
    is_local_min? = point != nil && 0 == [
      map[x+1][y],
      map[x-1][y],
      map[x][y+1],
      map[x][y-1],
    ]
    |> Enum.filter(&(&1 != nil))
    |> Enum.filter(&(&1 <= point))
    |> Enum.count()

    cond do
      map[x+1][y] != nil ->
        if is_local_min? do
          find_lowest_points(map, x+1, y, [{point,{x,y}} | points])
        else
          find_lowest_points(map, x+1, y, points)
        end
      map[0][y+1] != nil ->
        if is_local_min? do
          find_lowest_points(map, 0, y+1, [{point,{x,y}} | points])
        else
          find_lowest_points(map, 0, y+1, points)
        end
      true ->
        points
    end
  end

  def format_output(output) do
    output
  end
end
