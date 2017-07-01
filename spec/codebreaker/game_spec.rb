require 'spec_helper'
require_relative './codebreaker_cases.rb'

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new }


    describe '#start' do
    before do
      game.start
    end

      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it 'start attempts is 15' do
        expect(game.instance_variable_get(:@attempts)).to eq(10)
      end
    end

    describe '#make_guess' do
      before do
        game.start
      end

      it 'must be 14 attempts after trying' do
        game.make_guess("4432")
        expect(game.instance_variable_get(:@attempts)).to eq(9)
      end

      it 'must return :lose' do
        game.instance_variable_set(:@attempts, 1)
        game.instance_variable_set(:@secret_code, "3123")
        expect(game.make_guess("5555")).to eq(:lose)
      end

      it 'mustn\'t return ++++' do
        game.instance_variable_set(:@attempts, 1)
        game.instance_variable_set(:@secret_code, "3123")
        expect(game.make_guess("5555")).not_to eq("++++")
      end

      it 'must return ++++' do
        game.instance_variable_set(:@attempts, 1)
        game.instance_variable_set(:@secret_code, "3123")
        expect(game.make_guess("3123")).to eq("++++")
      end

      it 'must return ++--' do
        game.instance_variable_set(:@secret_code, "3325")
        expect(game.make_guess("3352")).to eq("++--")
      end

      it 'must return nothing' do
        game.instance_variable_set(:@secret_code, "3325")
        expect(game.make_guess("1111")).to eq("")
      end

      data = Codebreaker_cases::data;
      data.each do |item|

      it "code #{item[0]} and number #{item[1]}, result: #{item[2]}" do
        game.instance_variable_set(:@attempts, 3)
        game.instance_variable_set(:@secret_code, item[0])
        expect(game.make_guess(item[1])).to eq(item[2])
        end
      end
    end


    describe '#other_methods' do

      before do
        game.start
      end

      it 'test get_hint - must give correct hint' do
        game.instance_variable_set(:@secret_code, "3123")
        expect("3123".split('').find_index(game.get_hint)).not_to be_nil
      end

      it 'test get_used_attempts - must give correct value' do
        game.instance_variable_set(:@secret_code, "3325")
        game.make_guess("4432")
        game.make_guess("4432")
        expect(game.get_used_attempts).to eq(2)
      end

    end

    describe '#make_guess 2' do
      it 'must return nil if game isn\'t started' do
        expect(game.make_guess("5541")).to eq(nil)
      end
    end

  end
end

