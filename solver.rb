def determine_next_to_fill(row, col, filled_squares, backtrack, board)
  # End of game. There's definitely a better solution for this
  if row == 8 && col == 8
    return [-1,-1]
  end

  if backtrack == true
    last = filled_squares.pop
    if last != nil
      return last
    else
      return board.get_first_unfilled_square
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

class Board
  # Divide the board up into thirds
  @@first_box = 0..2
  @@second_box = 3..5
  @@third_box = 6..8

  def initialize(lines)
    @squares = lines
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

  def fill_square(row, col)
    num = @squares[row][col] == 0 ? 1 : @squares[row][col] + 1

    if @squares[row][col] != 0
      # puts "#{row}, #{col} already has a number, starting from #{num}"
    end

    # Clear out the square we're about to try to fill
    @squares[row][col] = 0

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
    starting_squares = collect_starting_squares
    9.times do |row|
      9.times do |col|
        return [row, col] unless starting_squares.include? [row, col]
      end
    end
  end

  def print_board
    print("___________________\n")
    for r in @squares
      print("|")
      for n in r
        print n != 0 ? "#{n}|" : ' |'
      end
      puts
    end
    print("-------------------\n")
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
puts board.print_board

starting_squares = board.collect_starting_squares

filled_squares = []
last_filled = nil
row = 0
col = 0

20000.times do |x|
  if row == -1 || col == -1
    puts "REACHED END OF BOARD after iteration " + x.to_s 
    break
  end

  if starting_squares.include? [row,col]
    row, col = determine_next_to_fill(row, col, filled_squares, false, board)
    next
  end

  num = board.fill_square(row, col)
  if num == 0
    last_filled = nil
  else
    last_filled = [row, col]
  end

  if last_filled != nil
    filled_squares.push(last_filled)
  end

  row, col = determine_next_to_fill(row, col, filled_squares, num == 0, board)
end

board.print_board
