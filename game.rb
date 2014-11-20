require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  COLOR_SCHEMES = {"classic" => [:red, :light_white],
    "eighties" => [:magenta, :light_cyan],
    "christmas" => [:light_red, :light_green],
    "pastel" => [:light_yellow, :light_magenta]}

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

      puts "\n\n#{current_player.color.capitalize}'s turn to play. "
      moving_piece = current_player.moving_piece
      if moving_piece == :save
        moving_piece = nil
        save_game
      end
      if moving_piece == :exit
        moving_piece = nil
        abort
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
    preferences = File.readlines("preferences.txt")

    color_scheme = COLOR_SCHEMES[preferences[0]]
    system("clear")
    @board.render_chromatic(color_scheme[0], color_scheme[1])
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
  unless File.exist?("preferences.txt")
    file = File.open("preferences.txt", "w")
    file.write("classic")
    file.close
  end

  loop do

    system("clear")
    puts "Welcome To".center(45)
    puts "CHECKERS".center(45).colorize(:red).bold
    puts "The Game of Luck, Skill, and Prosperity".center(45).blink
    puts "\n\n\n Would you like to: "
    puts " 1) Play a New Game"
    puts " 2) Load a Previous Game"
    puts " 3) Delete Saved Games"
    puts " 4) Color Preferences"
    puts " 5) Instructions"
    print "\n Input the number of your choice: "
    input = gets.chomp.to_i

    if input == 1
      Game.new.run_game

    elsif input == 2
      system("clear")
      puts " Load Game \n".underline
      puts " 0) Back to Main Menu"
      Dir["./saves/*.sav"].each.with_index { |file, index| puts " #{index+1}) #{file}" }
      print "\n Input the number of the game you would like to load: "
      input = gets.chomp.to_i - 1
      next if input == -1
      Game.load_game(Dir["./saves/*.sav"][input]).run_game

    elsif input == 3
      system("clear")
      puts " Delete Saved Games \n".underline
      puts " 0) Back to Main Menu"
      Dir["./saves/*.sav"].each.with_index { |file, index| puts " #{index+1}) #{file}" }
      print "\n Input the number of the game you would like to delete: "
      input = gets.chomp.to_i - 1
      next if input == -1
      File.delete(Dir["./saves/*.sav"][input])

    elsif input == 4
      system("clear")
      puts " Color Preferences \n".underline
      puts " 0) Back to Main Menu"
      puts " 1) Classic"
      puts " 2) Eighties"
      puts " 3) Christmas"
      puts " 4) Pastels"
      print "\n Input the number of the color scheme you would like: "
      input = gets.chomp.to_i
      next if input == 0
      preferences = File.open("preferences.txt", "w")
      case input
      when 1
        preferences.write("classic")
      when 2
        preferences.write("eighties")
      when 3
        preferences.write("christmas")
      when 4
        preferences.write("pastel")
      end
      preferences.close
    elsif input == 5 ###change sleep to enter
      system("clear")
      puts "Welcome to checkers!"
      puts "Press enter for each instruction."
      gets
      puts "When choosing a checker, enter a letter-number combination."
      puts "For example: a5."
      gets
      puts "When moving a checker, write the sequences moves your piece will move."
      puts "For example: a5 b7."
      gets
      puts "To save your game, type save at the beginning of any turn."
      gets
      puts "To exit a game, type exit at the beginning of any turn."
      puts "Have fun!"
      gets
      next
    else
      next
    end


  end
end
