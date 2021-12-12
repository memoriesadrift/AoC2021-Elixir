defmodule Day12 do
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
    get_input(12)
    |> Enum.map(fn row -> String.split(row, "-") end)
    |> Enum.flat_map(fn [h, t] -> [[h, t], [t, h]] end)
    |> compact_points()
    |> dfs()
  end

  def solve2() do
    get_input(12)
    |> Enum.map(fn row -> String.split(row, "-") end)
    |> Enum.flat_map(fn [h, t] ->
      if h != "start" || t != "end" do
        [[h, t], [t, h]]
      else
        [h,t]
      end
    end)
    |> compact_points()
    |> dfs2()
  end

  def dfs2(tree) do
    start = Enum.filter(tree, fn map -> map[:from] == "start" end) |> Enum.at(0)
    base_paths = dfs(tree, start)

    # each possible cave to visit twice
    Enum.filter(tree, fn row ->
      if row[:from] == "start" || row[:from] == "end" || row[:multi] == true do
        false
      else
        true
      end
    end)
    |> Enum.map(fn row ->
      row
      |> Map.get_and_update(:visited, fn _c -> {1, 2} end)
      |> elem(1)
    end)
    |> Kernel.then(fn layouts ->
      Enum.map(layouts, fn layout ->
        [layout | Enum.filter(tree, &(&1[:from] !== layout[:from]))]
      end)
    end)
    |> Enum.map(fn layout ->
      dfs(layout, start)
    end)
    |> Enum.map(fn paths ->
      paths - base_paths
    end)
    |> Enum.sum()
    |> Kernel.then(&(&1 + base_paths))
   end

  def dfs(tree) do
    start = Enum.filter(tree, fn map -> map[:from] == "start" end) |> Enum.at(0)
    dfs(tree, start)
  end

  def dfs(tree, node) do
    to = node[:to]

    # get valid destinations == unvisited points
    destinations = Enum.filter(tree, fn map ->
      Enum.any?(to, &(map[:from] == &1 && map[:visited] > 0))
    end)

    # mark this node as visited
    updated = Enum.map(tree,
      fn elem ->
        if elem[:from] == node[:from] do
          new_vis = if(elem[:multi], do: 1, else: elem[:visited] - 1)
          %{from: elem[:from], to: elem[:to], multi: elem[:multi], visited: new_vis}
        else
          elem
        end
    end)

    if node[:from] == "end" do
      1
    else
      if length(destinations) > 0 do
        Enum.sum(
          Enum.map(destinations,
          fn dest ->
            dfs(updated, dest)
          end)
        )
      else
        0
      end
    end
  end


  def compact_points(list, new_list \\ [])

  def compact_points([], new_list), do: new_list

  def compact_points([h | t], new_list) do
    k = Enum.at(h, 0)
    v = Enum.at(h, 1)
    uppercase = k =~ ~r(^[^a-z]*$)

    if Enum.count(new_list, fn elem -> elem[:from] == k end) > 0 do
      updated = Enum.map(new_list,
        fn elem -> if(elem[:from] == k,
        do: %{from: elem[:from], to: [v | elem[:to]], multi: elem[:multi], visited: elem[:visited]},
        else: elem)
      end)
      compact_points(t, updated)
    else
      compact_points(t, [%{from: k, to: [v], multi: uppercase, visited: 1} | new_list])
    end
  end

  def format_output(output) do
    output
  end
end
