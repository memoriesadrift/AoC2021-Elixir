defmodule ReaderTest do
  use ExUnit.Case
  doctest Reader

  # Note: this test fails before day 1. oh well.
  test "Loads input" do
    assert Reader.get_input(1, true) != nil
  end
end
