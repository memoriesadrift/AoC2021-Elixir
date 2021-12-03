defmodule Helpers do
  @moduledoc """
  Helper module containing functions useful for solving AoC problems.
  """
  defmodule Converters do
    def convert_binary_to_decimal(list) do
      list
      |> Enum.map(fn num -> Enum.join(num) |> Integer.parse(2) end)
      |> Enum.map(&(elem(&1, 0)))
    end
  end

  defmodule ListSum do
    @moduledoc """
    Helper to sum elements of two lists elementwise using the `sum/3` function.
    `sum/3` has a default argument for total, which adds the lists without any preexisting total

    ## Example:
    ```
    iex> foo = [1, 2, 3]
    iex> bar = [3, 2, 1]
    iex> sum(foo, bar)
    [4, 4, 4]
    ```
    ### Credit
    Solution by: [domvas](https://elixirforum.com/u/domvas) on the elixir forums
    """
    def sum(list1, list2, total \\ [])

    def sum([], [], total) do
      Enum.reverse(total)
    end

    def sum([h1 | t1], [], total) do
      sum(t1, [], [h1 | total])
    end

    def sum([], [h2 | t2], total) do
      sum([], t2, [h2 | total])
    end

    def sum([h1 | t1], [h2 | t2], total) do
      sum(t1, t2, [h1 + h2 | total])
    end
  end
end
