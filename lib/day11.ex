defmodule Day11 do
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
    get_input(11)
    |> Helpers.Matrix.create_map()
    |> step_times(0, 100)
  end

  def solve2() do
    get_input(11)
    |> Helpers.Matrix.create_map()
    |> step_until_flash()
  end

  def step_times(_map, flashes, 0), do: flashes
  def step_times(map, flashes, times) do
    map
    |> step()
    |> Kernel.then(fn {map, new_flashes} ->
      step_times(map, flashes + new_flashes, times - 1)
    end)
  end

  def step_until_flash(map, count \\ 1) do
    step(map)
    |> Kernel.then(fn {new_map, _flashes} ->
      success = new_map
      |> Helpers.Matrix.to_list()
      |> Enum.all?(fn row ->
        Enum.all?(row, &(&1 == 0))
      end)

      if(success, do: count, else: step_until_flash(new_map, count + 1))
    end)

  end

  def step(map) do
    map
    |> Helpers.Matrix.to_list()
    |> Enum.map(fn row ->
      Enum.map(row, &(&1 + 1))
    end)
    |> Helpers.Matrix.from_list()
    |> Helpers.Matrix.with_mask()
    |> Kernel.then(fn {map, mask} ->
      flash(map, mask, 0, 0, 0, 100)
    end)
    |> Kernel.then(fn {map, mask, flashes} ->
      map
      |> Helpers.Matrix.to_list()
      |> Enum.with_index()
      |> Enum.map(fn {row, x} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {e, y} ->  if(mask[x][y] == true, do: 0, else: e) end)
      end)
      |> Helpers.Matrix.from_list()
      |> Kernel.then(fn new_map -> {new_map, flashes} end)
    end)
  end

  def flash(map, mask, flashes, _x, _y, 0), do: {map, mask, flashes}
  def flash(map, mask, flashes, x, y, inactivity_count) do
    point = map[x][y]

    if point > 9 do
      if mask[x][y] == false do
        new_mask = put_in(mask[x][y], true)
        new_map = Helpers.Matrix.increment_around(map, x, y)
        cond do
          map[x+1][y] != nil ->
            flash(new_map, new_mask, flashes + 1, x+1, y, 100)
          map[0][y+1] != nil ->
            flash(new_map, new_mask, flashes + 1, 0, y+1, 100)
          true ->
            flash(new_map, new_mask, flashes + 1, 0, 0, 100)
        end
      else
        cond do
          map[x+1][y] != nil ->
            flash(map, mask, flashes, x+1, y, inactivity_count - 1)
          map[0][y+1] != nil ->
            flash(map, mask, flashes, 0, y+1, inactivity_count - 1)
          true ->
            flash(map, mask, flashes, 0, 0, inactivity_count - 1)
        end
      end
    else
      cond do
        map[x+1][y] != nil ->
          flash(map, mask, flashes, x+1, y, inactivity_count - 1)
        map[0][y+1] != nil ->
          flash(map, mask, flashes, 0, y+1, inactivity_count - 1)
        true ->
          flash(map, mask, flashes, 0, 0, inactivity_count - 1)
      end
    end
  end

  def format_output(output) do
    output
  end
end
