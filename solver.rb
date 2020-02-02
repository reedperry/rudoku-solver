class Board
  # Divide the board up into thirds
  @@first_third = 0..2
  @@second_third = 3..5
  @@third_third = 6..8

  # There are 9 sub squares, each containing 9 individual squares on the board
  #
  # TODO This hasn't turned out to be a very nice way to use these in code,
  # seems better to have a value pair representing both the vertical and horizontal area
  TopLeft = 'top-left'
  TopCenter = 'top-center'
  TopRight = 'top-right'
  CenterLeft = 'center-left'
  Center = 'center'
  CenterRight = 'center-right'
  BottomLeft = 'bottom-left'
  BottomCenter = 'bottom-center'
  BottomRight = 'bottom-right'

  def initialize
    @squares = Array.new(9) {Array.new(9)}

    @squares = generate_game
    # 0.upto(8) { |i| 
    #   0.upto(8) { |j| 
    #     @squares[i][j] = rand(5) > 3 ? rand(8) + 1 : nil
    #   }
    # }
  end

  def isValid(row, col, number)
    if @squares[row][col] != nil
      puts "square [#{row}][#{col}] is not empty"
      return false
    elsif @squares[row].include? number
      puts "row #{row} contains #{number}"
      return false
    elsif @squares.collect { |r| r[col] }.include? number
      puts "col #{col} contains #{number}"
      return false
    else
      sub_square = nil
      case row
      when @@first_third
        case col
        when @@first_third
          sub_square = TopLeft
        when @@second_third
          sub_square = TopCenter
        when @@third_third
          sub_square = TopRight
        end
      when @@second_third
        case col
        when @@first_third
          sub_square = CenterLeft
        when @@second_third
          sub_square = Center
        when @@third_third
          sub_square = CenterRight
        end
      when @@third_third
        case col
        when @@first_third
          sub_square = BottomLeft
        when @@second_third
          sub_square = BottomCenter
        when @@third_third
          sub_square = BottomRight
        end
      end

      if sub_square != nil and is_number_in_sub_square(sub_square, number)
        puts "sub square #{sub_square} contains #{number}"
        return false
      end
    end
    return true
  end

  def is_number_in_sub_square(sub_square, number)
    case sub_square
    when TopLeft
      return @squares.slice(0, 3).map { |r| r.slice(0, 3) }.flatten.include? number
    when TopCenter
      return @squares.slice(0, 3).map { |r| r.slice(3, 3) }.flatten.include? number
    when TopRight
      return @squares.slice(0, 3).map { |r| r.slice(6, 3) }.flatten.include? number
    when CenterLeft
      return @squares.slice(3, 3).map { |r| r.slice(0, 3) }.flatten.include? number
    when Center
      return @squares.slice(3, 3).map { |r| r.slice(3, 3) }.flatten.include? number
    when CenterRight
      return @squares.slice(3, 3).map { |r| r.slice(6, 3) }.flatten.include? number
    when BottomLeft
      return @squares.slice(3, 3).map { |r| r.slice(0, 3) }.flatten.include? number
    when BottomCenter
      return @squares.slice(3, 3).map { |r| r.slice(3, 3) }.flatten.include? number
    when BottomRight
      return @squares.slice(3, 3).map { |r| r.slice(6, 3) }.flatten.include? number
    end

    return false
  end

  def printBoard
    print("___________________\n")
    for r in @squares
      print("|")
      for n in r
        print n != nil ? "#{n}|" : ' |'
      end
      puts
    end
    print("-------------------\n")
  end
end

def generate_game
  starting_state = Array.new(9) {Array.new(9)}
  starting_state[0] = [nil, 3, nil, nil, 7, nil, 5, nil, nil]
  starting_state[1] = [nil, 2, 1, nil, nil, nil, nil, 6, 9]
  starting_state[2] = [5, 4, nil, nil, nil, nil, 1, nil, nil]
  starting_state[3] = [nil, nil, nil, 9, nil, nil, nil, nil, nil]
  starting_state[4] = [8, 9, 4, 2, 6, 3, 7, 1, 5]
  starting_state[5] = [nil, nil, nil, nil, nil, 7, nil, nil, nil]
  starting_state[6] = [nil, nil, 3, nil, nil, nil, nil, 2, 1]
  starting_state[7] = [1, 7, nil, nil, nil, 6, 4, 8, nil]
  starting_state[8] = [nil, nil, 9, nil, 3, nil, nil, 5, nil]
  return starting_state
end

board = Board.new
puts board.printBoard

print "row? "
row = gets.to_i
print "col? "
col = gets.to_i
print "number? "
num = gets.to_i
puts board.isValid(row, col, num)
