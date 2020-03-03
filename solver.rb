class Board
  # Divide the board up into thirds
  @@first_box = 0..2
  @@second_box = 3..5
  @@third_box = 6..8

  attr_reader :starting_squares

  def initialize(lines)
    @squares = lines
    @starting_squares = collect_starting_squares
  end

  def is_valid(row, col, number)
    if @squares[row][col] != 0
      return false
    elsif @squares[row].include? number
      return false
    elsif @squares.collect { |r| r[col] }.include? number
      return false
    else
      box = determine_containing_box(row, col)
      if box != nil && is_number_in_box(box, number)
        return false
      end
    end
    return true
  end

  def determine_containing_box(row, col)
    box = nil
    case row
    when @@first_box
      box = [:top]
    when @@second_box
      box = [:center]
    when @@third_box
      box = [:bottom]
    end

    case col
    when @@first_box
      box.push(:left)
    when @@second_box
      box.push(:center)
    when @@third_box
      box.push(:right)
    end

    return box
  end

  def is_number_in_box(box, number)
    rows = nil
    cols = nil
    case box[0]
    when :top
      rows = @squares.slice(0, 3)
    when :center
      rows = @squares.slice(3, 3)
    when :bottom
      rows = @squares.slice(6, 3)
    end

    case box[1]
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
        @squares[row][col] = 0 unless @starting_squares.include? [row, col]
        col += 1
      end
      col = 0
      row += 1
    end
  end

  def fill_square(row, col)
    num = @squares[row][col] + 1
    clear_squares_from(row, col)

    num += 1 while !is_valid(row, col, num) && num < 10

    if num < 10
      @squares[row][col] = num
      return num
    else
      return 0
    end
  end

  def collect_starting_squares
    filled = Array.new
    9.times do |row|
      9.times do |col|
        filled.push([row, col]) if @squares[row][col] != 0
      end
    end

    return filled
  end

  def get_first_unfilled_square
    9.times do |row|
      9.times do |col|
        return [row, col] unless @starting_squares.include? [row, col]
      end
    end
  end

  def to_s
    s = "___________________\n"
    for r in @squares
      s += "|"
      for n in r
        s += n != 0 ? "#{n}|" : ' |'
      end
      s += "\n"
    end
    s += "-------------------\n"
    return s
  end

  def determine_next_to_fill(row, col, filled_squares, backtrack)
    # End of game. There's definitely a better solution for this
    if row == 8 && col == 8
      return [-1,-1]
    end

    if backtrack == true
      last = filled_squares.pop
      if last != nil
        return last
      else
        return get_first_unfilled_square
      end
    else
      if col == 8
        col = 0
        row += 1
      else
        col += 1
      end
    end

    return [row, col]
  end

end

def read_game_file path
  if !File.exist?(path)
    return
  end
  puts "Reading file #{path}..."
  lines = []
  file = File.open(path, 'r') do |f|
    f.each_line($/, chomp: true) do |l|
      lines.push((l.split '').collect {|x| x.to_i })
    end
  end
  return lines
end

lines = read_game_file ARGV[0]
board = Board.new(lines)
puts board

filled_squares = []
last_filled = nil
row = 0
col = 0
iterations = 0

until row == -1 && col == -1
  iterations += 1

  if board.starting_squares.include? [row,col]
    row, col = board.determine_next_to_fill(row, col, filled_squares, false)
    next
  end

  num = board.fill_square(row, col)
  last_filled = num == 0 ? nil : [row, col]
  filled_squares.push(last_filled) unless last_filled == nil
  row, col = board.determine_next_to_fill(row, col, filled_squares, num == 0)
end

puts board
puts "FINISHED PUZZLE after iteration " + iterations.to_s 
