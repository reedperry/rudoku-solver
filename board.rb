class Board
  # Divide the board up into thirds
  NONET_ONE = 0..2
  NONET_TWO = 3..5
  NONET_THREE = 6..8

  attr_reader :initial_squares

  def initialize(rows)
    @grid = rows
    @initial_squares = collect_initial_squares
  end

  def number_valid_in_square?(row, col, number)
    if square_occupied?(row, col)
      return false
    elsif number_in_row?(number, row)
      return false
    elsif number_in_column?(number, col)
      return false
    elsif number_in_same_nonet_as_square?(number, row, col)
      return false
    end
    true
  end

  def find_containing_nonet(row, col)
    nonet = nil
    case row
    when NONET_ONE
      nonet = [:top]
    when NONET_TWO
      nonet = [:center]
    when NONET_THREE
      nonet = [:bottom]
    end

    case col
    when NONET_ONE
      nonet.push(:left)
    when NONET_TWO
      nonet.push(:center)
    when NONET_THREE
      nonet.push(:right)
    end

    nonet
  end

  def square_occupied?(row, col)
    return @grid[row][col] != 0
  end

  def number_in_row?(number, row)
    return @grid[row].include? number
  end

  def number_in_column?(number, col)
    return @grid.collect { |r| r[col] }.include? number
  end

  def number_in_same_nonet_as_square?(number, row, col)
    nonet = find_containing_nonet(row, col)
    if nonet != nil && number_in_nonet?(nonet, number)
      return true
    else
      return false
    end
  end

  def number_in_nonet?(nonet, number)
    rows = nil
    cols = nil
    case nonet[0]
    when :top
      rows = @grid.slice(0, 3)
    when :center
      rows = @grid.slice(3, 3)
    when :bottom
      rows = @grid.slice(6, 3)
    end

    case nonet[1]
    when :left
      return rows.map { |r| r.slice(0, 3) }.flatten.include? number
    when :center
      return rows.map { |r| r.slice(3, 3) }.flatten.include? number
    when :right
      return rows.map { |r| r.slice(6, 3) }.flatten.include? number
    end

    return false
  end

  def clear_squares_from(row, col)
    while row < 9
      while col < 9
        @grid[row][col] = 0 unless @initial_squares.include? [row, col]
        col += 1
      end
      col = 0
      row += 1
    end
  end

  def fill_square(row, col)
    num = @grid[row][col] + 1
    clear_squares_from(row, col)

    num += 1 while !number_valid_in_square?(row, col, num) && num < 10

    if num < 10
      @grid[row][col] = num
      return num
    else
      return 0
    end
  end

  def collect_initial_squares
    filled = Array.new
    9.times do |row|
      9.times do |col|
        filled.push([row, col]) if @grid[row][col] != 0
      end
    end

    return filled
  end

  def find_first_unfilled_square
    9.times do |row|
      9.times do |col|
        return [row, col] unless @initial_squares.include? [row, col]
      end
    end
  end

  def determine_next_to_fill(row, col, filled_squares, backtrack = nil)
    if reached_end_of_board?(row, col)
      # End of game
      return [-1,-1]
    end

    if backtrack == true
      return find_backtrack_target(filled_squares)
    else
      row, col = find_next_empty_square(row, col)
    end

    [row, col]
  end

  def find_backtrack_target(filled_squares)
    last_filled = filled_squares.pop
    if last_filled != nil
      return last_filled
    else
      return find_first_unfilled_square
    end
  end

  def find_next_empty_square(row, col)
    row, col = next_square(row, col)
    while !reached_end_of_board?(row, col) && square_occupied?(row, col)
      row, col = next_square(row, col)
    end

    [row, col]
  end

  def next_square(row, col)
    if col == 8
      return [row + 1, 0]
    else
      return [row, col + 1]
    end
  end

  def reached_end_of_board?(row, col)
    return row == 8 && col == 8
  end

  def to_s
    s = "___________________\n"
    for r in @grid
      s += "|"
      for n in r
        s += n != 0 ? "#{n}|" : ' |'
      end
      s += "\n"
    end
    s += "-------------------\n"
    return s
  end

end
