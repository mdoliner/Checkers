class Piece

  ALL_DELTAS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @board[pos] = self
    @deltas = move_deltas
  end



  private

  def move_deltas
    @color == :white ? ALL_DELTAS.take(2) : ALL_DELTAS.drop(2)
  end

  def make_king
    @deltas = ALL_DELTAS
  end

end
