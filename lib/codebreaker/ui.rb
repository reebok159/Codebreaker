module UserConsole
  class UI
    attr_accessor :name, :game

    def initialize
      puts "Enter your name:"
      @name = "stranger"
      entered_name = gets.chomp
      @name = entered_name if entered_name.length > 0
      puts "Hello, #{name}"
      show_start_menu
    end


    def show_start_menu
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

      action = gets.chomp

      if action == "1"
        start_game
        return
      elsif action == "2"
        show_last_results
      elsif action == "3"
         puts "Good bye!"
         return
      end

      show_start_menu
    end

    def start_game
      puts "=============================================="
      puts "You must enter 4-digit number, all digits must be from 1 to 6."
      @game = Codebreaker::Game.new

      loop do
        puts "- Enter your guess, /q to exit or /h to use hint:"
        guess = gets.chomp

        return if guess == "/q"
        if guess == "/h"
          show_hint
          next
        end
        if guess.length != 4
          puts "try again"
          next
        end

        result = @game.make_guess(guess)
        if result == :win
          puts "You win !!"
          save_result_to_file("#{@name} won with #{@game.get_used_attempts} attempts")
          break
        end
        if result == :lose
          puts "You lose !!"
          break
        end
        puts "----------"
        puts "  Result: #{result}"
        puts "  Attempts: #{@game.attempts}"
      end
    end

    def show_hint
      puts "Secret code contains digit #{@game.get_hint}"
    end

    def show_last_results
      begin
        file = File.open("../results.txt", 'r') { |file| puts file.read }
      rescue Exception => e
        puts "Couldn't show results\n#{e}"
      end
    end


    def save_result_to_file(line)
      begin
        file = File.open("../results.txt", 'a') { |file| file.puts line+"\n" }
      rescue Exception => e
        puts "Couldn't save results\n#{e}"
      end
    end
  end
end
