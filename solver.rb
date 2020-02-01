class Board
  @@first_third = 0..2
  @@second_third = 3..5
  @@third_third = 6..8

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

    0.upto(8) { |i| 
      0.upto(8) { |j| 
        @squares[i][j] = rand(5) > 3 ? rand(8) + 1 : nil
      }
    }
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
      # case/when works, but not sure it actually helps readability 
      if @@first_third.include? row
        case col
        when @@first_third
          sub_square = TopLeft
        when @@second_third
          sub_square = TopCenter
        when @@third_third
          sub_square = TopRight
        end
        # if @@first_third.include? col
        #   sub_square = TopLeft
        # elsif @@second_third.include? col
        #   sub_square = TopCenter
        # elsif @@third_third.include? col
        #   sub_square = TopRight
        # end
      elsif @@second_third.include? row
        if @@first_third.include? col
          sub_square = CenterLeft
        elsif @@second_third.include? col
          sub_square = Center
        elsif @@third_third.include? col
          sub_square = CenterRight
        end
      elsif @@third_third.include? row
        if @@first_third.include? col
          sub_square = BottomLeft
        elsif @@second_third.include? col
          sub_square = BottomCenter
        elsif @@third_third.include? col
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

board = Board.new
puts board.printBoard

print "row? "
row = gets.to_i
print "col? "
col = gets.to_i
print "number? "
num = gets.to_i
puts board.isValid(row, col, num)
