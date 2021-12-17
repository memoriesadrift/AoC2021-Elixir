defmodule Day17 do
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
    get_input(17)
    |> Enum.join()
    |> String.split("", trim: true)
    |> Enum.drop_while(&(&1 != "y"))
    |> Enum.drop(2)
    |> Enum.join()
    |> String.split("..", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&abs/1)
    |> Enum.max
    |> Kernel.then(&(Enum.sum(1..&1-1)))
  end

  def solve2() do
    Enum.filter(-700..700, fn v ->
      step(v, 137..171, 0, 0, false) == 1
    end)
    |> Enum.map(fn x_v ->
      Enum.map(-700..700, fn y_v ->
        threshold_step(y_v, -98..-73, 0, x_v, 137..171, 0)
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def threshold_step(velocity, target_range, pos, x_velocity, x_target, x_pos) do
    new_pos = pos + velocity
    new_velocity = velocity - 1

    new_x_pos = x_pos + x_velocity
    new_x_velocity = max(x_velocity - 1, 0)
    if new_x_pos in x_target do
      if new_pos in target_range do
        1
      else
        cond do
          new_pos < min(target_range.first, target_range.last)->
            0
          true ->
            threshold_step(new_velocity, target_range, new_pos, new_x_velocity, x_target, new_x_pos)
        end
      end
    else
      cond do
        new_pos < min(target_range.first, target_range.last)->
          0
        x_velocity == 0 && new_x_pos < x_target.first ->
          0
        true ->
          threshold_step(new_velocity, target_range, new_pos, new_x_velocity, x_target, new_x_pos)
      end
    end
  end

  def step(velocity, target_range, pos \\ 0, initial_pos \\ 0, kickback \\ true) do
    new_pos = pos + velocity
    new_velocity = if(kickback, do: velocity - 1, else: max(velocity - 1, 0))
    if new_pos in target_range do
      1
    else
      cond do
        new_pos > target_range.last ->
          0
        !kickback && velocity == 0 && new_pos < target_range.first ->
          0
        true ->
          step(new_velocity, target_range, new_pos, initial_pos, kickback)
      end
    end
  end

  def format_output(output) do
    output
  end
end
