require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  def self.load_game(filename)
    load_game = YAML::load_file(filename)
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

      puts "\n#{current_player.color.capitalize}'s turn to play. "
      moving_piece = current_player.moving_piece
      if moving_piece == :save
        moving_piece = nil
        save_game
      end
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

  def save_game
    puts "What is the name of your saved game? "
    filename = "./saves/" + gets.chomp + ".sav"
    File.write(filename, YAML.dump(self))
    abort
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
  Dir.mkdir("./saves") unless Dir.exist?("./saves")
  loop do

    system("clear")
    puts "Welcome To".center(45)
    puts "CHECKERS".center(45).colorize(:red).bold
    puts "The Game of Luck, Skill, and Prosperity".center(45).blink
    puts "\n\n\n Would you like to: "
    puts " 1) Play a New Game"
    puts " 2) Load a Previous Game"
    puts " 3) Delete Saved Games"
    print "\n Input the number of your choice: "
    input = gets.chomp.to_i

    if input == 1
      Game.new.run_game

    elsif input == 2
      system("clear")
      puts " Load Game".underline
      puts " 0) Back to Main Menu"
      Dir["./saves/*.sav"].each.with_index { |file, index| puts " #{index+1}) #{file}" }
      print " Input the number of the game you would like to load: "
      input = gets.chomp.to_i - 1
      next if input == -1
      Game.load_game(Dir["./saves/*.sav"][input]).run_game

    elsif input == 3
      system("clear")
      puts " Delete Saved Games".underline
      puts " 0) Back to Main Menu"
      Dir["./saves/*.sav"].each.with_index { |file, index| puts " #{index+1}) #{file}" }
      print " Input the number of the game you would like to delete: "
      input = gets.chomp.to_i - 1
      next if input == -1
      File.delete(Dir["./saves/*.sav"][input])
    end

  end
end
