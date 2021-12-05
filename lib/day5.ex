defmodule Day5 do
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
    get_input(5)
    |> get_coordinate_list()
    |> populate_map(%{}, false)
    |> get_most_frequent_count()
  end

  def solve2() do
    get_input(5)
    |> get_coordinate_list()
    |> populate_map(%{}, true)
    |> get_most_frequent_count()
  end

  @spec get_coordinate_list(any) :: list
  def get_coordinate_list(input) do
    Enum.map(input, fn elem ->
      String.split(elem, " -> ")
      |> Enum.map(fn coords ->
        parsed = String.split(coords, ",")
                  |> Enum.map(&String.to_integer/1)
        %{x: Enum.at(parsed, 0), y: Enum.at(parsed, 1)}
      end)
    end)
  end

  def populate_map([], map, _diagonals?), do: map
  def populate_map([h | t], map, diagonals?) do
    from = Enum.at(h, 0)
    to = Enum.at(h, 1)

    new_map = find_line(from, to, diagonals?)
    |> add_or_update_points(map)

    populate_map(t, new_map, diagonals?)
  end

  def add_or_update_points([], map), do: map
  def add_or_update_points([h | t], map), do: add_or_update_points(t, Map.update(map, h, 1, fn old_val -> old_val + 1 end))

  def find_line(from, to, check_diagonals?) do
    cond do
      check_diagonals? && are_points_diagonal?(from, to) ->
        cond do
          from.x > to.x  && from.y > to.y ->
            Enum.map((0..abs(from.x - to.x)), &(%{y: to.y + &1, x: to.x + &1}))
          from.x < to.x && from.y < to.y ->
            Enum.map((0..abs(from.x - to.x)), &(%{y: from.y + &1, x: from.x + &1}))
          from.x > to.x  && from.y < to.y ->
            Enum.map((0..abs(from.x - to.x)), &(%{y: from.y + &1, x: from.x - &1}))
          from.x < to.x  && from.y > to.y ->
            Enum.map((0..abs(from.x - to.x)), &(%{y: from.y - &1, x: from.x + &1}))
        end
      from.x == to.x ->
        if from.y > to.y do
          Enum.map((to.y..from.y), &(%{x: from.x, y: &1}))
        else
          Enum.map((from.y..to.y), &(%{x: from.x, y: &1}))
        end
      from.y == to.y ->
        if from.x > to.x do
          Enum.map((to.x..from.x), &(%{y: from.y, x: &1}))
        else
          Enum.map((from.x..to.x), &(%{y: from.y, x: &1}))
        end
      true ->
        []
    end
  end

  def are_points_diagonal?(a, b), do: abs(a.x - b.x) == abs(a.y - b.y)

  def get_most_frequent_count(map) do
    Enum.map(map, &(elem(&1, 1)))
    |> Enum.filter(&(&1 >= 2))
    |> Enum.count()
  end

  def format_output(output) do
    output
  end
end
