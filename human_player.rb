class HumanPlayer

  attr_reader :color

  ROW_LETTER_TO_NUM = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def initialize(board, color)
    @board = board
    @color = color
  end

  def perform_move
    begin
      print "What piece would you like to move? "
      piece = @board[parse_move(gets.chomp)]
      raise InvalidMoveError.new "That is not your piece!" if piece.color != @color
      print "What sequence of moves would you like to perform? "
      moves = gets.chomp.split(" ").map { |move| parse_move(move) }
      piece.perform_moves(moves)
    rescue InvalidMoveError => e
      puts e.message
      sleep(2)
      retry
    end
  end

  def parse_move(move)
    row = ROW_LETTER_TO_NUM[move[0].downcase]
    col = move[1].to_i
    [row, col]
  end

end
