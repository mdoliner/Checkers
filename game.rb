require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  def self.load_game
    load_game = YAML::load_file("checkers_auto.yml")
    File.delete("checkers_auto.yml")
    load_game
  end

  def initialize
    @board = Board.new
    @turn = 1
    @players = [HumanPlayer.new(@board, :white),
       HumanPlayer.new(@board, :black)]
  end

  def run_game
    until over?
      auto_save_game
      system("clear")
      draw_board
      current_player = @players[@turn % 2]
      puts "\n#{current_player.color.capitalize}'s turn to play."
      current_player.perform_move
      @board.promote_king(current_player.color)
      @turn += 1
    end
  end

  private

  def draw_board
    @board.render_chromatic
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

  def auto_save_game
    File.write("checkers_auto.yml", YAML.dump(self))
  end

end

if __FILE__ == $PROGRAM_NAME
  if File.exist?("checkers_auto.yml")
    puts "Would you like to load your previous game? (y/n) "
    if gets.chomp.downcase == "y"
      Game.load_game.run_game
    else
      Game.new.run_game
    end
  else
    Game.new.run_game
  end

end
