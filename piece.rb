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

  def slide_moves
    moves(@slide_deltas)
  end

  def jump_moves
    moves(@jump_deltas)
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

end

class Array
  def add_delta(delta)
    [self[0] + delta[0], self[1] + delta[1]]
  end
end
