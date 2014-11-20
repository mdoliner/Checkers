require_relative 'piece'
require_relative 'empty_space'

class InvalidMoveError < IOError
end

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

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def perform_slide(start_pos, end_pos)
    piece = self[start_pos]
    raise InvalidMoveError.new "There is no piece there" if piece.nil?
    if piece.slide_moves.include?(end_pos) && self[end_pos].nil?
      self[start_pos], self[end_pos] = EmptySpace, piece
      piece.pos = end_pos
    else
      raise InvalidMoveError.ewn "You can't move there."
    end

    nil
  end

  def perform_jump(start_pos, end_pos)
    piece = self[start_pos]
    raise InvalidMoveError.new "There is no piece there" if piece.nil?
    middle_pos = middle_pos(start_pos, end_pos)
    if piece.jump_moves.include?(end_pos) &&
       self[end_pos].nil? &&
       self[middle_pos].is_enemy?(piece.color)
      self[start_pos], self[middle_pos] = EmptySpace, EmptySpace
      self[end_pos] = piece
      piece.pos = end_pos
    else
      raise InvalidMoveError.ewn "You can't move there."
    end

    nil
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

  def middle_pos(pos1, pos2)
    [(pos1[0] + pos2[0]) / 2, (pos1[1] + pos2[1]) / 2]
  end

end
