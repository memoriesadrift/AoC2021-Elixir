defmodule Day8 do
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
    get_input(8)
    |> extract_input()
    |> Enum.map(fn pair ->
      Enum.at(pair, 1)
      |> Enum.count(fn elem ->
        len = String.length(elem)
        len == 2 || len == 4 || len == 3 || len == 7
      end)
    end)
    |> Enum.sum()
  end

  # THIS SOLUTION IS BAD!
  # There is a lot more efficient, less convoluted way of solving this problem
  # It occured to me rather late and I had already spent too much time of my day
  # working on AoC to be able to fit in a rework of this. I will come back to this
  # with some time, hopefully.
  # I consider this to be a quite naive solution, which while based in a good approach
  # is very badly written. Most of my checks are inefficient, the recursion in
  # decipher_numbers could be rewritten into a purely iterative function,
  # assign_possibilities has a LOT of redundancy and so does find_num.
  #
  # TL;DR: this is not good/idiomatic/efficient/... code, don't take it as such.
  def solve2() do
    get_input(8)
    |> extract_input()
    |> Enum.map(fn pair ->
      cipher = Enum.at(pair, 0)
      to_decipher = Enum.at(pair, 1)
      decipher_numbers(cipher, %{})
      |> Enum.map(fn map ->
        map
        |> Kernel.then(fn {key, val} -> {Enum.join(val), key} end)
      end)
      |> Enum.into(%{})
      |> decipher(to_decipher)
    end)
    |> Enum.sum()
  end

  def decipher(code, to_decipher) do
    to_decipher
    |> Enum.map(fn num ->
      num
      |> String.split("", trim: true)
      |> Enum.map(fn char ->
        Map.get(code, char)
      end)
      |> get_display_num()
    end)
    |> Enum.join()
    |> Kernel.then(&String.to_integer/1)
  end

  def get_display_num(lines) do
    lines
    |> Enum.sort()
    |> Enum.join()
    |> num_from_string()
  end

  def num_from_string(str) do
    cond do
      str == "abcefg" -> "0"
      str == "cf" -> "1"
      str == "acdeg" -> "2"
      str == "acdfg" -> "3"
      str == "bcdf" -> "4"
      str == "abdfg" -> "5"
      str == "abdefg" -> "6"
      str == "acf" -> "7"
      str == "abcdefg" -> "8"
      str == "abcdfg" -> "9"
    end
  end

  def decipher_numbers(codes, code_map, final_map \\ %{}, done9? \\ false, done3? \\ false) do
    cond do
      # Start with 1
      Enum.any?(codes, &(String.length(&1) == 2)) ->
        Enum.find(codes, &(String.length(&1) == 2))
        |> String.split("", trim: true)
        |> assign_possibilities(1, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          decipher_numbers(
            Enum.filter(codes, &(String.length(&1) != 2)),
            new_map,
            new_final
          )
        end)
      # Continue with 7, a known
      Enum.any?(codes, &(String.length(&1) == 3)) ->
        Enum.find(codes, &(String.length(&1) == 3))
        |> String.split("", trim: true)
        |> assign_possibilities(7, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          decipher_numbers(
            Enum.filter(codes, &(String.length(&1) != 3)),
            new_map,
            new_final
          )
        end)
      # Continue with 4
      Enum.any?(codes, &(String.length(&1) == 4)) ->
        Enum.find(codes, &(String.length(&1) == 4))
        |> String.split("", trim: true)
        |> assign_possibilities(4, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          decipher_numbers(
            Enum.filter(codes, &(String.length(&1) != 4)),
            new_map,
            new_final
          ) end)
      # Continue with 9, g known
      !done9? ->
        Enum.filter(codes, &(String.length(&1) == 6))
        |> Enum.find([], fn code -> find_num(9, code, code_map) end)
        |> String.split("", trim: true)
        |> assign_possibilities(9, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          code9 = Enum.filter(codes, &(String.length(&1) == 6))
          |> Enum.find([], fn code -> find_num(9, code, code_map) end)
          new_codes = Enum.filter(codes, &(&1 != code9))
          decipher_numbers(
            new_codes,
            new_map,
            new_final,
            true
          ) end)
      # continue with 8, e known
      Enum.any?(codes, &(String.length(&1) == 7)) ->
        Enum.find(codes, &(String.length(&1) == 7))
        |> String.split("", trim: true)
        |> assign_possibilities(8, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          decipher_numbers(
            Enum.filter(codes, &(String.length(&1) != 7)),
            new_map,
            new_final,
            true
          ) end)
      # continue with 3, b, d known
      !done3? ->
        Enum.filter(codes, &(String.length(&1) == 5))
        |> Enum.find([], fn code -> find_num(3, code, code_map) end)
        |> String.split("", trim: true)
        |> assign_possibilities(3, code_map, final_map)
        |> Kernel.then(fn {new_map, new_final} ->
          code3 = Enum.filter(codes, &(String.length(&1) == 5))
          |> Enum.find([], fn code -> find_num(3, code, code_map) end)
          new_codes = Enum.filter(codes, &(&1 != code3))
          decipher_numbers(
            new_codes,
            new_map,
            new_final,
            true,
            true
          ) end)
        # finally, do 2, filling in final two letters
        done3? ->
          Enum.filter(codes, &(String.length(&1) == 5))
          |> Enum.find([], fn code -> find_num(2, code, code_map) end)
          |> String.split("", trim: true)
          |> assign_possibilities(2, code_map, final_map)
          |> Kernel.then(fn {_new_map, new_final} -> new_final end)
    end
  end

  def assign_possibilities(symbols, num, code_map, final_map) do
    cond do
      num == 1 ->
        Map.merge(code_map, %{"c" => symbols, "f" => symbols},
            fn _k, v1, v2 -> merge_fun(v1, v2)
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)

      num == 7 ->
        a = Enum.filter(symbols, fn symbol -> Enum.all?(Map.get(code_map, "c"), &(&1 != symbol)) end)
        Map.merge(code_map, %{"a" => a},
            fn _k, v1, v2 -> merge_fun(v1, v2)
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)
        |> Kernel.then(fn {new_map, final_map} ->
          new_final = Map.merge(final_map, %{"a" => a},
            fn _k, v1, v2 -> merge_fun(v1, v2)
            end)
          {new_map, new_final}
          end)

      num == 4 ->
        # at this point c and f are equal, so it's enough to check one of them
        uniques = Enum.filter(symbols, fn symbol -> Enum.all?(Map.get(code_map, "c"), &(&1 != symbol)) end)
        Map.merge(code_map, %{"b" => uniques, "d" => uniques},
            fn _k, v1, v2 -> merge_fun(v1, v2)
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)

      num == 9 ->
        values = Map.values(code_map) |> Enum.flat_map(&(&1)) |> Enum.uniq()
        g = Enum.filter(symbols, &(!Enum.find(values, fn val -> val == &1 end)))
        Map.merge(code_map, %{"g" => g},
            fn _k, v1, v2 -> merge_fun(v1, v2)
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)
        |> Kernel.then(fn {new_map, final_map} ->
          new_final = Map.merge(final_map, %{"g" => g},
            fn _k, v1, v2 -> merge_fun(v1, v2)
            end)
          {new_map, new_final}
          end)

        num == 8 ->
          values = Map.values(code_map) |> Enum.flat_map(&(&1)) |> Enum.uniq()
          e = Enum.filter(symbols, &(!Enum.find(values, fn val -> val == &1 end)))
          Map.merge(code_map, %{"e" => e},
              fn _k, v1, v2 -> merge_fun(v1, v2)
            end)
          |> Kernel.then(fn new_map -> {new_map, final_map} end)
          |> Kernel.then(fn {new_map, final_map} ->
            new_final = Map.merge(final_map, %{"e" => e},
              fn _k, v1, v2 -> merge_fun(v1, v2)
              end)
            {new_map, new_final}
            end)

      num == 3 ->
        d = Enum.filter(Map.get(code_map, "d"), &(Enum.find(symbols, fn val -> val == &1 end)))
        b = Enum.filter(Map.get(code_map, "b"), &(!Enum.find(d, fn val -> val == &1 end)))

        Map.merge(code_map, %{"d" => d, "b" => b},
          fn _k, v1, v2 ->
            cond do
              v1 == nil && v2 == nil -> nil
              v1 != nil && v2 == nil -> v1
              v1 == nil && v2 != nil -> v2
              v1 != nil && v2 != nil -> v2
            end
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)
        |> Kernel.then(fn {new_map, final_map} ->
          new_final = Map.merge(final_map, %{"d" => d, "b" => b},
            fn _k, v1, v2 -> merge_fun(v1, v2)
            end)
          {new_map, new_final}
          end)

      num == 2 ->
        c = Enum.filter(Map.get(code_map, "c"), &(Enum.find(symbols, fn val -> val == &1 end)))
        f = Enum.filter(Map.get(code_map, "f"), &(!Enum.find(c, fn val -> val == &1 end)))

        Map.merge(code_map, %{"c" => c, "f" => f},
          fn _k, v1, v2 ->
            cond do
              v1 == nil && v2 == nil -> nil
              v1 != nil && v2 == nil -> v1
              v1 == nil && v2 != nil -> v2
              v1 != nil && v2 != nil -> v2
            end
          end)
        |> Kernel.then(fn new_map -> {new_map, final_map} end)
        |> Kernel.then(fn {new_map, final_map} ->
          new_final = Map.merge(final_map, %{"c" => c, "f" => f},
            fn _k, v1, v2 -> merge_fun(v1, v2)
            end)
          {new_map, new_final}
          end)
    end
  end

  def find_num(num, code_string, code_map) do
    cond do
      num == 9 ->
        code_string
        |> String.split("", trim: true)
        |> Kernel.then(fn code ->
          String.split("abcdf", "", trim: true)
          |> Enum.all?(fn char ->
            Enum.all?(Map.get(code_map, char), fn elem ->
              char == nil || elem == nil || Enum.find(code, &(&1 == elem)) != nil end)
            end)
          end)
      num == 3 ->
        code_string
        |> String.split("", trim: true)
        |> Kernel.then(fn code ->
          String.split("acfg", "", trim: true)
          |> Enum.all?(fn char ->
            Enum.all?(Map.get(code_map, char), fn elem ->
              char == nil || elem == nil || Enum.find(code, &(&1 == elem)) != nil end)
            end)
          end)
      num == 2 ->
        code_string
        |> String.split("", trim: true)
        |> Kernel.then(fn code ->
          String.split("adeg", "", trim: true)
          |> Enum.all?(fn char ->
            Enum.all?(Map.get(code_map, char), fn elem ->
              char == nil || elem == nil || Enum.find(code, &(&1 == elem)) != nil end)
            end)
          end)

    end
  end

  # helper to merge lists
  def merge_fun(v1, v2) do
    cond do
      v1 == nil && v2 == nil -> nil
      v1 != nil && v2 == nil -> v1
      v1 == nil && v2 != nil -> v2
      v1 != nil && v2 != nil -> Enum.uniq(v1 ++ v2)
    end
  end
  def extract_input(input) do
    input
    |> Enum.map(&(String.split(&1, " | ")))
    |> Enum.map(fn block ->
      Enum.map(block, &String.split/1)
    end)
  end

  def format_output(output) do
    output
  end
end
