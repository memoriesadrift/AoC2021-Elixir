defmodule Day2 do
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
    get_input(2)
    |> parse_input()
    |> calculate_course([0,0])
  end

  def solve2() do
    get_input(2)
    |> parse_input()
    |> calculate_course_with_aim([0,0,0])
  end

  def parse_input(input) do
    Enum.map(input, fn line -> String.split line end)
    |> Enum.map(fn pair -> [Enum.at(pair, 0), Enum.at(pair, 1) |> String.to_integer] end)
  end

  def calculate_course([], acc), do: acc
  def calculate_course([h | t], acc) do
      command_dir = Enum.at(h, 0)
      command_speed = Enum.at(h, 1)

      pos = Enum.at(acc, 0)
      depth = Enum.at(acc, 1)

      cond do
        command_dir == "forward" ->
          calculate_course(t, [pos + command_speed, depth])
        command_dir == "up" ->
          calculate_course(t, [pos, depth - command_speed])
        command_dir == "down" ->
          calculate_course(t, [pos, depth + command_speed])
      end
  end

  def calculate_course_with_aim([], acc), do: acc
  def calculate_course_with_aim([h | t], acc) do
      command_dir = Enum.at(h, 0)
      command_speed = Enum.at(h, 1)

      pos = Enum.at(acc, 0)
      depth = Enum.at(acc, 1)
      aim = Enum.at(acc, 2)

      cond do
        command_dir == "forward" ->
          calculate_course_with_aim(t, [pos + command_speed, depth + aim * command_speed, aim])
        command_dir == "up" ->
          calculate_course_with_aim(t, [pos, depth, aim - command_speed])
        command_dir == "down" ->
          calculate_course_with_aim(t, [pos, depth, aim + command_speed])
      end
  end

  def format_output(output) do
    "The total forward momentum is #{Enum.at(output, 0)}, the depth is #{Enum.at(output, 1)}, the product is #{Enum.at(output, 0) * Enum.at(output, 1)}"
  end
end
