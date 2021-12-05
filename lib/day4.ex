defmodule Day4 do
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
    get_board_times_and_scores()
    |> Enum.min_by(&(&1.time))
  end

  def solve2() do
    get_board_times_and_scores()
    |> Enum.max_by(&(&1.time))
  end

  def get_board_times_and_scores() do
    input = get_input(4)
    pull_order = get_bingo_pull_order(Enum.at(input, 0))

    Enum.map(get_bingo_boards(input), fn board -> get_board_win_time(board, pull_order, 1) end)
  end

  def get_bingo_pull_order(input) do
    String.split(input, ",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def get_bingo_boards(input) do
    board_size = 5
    Enum.filter(input, &(!String.contains?(&1, ",")))
    |> Enum.map(fn row ->
      String.split(row, " ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn row ->
      Enum.map(row, fn num ->
        %{num: num, checked: false}
      end)
    end)
    |> Enum.chunk_every(board_size)
  end

  def get_board_win_time(_board, [], time), do: %{time: time, score: 0}
  def get_board_win_time(board, [h | t], time) do
    new_board = Enum.map(board, fn row ->
      Enum.map(row, fn elem ->
        if(elem.num === h, do: %{num: elem.num, checked: true}, else: elem)
      end)
    end)

    if (check_board_won(new_board)) do
      %{time: time, score: calculate_score(new_board, h)}
    else
      get_board_win_time(new_board, t, time + 1)
    end
  end

  def check_board_won(board) do
    column_board = get_columns(board)

    row_complete? = Enum.any?(board, fn row ->
      Enum.all?(row, fn elem -> elem.checked end)
    end)

    column_complete? = Enum.any?(column_board, fn row ->
      Enum.all?(row, fn elem -> elem.checked end)
    end)

    row_complete? || column_complete?
  end

  def calculate_score(board, last_num) do
    Enum.map(board, fn row ->
      Enum.filter(row, &(!&1.checked))
      |> Enum.map(&(&1.num))
      |> Enum.sum()
    end)
    |> Enum.sum()
    |> Kernel.then(&(&1 * last_num))
  end

  def get_columns(board) do
    [
      Enum.map(board, fn row -> Enum.at(row, 0) end),
      Enum.map(board, fn row -> Enum.at(row, 1) end),
      Enum.map(board, fn row -> Enum.at(row, 2) end),
      Enum.map(board, fn row -> Enum.at(row, 3) end),
      Enum.map(board, fn row -> Enum.at(row, 4) end),
    ]
  end

  def format_output(output) do
    "The board to pick finishes with time #{output.time} and score #{output.score}"
  end
end
