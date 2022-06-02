require './board'

def read_game_file path
  if !File.exist?(path)
    return
  end
  puts "Reading file #{path}..."
  rows = []
  file = File.open(path, 'r') do |f|
    f.each_line($/, chomp: true) do |l|
      rows.push((l.split '').collect {|x| x.to_i })
    end
  end
  rows
end

rows = read_game_file ARGV[0]
board = Board.new(rows)
puts board

puts "Solving..."

filled_squares = []
last_filled = nil
row = 0
col = 0
iterations = 0

until row == -1 && col == -1
  iterations += 1

  if board.initial_squares.include? [row,col]
    row, col = board.determine_next_to_fill(row, col, filled_squares, false)
    next
  end

  filled_number = board.fill_square(row, col)
  filled_squares.push([row, col]) unless filled_number == 0

  row, col = board.determine_next_to_fill(row, col, filled_squares, filled_number == 0)
end

puts board
