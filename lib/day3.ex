defmodule Day3 do
  import Reader
  import Helpers.Converters
  import Helpers.ListSum

  def run1() do
    solve1()
    |> format_output(1)
  end

  def run2() do
    solve2()
    |> format_output(2)
  end

  def solve1() do
    input_and_length = get_input_as_binary_number_list(3) |> Kernel.then(&({&1, length(&1)}))
    bits = most_frequent_bits(input_and_length)
    inv_bits = least_frequent_bits(input_and_length)

    [bits, inv_bits]
    |> convert_binary_to_decimal()
  end

  def solve2() do
    input_and_length = get_input_as_binary_number_list(3) |> Kernel.then(&({&1, length(&1)}))
    bits = most_frequent_bits(input_and_length)
    inv_bits = least_frequent_bits(input_and_length)

    [
      filter_by_array(input_and_length, bits, length(bits) - 1, &most_frequent_bits/1),
      filter_by_array(input_and_length, inv_bits, length(inv_bits) - 1, &least_frequent_bits/1)
    ]
    |> convert_binary_to_decimal()
  end

  def get_most_or_least_frequent_bit_per_line({list, length}, op) do
    trueOp = if(op == :most, do: 1, else: 0)
    falseOp = if(op == :most, do: 0, else: 1)

    acc_len = Enum.at(list, 0) |> length
    Enum.reduce(list, List.duplicate(0, acc_len), fn row, acc ->
      sum(row, acc)
    end)
    |> Enum.map(fn count ->
      if(count >= length - count, do: trueOp, else: falseOp)
    end)
  end

  def most_frequent_bits({list, length}), do: get_most_or_least_frequent_bit_per_line({list, length}, :most)
  def least_frequent_bits({list, length}), do: get_most_or_least_frequent_bit_per_line({list, length}, :least)

  def filter_by_array({list, _}, [], _len, _comp_fun), do: Enum.flat_map(list, &(&1))
  def filter_by_array({list, _}, [_h | _t], _len, _comp_fun) when length(list) <= 1, do: Enum.flat_map(list, &(&1))
  def filter_by_array({list, _}, [h | t], len, comp_fun) do
    idx = len - length(t)
    new_list = Enum.filter(list, fn row ->
      Enum.at(row, idx) === h
    end)

    new_filter = comp_fun.({new_list, length(new_list)})
      |> Enum.drop(idx + 1)

    filter_by_array({new_list, 0}, new_filter, len, comp_fun)
  end

  def format_output(output, task) do
    if task == 1 do
      "Gamma rate: #{Enum.at(output, 0)}, Epsilon rate: #{Enum.at(output, 1)}, Power consumption: #{Enum.product(output)}"
    else
      "Oxygen generator rating: #{Enum.at(output, 0)}, CO2 scrubber rating: #{Enum.at(output, 1)}, Life support rating: #{Enum.product(output)}"
    end
  end
end
