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
    @players = [HumanPlayer.new(@board, :red),
       HumanPlayer.new(@board, :black)]
  end

  def run_game
    until over?
      auto_save_game

      current_player = @players[@turn % 2]
      turn(current_player)
      @turn += 1
    end
  end

  def turn(current_player)
    begin
      draw_board
      moving_piece = nil

      puts "\n#{current_player.color.capitalize}'s turn to play."
      moving_piece = current_player.moving_piece
      moving_piece.start_moving

      draw_board
      current_player.perform_move_sequence(moving_piece)
      @board.promote_king(current_player.color)

    rescue InvalidMoveError => e
      puts e.message
      sleep(2)
      retry
    rescue ArgumentError
      puts "That is not a valid move."
      sleep(2)
      retry
    ensure
      moving_piece.stop_moving if moving_piece
    end
  end

  private

  def draw_board
    system("clear")
    @board.render_chromatic
  end

  def over?
    black_won? || red_won?
  end

  def black_won?
    @board.pieces_of_color(:red).empty?
  end

  def red_won?
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
