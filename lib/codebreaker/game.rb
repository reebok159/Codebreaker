module Codebreaker
  class Game
    TOTAL_ATTEMPTS = 15
    attr_accessor :attempts, :matches

    def initialize
      @secret_code = ''
    end

    def start
      @attempts = TOTAL_ATTEMPTS
      @secret_code = (1..4).to_a.map {rand(1...6)}.join
    end

    def make_guess(guess)
      @matches = ''
      get_matches(guess)
      @attempts -= 1
      return :lose if attempts == 0 && @matches != '++++'
      @matches
    end

    def get_matches(guess)
      cleared_guess = get_exact_matches(guess.split(''))
      return unless cleared_guess.size
      get_include_matches(cleared_guess)
    end

    def get_hint
      @secret_code[rand(0..3)]
    end

    def get_used_attempts
      TOTAL_ATTEMPTS - @attempts
    end

    private

    def get_exact_matches(guess)
      cleared_guess = guess.zip(@secret_code.split('')).select{ |item| item[0] != item[1] }
      @matches = '+' * (4 - cleared_guess.size)
      cleared_guess
    end

    def get_include_matches(guess)
      secret_code = guess.map {|item| item[1] }
      start_size = secret_code.size
      code = guess.map {|item| item[0] }
      code.each do |item|
        if k = secret_code.find_index(item)
          secret_code.delete_at(k)
        end
      end
      @matches <<= '-' * (start_size - secret_code.size)
    end

  end
end
