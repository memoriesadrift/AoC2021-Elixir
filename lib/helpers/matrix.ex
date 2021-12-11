defmodule Helpers.Matrix do
  @moduledoc """
  Helpers for working with multidimensional lists, also called matrices.
  Credit: [Daniel Berkompas](https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/)
  """

  @doc """
  Converts a multidimensional list into a zero-indexed map.

  ## Example

      iex> list = [["x", "o", "x"]]
      ...> Matrix.from_list(list)
      %{0 => %{0 => "x", 1 => "o", 2 => "x"}}
  """
  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index), do: map
  defp do_from_list([h|t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index + 1)
  end
  defp do_from_list(other, _, _), do: other

  @doc """
  Converts a zero-indexed map into a multidimensional list.

  ## Example

      iex> matrix = %{0 => %{0 => "x", 1 => "o", 2 => "x"}}
      ...> Matrix.to_list(matrix)
      [["x", "o", "x"]]
  """
  def to_list(matrix) when is_map(matrix) do
    do_to_list(matrix)
  end

  defp do_to_list(matrix) when is_map(matrix) do
    for {_index, value} <- matrix,
        into: [],
        do: do_to_list(value)
  end
  defp do_to_list(other), do: other

  def create_map(list) do
    list
    |> Enum.map(fn row ->
      String.split(row, "", trim: true)
      |> Enum.map(&String.to_integer/1)
   end)
   |> Helpers.Matrix.from_list()
  end
  def with_mask(map) do
    Helpers.Matrix.to_list(map)
    |> Enum.map(fn row ->
      Enum.map(row, fn _e -> false end)
    end)
    |> Helpers.Matrix.from_list()
    |> Kernel.then(fn mask -> {map, mask} end)
  end

  def flood_fill(mask, map, x, y, cond_fn, size \\ 0) do
    if map[x][y] == nil || mask[x][y] || cond_fn.(map[x][y]) do
      {mask, size}
    else
      new_size = size + 1
      put_in(mask[x][y], true)
      |> flood_fill(map, x+1, y, cond_fn, new_size)
      |> Kernel.then(fn {new_mask, r_size} ->
        flood_fill(new_mask, map, x-1, y, cond_fn, r_size)
      end)
      |> Kernel.then(fn {new_mask, r_size} ->
        flood_fill(new_mask, map, x, y+1, cond_fn, r_size)
      end)
      |> Kernel.then(fn {new_mask, r_size} ->
        flood_fill(new_mask, map, x, y-1, cond_fn, r_size)
      end)
    end
  end

  def increment_around(map, x, y) do
    map
    |> Kernel.then(fn map ->
      if(map[x+1][y] != nil, do: put_in(map[x+1][y], map[x+1][y]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x][y+1] != nil, do: put_in(map[x][y+1], map[x][y+1]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x-1][y] != nil, do: put_in(map[x-1][y], map[x-1][y]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x][y-1] != nil, do: put_in(map[x][y-1], map[x][y-1]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x+1][y+1] != nil, do: put_in(map[x+1][y+1], map[x+1][y+1]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x-1][y-1] != nil, do: put_in(map[x-1][y-1], map[x-1][y-1]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x+1][y-1] != nil, do: put_in(map[x+1][y-1], map[x+1][y-1]+1), else: map)
    end)
    |> Kernel.then(fn map ->
      if(map[x-1][y+1] != nil, do: put_in(map[x-1][y+1], map[x-1][y+1]+1), else: map)
    end)
  end
end
