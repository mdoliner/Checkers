require_relative 'piece'
require_relative 'empty_space'
require 'colorize'

class Board

  BOARD_SIZE = 8
  NUMBER_OF_ROWS_COLOR = 3
  KING_ROWS = {red: 0, black: 7}
  CELL_HEIGHT = 3


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
    pieces.each { |piece| Piece.new(dup_board, piece.color, piece.pos, piece.king?)}
    dup_board
  end

  def pieces_of_color(color)
    pieces.select { |piece| piece.color == color}
  end

  def promote_king(color)
    promotion_index = promote_king_index(color)
    if promotion_index
      piece = self[[KING_ROWS[color], promotion_index]]
      piece.make_king unless piece.king?
    end

    nil
  end

  def promote_king_index(color)
    @grid[KING_ROWS[color]].index { |piece| piece.color == color }
  end

  def on_board?(pos)
    pos.between?(0, BOARD_SIZE - 1)
  end

  def render_achromatic
    print "    "
    BOARD_SIZE.times { |col| print " #{(col+97).chr}  "}
    print "\n   ╔" + "═══╦" * (BOARD_SIZE-1) + "═══╗"
    @grid.each_with_index do |row, row_num|
      print "\n #{row_num+1} ║"
      row.each do |space|
        print (" #{space} ║")
      end
      print "\n   ╠" + "═══╬"*(BOARD_SIZE-1) + "═══╣" unless row_num == 7
    end
    print "\n   ╚" + "═══╩" * (BOARD_SIZE-1) + "═══╝"
  end

  def render_chromatic(dark_square_color, light_square_color)

    print "   "
    BOARD_SIZE.times { |col| print " #{(col+97).chr} "}

    @grid.each_with_index do |row, row_num|
      if row_num % 2 == 0
        draw_row_cells(dark_square_color, light_square_color, row, row_num)
      else
        draw_row_cells(light_square_color, dark_square_color, row, row_num)
      end
    end
    nil
  end

  def draw_row_cells(color1, color2, row, row_num)
    puts
    row.size.times do |space|
      print " #{row_num+1} " if space == 0
      if space % 2 == 0
        print " #{row[space]} ".colorize(:background => color1)
      else
        print " #{row[space]} ".colorize(:background => color2)
      end
    end
    nil
  end

  def inspect
  end

  private

  def create_grid
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, EmptySpace) }
  end

  def setup_board
    place_pieces(:red)
    place_pieces(:black)
  end

  def place_pieces(color)
    NUMBER_OF_ROWS_COLOR.times do |row|
      row += 5 if color == :red
      BOARD_SIZE.times do |col|
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
