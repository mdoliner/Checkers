class Piece

  ALL_DELTAS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @board[pos] = self
    @deltas = move_deltas
  end

  def moves
    moves = []
    @deltas.each do |delta|
      moves << @pos.add_delta(delta)
    end
    moves.select { |move| move.all? { |pos| pos.between?(0, Board::SIZE - 1)}}
  end

  private

  def move_deltas
    @color == :white ? ALL_DELTAS.take(2) : ALL_DELTAS.drop(2)
  end

  def make_king
    @deltas = ALL_DELTAS
  end

end

class Array
  def add_delta(delta)
    [self[0] + delta[0], self[1] + delta[1]]
  end
end
