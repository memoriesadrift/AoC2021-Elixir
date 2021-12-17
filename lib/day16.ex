defmodule Day16 do
  import Reader

  @hex_to_binary %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111",
  }

  def run1() do
    solve1()
    |> format_output
  end

  def run2() do
    solve2()
    |> format_output
  end

  def solve1() do
    # The solution is actually printed to the screen.
    # Copy the numbers out, then just load the file and
    # data |> Enum.map(&String.to_integer/1) |> Enum.sum/1
    get_input(16)
    |> Enum.at(0)
    |> String.split("", trim: true)
    |> Enum.map(&(@hex_to_binary[&1]))
    |> Enum.join()
    |> parse_packets()
  end

  def solve2() do
    get_input(16, true)
    |> Enum.at(0)
    |> String.split("", trim: true)
    |> Enum.map(&(@hex_to_binary[&1]))
    |> Enum.join()
    |> parse_packets()
  end

  def parse_packets(encoded_string) do
    encoded_string
    |> parse_packet_version_and_type()
    |> Kernel.then(fn {version, type, contents} ->
       parse_packet_contents(version, type, contents)
    end)
  end

  def parse_literal_packet(packet) do
    {cont_bit, data} = packet |> String.slice(0, 5) |> String.split_at(1)

    if cont_bit == "1" do
      {n_data, rest} = parse_literal_packet(String.slice(packet, 5..-1))
      {data <> n_data, rest}
    else
      {data, String.slice(packet, 5..-1)}
    end
  end

  def parse_operation_packet(packet, type) do
    op = type |> String.to_integer(2)
    length_bit = packet |> String.at(0)
    if length_bit == "0" do
      contents = parse_len_type_0_packet(String.slice(packet, 1..-1))
      cond do
        op == 0 ->
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.sum
        op == 1 ->
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.product
        op == 2 ->
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.min

        op == 3 ->
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.max
        op == 5 ->
          # Greater Than
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs > rhs, do: 1, else: 0)
          end)
        op == 6 ->
          # Lesser Than
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs < rhs, do: 1, else: 0)
          end)
        op == 7 ->
          # Equal to
          contents
          |> elem(0)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs == rhs, do: 1, else: 0)
          end)
      end
    else
      contents = parse_len_type_1_packet(String.slice(packet, 1..-1))
      cond do
        op == 0 ->
          contents
          |> Enum.map(&(elem(&1, 0)))
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.sum
        op == 1 ->
          contents
          |> Enum.map(&(elem(&1, 0)))
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.product
        op == 2 ->
          contents
          |> Enum.map(&(elem(&1, 0)))
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.min
        op == 3 ->
          contents
          |> Enum.map(&(elem(&1, 0)))
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.max
        op == 5 ->
          # Greater Than
          contents
          |> Enum.map(&(elem(&1, 0)))
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.reverse
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs > rhs, do: 1, else: 0)
          end)
        op == 6 ->
          # Lesser Than
          contents
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.reverse
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs < rhs, do: 1, else: 0)
          end)
        op == 7 ->
          # Equal to
          contents
          |> Enum.take_while(&is_bitstring/1)
          |> Enum.map(&(&1 |> String.to_integer(2)))
          |> Enum.reverse
          |> Kernel.then(fn list ->
            lhs = Enum.at(list, 0)
            rhs = Enum.at(list, 1)
            if(lhs == rhs, do: 1, else: 0)
          end)
      end
    end
  end

  def parse_len_type_0_packet(packet) do
    len = packet |> String.slice(0, 15) |> String.to_integer(2)
    contents = packet |> String.slice(15, len)
    rest = packet |> String.slice(15+len..-1)
    {List.flatten(parse_nested_packets(contents)), rest}
  end

  def parse_nested_packets(contents) do
    #IO.puts("contents: #{contents}")
    parse_packets(contents)
    |> Kernel.then(fn {data, rest} ->
      parse_nested_packets(data, rest)
    end)
  end
  def parse_nested_packets(data, rest) do
    #IO.puts("data: #{data}, rest: #{rest}")
    if String.split(rest, "", trim: true) |> Enum.all?(&(&1 == "0")) do
      data
    else
      [data | [parse_nested_packets(rest)]]
    end
  end

  def parse_len_type_1_packet(packet) do
    num_packets = packet |> String.slice(0, 11) |> String.to_integer(2)
    contents = packet |> String.slice(11..-1)

    Enum.reduce(1..num_packets, [{nil, contents}], fn _n, acc ->
      {data, rest} = parse_packets(Enum.at(acc, 0) |> elem(1))
      if rest != nil || length(rest) == 0 do
        [{data, rest} | acc]
      else
        [{data, ""} | acc]
      end
    end)
  end
  def parse_packet_contents(_version, type, packet) do
    cond do
      type == "100" ->
        parse_literal_packet(packet)
      true ->
        parse_operation_packet(packet, type)
    end
  end

  def parse_packet_version_and_type(encoded_string) do
    version = encoded_string |> String.slice(0..2)
    type = encoded_string |> String.slice(3..5)
    contents = encoded_string |> String.slice(6..-1)
    # Uncomment for task 1!
    # IO.puts(version |> String.to_integer(2))

    {version, type, contents}
  end

  def format_output(output) do
    output
  end
end
