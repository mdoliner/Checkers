class Piece

  ALL_DELTAS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def initialize(color)
    @color = color
    @king = false
    @deltas = move_deltas
  end

  def move_deltas
    @color == :white ? ALL_DELTAS.take(2) : ALL_DELTAS.drop(2)
  end

  def make_king
    @king = true
    @deltas = ALL_DELTAS
  end

  def king?
    @king
  end

end
