require_relative 'piece'
require_relative 'empty_space'

class Board

  SIZE = 8
  NUMBER_OF_ROWS_COLOR = 3

  def initialize(new_board = true)
    @grid = create_grid
    setup_board if new_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def dup
    dup_board = Board.new(false)
    pieces.each { |piece| Piece.new(dup_board, piece.color, piece.pos)}
    dup_board
  end

  def to_s
    @grid.each do |row|
      row.each do |space|
        print "#{space} | "
      end
      puts
    end
  end

  def inspect
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

  def pieces
    @grid.flatten.select { |tile| tile != EmptySpace }
  end

end
