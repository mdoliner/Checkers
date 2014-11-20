require_relative 'board'
require_relative 'human_player'

class Game

  def initialize
    @board = Board.new
    @turn = 1
    @players = [HumanPlayer.new(@board, :white),
       HumanPlayer.new(@board, :black)]
  end

  def run_game
    until over?
      draw_board
      current_player = @players[@turn % 2]
      puts "\n#{current_player.color}'s turn to play."
      current_player.perform_move
      @turn += 1
    end
  end

  private

  def draw_board
    @board.render
  end

  def over?
    black_won? || white_won?
  end

  def black_won?
    @board.pieces_of_color(:white).empty?
  end

  def white_won?
    @board.pieces_of_color(:black).empty?
  end


end
