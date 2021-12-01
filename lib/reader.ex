defmodule Reader do
  defp get_input_from_file(day, test) do
    extension = if test, do: ".in.test", else: ".in"
    File.read!(Path.relative("input/day#{day}" <> extension))
  end

  def get_input(day, test \\ false) do
    get_input_from_file(day, test)
    |> String.split("\n", trim: true)
  end

  def get_input_as_int_list(day, test \\ false) do
    get_input(day, test)
    |> Enum.map(&(String.to_integer(&1)))
  end
end
