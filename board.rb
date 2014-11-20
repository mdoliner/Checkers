require_relative 'piece'
require_relative 'empty_space'

class Board

  SIZE = 8
  NUMBER_OF_ROWS_COLOR = 3

  def initialize(grid = create_grid)
    @grid = grid
    setup_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []= (pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def make_slide (start_pos, end_pos)
    piece = self[start_pos]
    if piece.moves.include?(end_pos) && self[end_pos].nil?
      self[start_pos], self[end_pos] = EmptySpace, piece
    end
    nil
  end

  private

  def create_grid
    @grid = Array.new(SIZE) { Array.new(SIZE, EmptySpace) }
  end

  def setup_board
    place_pieces(:white)
    place_pieces(:black)
  end

  def place_pieces(color)
    NUMBER_OF_ROWS_COLOR.times do |row|
      row += 5 if color == :white
      SIZE.times do |col|
        pos = [row, col]
        Piece.new(self, color, pos) if (col + row) % 2 == 1
      end
    end

    nil
  end

end
