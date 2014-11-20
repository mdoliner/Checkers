class InvalidMoveError < IOError
end

class Piece

  ALL_SLIDE_DELTAS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  ALL_JUMP_DELTAS = [[-2, -2], [-2, 2], [2, -2], [2, 2]]

  attr_reader :color
  attr_accessor :pos

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @board[pos] = self
    @slide_deltas = slide_deltas
    @jump_deltas = jump_deltas
  end

  def perform_slide(end_pos)
    if slide_moves.include?(end_pos)
      @board[@pos], @board[end_pos] = EmptySpace, self
      @pos = end_pos
    else
      raise InvalidMoveError.new "You can't move there."
    end

    nil
  end

  def perform_jump(end_pos)
    middle_pos = middle_pos(@pos, end_pos)
    if jump_moves.include?(end_pos)
      @board[@pos], @board[middle_pos] = EmptySpace, EmptySpace
      @board[end_pos] = self
      @pos = end_pos
    else
      raise InvalidMoveError.new "You can't move there."
    end

    nil
  end


  def slide_moves
    moves = moves(@slide_deltas)
    moves.select { |move| @board[move].nil? }
  end

  def jump_moves
    moves(@jump_deltas).select do |move|
      @board[move].nil?  &&
      @board[middle_pos(@pos, move)].is_enemy?(@color)
    end
  end

  def is_enemy?(color)
    @color != color
  end

  def to_s
    @color == :white ? "○" : "●"
  end

  private

  def slide_deltas
    @color == :white ? ALL_SLIDE_DELTAS.take(2) : ALL_SLIDE_DELTAS.drop(2)
  end

  def jump_deltas
    @color == :white ? ALL_JUMP_DELTAS.take(2) : ALL_JUMP_DELTAS.drop(2)
  end

  def moves(deltas)
    moves = []
    deltas.each do |delta|
      moves << @pos.add_delta(delta)
    end
    moves.select { |move| move.all? { |pos| pos.between?(0, Board::SIZE - 1)}}
  end

  def make_king
    @slide_deltas = ALL_SLIDE_DELTAS
    @jump_deltas = ALL_JUMP_DELTAS
  end

  def middle_pos(pos1, pos2)
    [(pos1[0] + pos2[0]) / 2, (pos1[1] + pos2[1]) / 2]
  end

end

class Array
  def add_delta(delta)
    [self[0] + delta[0], self[1] + delta[1]]
  end
end
