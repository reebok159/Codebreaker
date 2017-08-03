module UserConsole
  class UI
    attr_accessor :name, :game, :file_path


    def initialize
      @game = Codebreaker::Game.new
      @file_path = "./results.txt"
    end

    def show_ui
      ask_name
      show_header
      show_start_menu
    end

    def ask_name
      puts "Enter your name:"
      @name = "stranger"
      entered_name = gets.chomp
      @name = entered_name if entered_name.length > 0
      puts "Hello, #{name}"
    end

    def show_header
      puts "=============================================="
      puts "=============================================="
      puts "================CODEBREAKER==================="
      puts "=============================================="
      puts "=============================================="
      puts "== Select action:"
      puts "1. Start game"
      puts "2. Show results"
      puts "3. Exit"
      puts "=============================================="
    end

    def show_start_menu(action = gets.chomp)
      show_header

      case action
      when "1"
        start_game
      when "2"
        show_last_results
      when "3"
        bye
      else
        show_start_menu
      end
      return
    end

    def bye
      puts "Good bye!"
    end

    def show_win
      puts "You win!!"
      save_result_to_file("#{@name} won with #{@game.get_used_attempts} attempts")
    end

    def show_lose
      puts "You lose!! Secret code was #{@game.get_secret_code}"
      save_result_to_file("#{@name} lost with code #{@game.get_secret_code}")
    end

    def show_result(result)
      return show_win if result == '++++'
      return show_lose if result == :lose
      result = 'NO MATCHES' if result == ''
      puts "----------"
      puts "  Result: #{result}"
      puts "  Attempts: #{@game.attempts}"
    end

    def rules
      "You must enter 4-digit number, all digits must be from 1 to 6."
    end

    def get_guess
      puts "- Enter your guess, /q to exit or /h to use hint:"
      guess = gets.chomp
      return guess
    end

    def get_action(guess)
      return "exit" if guess == "/q"
      if guess == "/h" or guess.length != 4
        if guess == "/h"
          puts show_hint
        else
          puts "try again"
        end
        return "next"
      end
    end

    def start_game
      puts rules
      @game.start
      loop do
        guess = get_guess
        action = get_action(guess)
        return if action == "exit"
        next if action == "next"
        result = @game.make_guess(guess)
        show_result(result)
        break if game_over?(result)
      end
    end

    def game_over?(result)
      return true if result == '++++' or result == :lose
      return false
    end

    def show_hint
      "Secret code contains digit #{@game.get_hint}"
    end

    def show_last_results
      begin
        file = File.open(@file_path, 'r') { |file| puts file.read }
      rescue Exception => e
        puts "Couldn't show results"
      end
    end


    def save_result_to_file(line)
      begin
        file = File.open(@file_path, 'a') { |file| file.puts line+"\n" }
      rescue Exception => e
        puts "Couldn't save results"
      end
    end
  end
end
