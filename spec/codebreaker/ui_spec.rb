require 'spec_helper'

module UserConsole
  RSpec.describe UI do
    subject(:ui){ UI.new }

    describe '#show_ui' do
      before do
        allow(ui).to receive(:show_header) #stub
        allow(ui).to receive(:ask_name) #stub
        allow(ui).to receive(:show_start_menu) #stub
      end

      it 'ask name' do
        expect(ui).to receive(:ask_name)
        ui.show_ui
      end

      it 'show start menu' do
        expect(ui).to receive(:show_start_menu)
        ui.show_ui
      end
    end


    describe '#show_start_menu' do
      before do
        allow(ui).to receive(:show_header) #stub
      end

      it "calls 'start_game' when action equal 1" do
        allow(ui).to receive(:start_game)
        expect(ui).to receive(:start_game)
        ui.show_start_menu("1")
      end

      it "calls 'show_last_results' when action equal 2" do
        allow(ui).to receive(:show_last_results)
        expect(ui).to receive(:show_last_results)
        ui.show_start_menu("2")
      end

      it "calls 'bye' when action equal 3" do
        allow(ui).to receive(:bye)
        expect(ui).to receive(:bye)
        ui.show_start_menu("3")
      end
    end

    describe '#show_result' do
      it "calls 'show_win' if result equal ++++" do
        allow(ui).to receive(:show_win)
        expect(ui).to receive(:show_win)
        ui.show_result("++++")
      end
      it "calls 'show_lose' if result equal :lose" do
        allow(ui).to receive(:show_lose)
        expect(ui).to receive(:show_lose)
        ui.show_result(:lose)
      end
    end

    describe '.show_hint' do
      it "return phrase with hint" do
        ui.game.start
        phrase = "Secret code contains digit"
        expect(ui.show_hint).to start_with(phrase)
      end

      it "calls 'get_hint' in game variable" do
        expect(ui.game).to receive(:get_hint)
        ui.show_hint
      end
    end

    describe '#save_result_to_file' do
      it "write result to file" do
        file_path = ui.file_path
        ui.save_result_to_file("Eugene won with 2 attempts")
        expect(File.zero?(file_path)).to be(false)
        File.delete(file_path)
      end
    end

  end
end
