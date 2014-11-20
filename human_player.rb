class HumanPlayer

  attr_reader :color

  COL_LETTER_TO_NUM = {
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

  def moving_piece
    print "What piece would you like to move? "
    move = gets.chomp
    return :save if move.downcase == "save"
    return :exit if move.downcase == "exit"
    piece = @board[parse_move(move)]
    raise InvalidMoveError.new "That is not your piece!" if piece.color != @color
    piece
  end

  def perform_move_sequence(piece)
    print "\n\nWhat sequence of moves would you like to perform? "
    moves = gets.chomp.split(" ").map { |move| parse_move(move) }
    piece.perform_moves(*moves)
  end

  def parse_move(move)
    raise InvalidMoveError.new "That is not a valid move." if move.length != 2
    col = COL_LETTER_TO_NUM[move[0].downcase]
    row = Integer(move[1]) - 1
    if col.nil? || !@board.on_board?(row)
      raise InvalidMoveError.new "That is not a valid move."
    end
    [row, col]
  end

end
