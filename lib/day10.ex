defmodule Day10 do
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
    get_input(10)
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&(check_validity(&1, [])))
    |> Enum.filter(&is_number/1)
    |> Enum.sum()
  end

  def solve2() do
    get_input(10)
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&(check_validity(&1, [])))
    |> Enum.filter(&is_list/1)
    |> Enum.map(&(assign_values(&1, 0)))
    |> Enum.sort()
    |> Kernel.then(fn arr ->
      Enum.at(arr, arr |> length() |> div(2))
    end)
  end

  def assign_values([], score), do: score
  def assign_values([h | t], score) do
    cond do
      h == ")" ->
        assign_values(t, score * 5 + 1)
      h == "]" ->
        assign_values(t, score * 5 + 2)
      h == "}" ->
        assign_values(t, score * 5 + 3)
      h == ">" ->
        assign_values(t, score * 5 + 4)
    end
  end

  def check_validity([], brackets), do: brackets
  def check_validity([h | t], brackets) do
    cond do
      Enum.find(["[", "(", "{", "<"], &(&1 == h)) != nil ->
        case h do
          "[" ->
            check_validity(t, ["]" | brackets])
          "(" ->
            check_validity(t, [")" | brackets])
          "{" ->
            check_validity(t, ["}" | brackets])
          "<" ->
            check_validity(t, [">" | brackets])
        end
      true ->
        if Enum.at(brackets, 0) != h do
          case h do
            ")" -> 3
            "]" -> 57
            "}" -> 1197
            ">" -> 25137
          end
          else
            [_ | new_brackets] = brackets
            check_validity(t, new_brackets)
        end
    end
  end

  def format_output(output) do
    output
  end
end
