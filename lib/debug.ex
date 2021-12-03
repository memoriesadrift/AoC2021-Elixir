defmodule Helpers.Debug do
  def debug_print_list(obj) do
    Enum.each(obj, &IO.puts/1)
    obj
  end
end
