require_relative 'piece'
require_relative 'empty_space'

class Board

  BOARD_SIZE = 8
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

  def create_grid
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, EmptySpace) }
  end

  def setup_board
    place_pieces(:white)
    place_pieces(:black)
  end

  def place_pieces(color)
    NUMBER_OF_ROWS_COLOR.times do |row|
      row += 5 if color == :black
      BOARD_SIZE.times do |col|
        pos = [row, col]
        self[pos] = Piece.new(color) if (col + row) % 2 == 0
      end
    end

    nil
  end

end
