require "./lib/connect_four.rb"

describe ConnectFour do
  subject(:game) { described_class.new }

  describe "#player_name_input" do
    context "when input string is empty, and then is valid" do
      before do
        allow(game).to receive(:gets).and_return("\n", "Bob\n")
      end

      it "puts there is input is empty" do
        expect(game).to receive(:puts).at_least(:once)
        game.player_name_input
      end

      it "gets twice (wrong and not) input" do
        expect(game).to receive(:gets).twice
        game.player_name_input
      end

      it "return valid" do
        expect(game.player_name_input).to eq("Bob")
      end
    end
  end

  describe "#board_size_input" do
    context "when input is invalid, and then is valid" do
      before do
        allow(game).to receive(:gets).and_return("aksdasd\n", "7\n")
      end

      it "puts there is wrong input once" do
        expect(game).to receive(:puts).at_least(:once)
        game.board_size_input
      end

      it "gets on wrong and valid inputs" do
        expect(game).to receive(:gets).twice
        game.board_size_input
      end

      it "return valid input" do
        expect(game.board_size_input).to be 7
      end
    end

    context "when input is less then 4" do
      before do
        allow(game).to receive(:gets).and_return("3\n")
      end

      it "puts there is wrong input" do
        expect(game).to receive(:puts).at_least(:once)
        game.board_size_input
      end
    end
  end

  describe "#introdution" do
    before do
      allow(game).to receive(:player_name_input).and_return("Bob", "Anna")
      allow(game).to receive(:board_size_input).and_return(7, 6)
      allow(game).to receive(:print_game_status)
    end

    it "calls #player_name_input twice" do
      expect(game).to receive(:player_name_input).twice
      game.introdution
    end

    it "set player names" do
      expect { game.introdution }.to change { game.instance_variable_gets(:@player_names) }.to(["Bob", "Anna"])
    end

    it "calls #board_size_input twice" do
      expect(game).to receive(:board_size_input).twice
      game.introdution
    end

    it "creates board array with inputed length" do
      expect { game.introdution }.to change {
                                       game.instance_variable_gets(:@board).length
                                     }.to(6).and change {
                                       game.instance_variable_gets(:@board)[0].length
                                     }.to(7)
    end

    it "calls #print_game_status once" do
      expect(game).to receive(:print_game_status).once
      game.introdution
    end
  end

  describe "#player_turn_input" do
    context "when input empty string" do
      before do
        allow(game).to receive(:gets).and_return("\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end

    context "when input hasn't space" do
      before do
        allow(game).to receive(:gets).and_return("1\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end
    context "when input has space more then 1" do
      before do
        allow(game).to receive(:gets).and_return("1 1 2\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end
    context "when input x and y coordinate not integer" do
      before do
        allow(game).to receive(:gets).and_return("a5 b10\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end
    context "when input x coordinate is integer, but y not" do
      before do
        allow(game).to receive(:gets).and_return("5 b10\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end
    context "when input y coordinate is integer, but x not" do
      before do
        allow(game).to receive(:gets).and_return("a5 10\n")
      end

      it "puts wrong input" do
        expect(game).to receive(:puts).to be_include("wrong input")
        game.player_turn_input
      end
    end
    context "when x coordinate out of board" do
      before do
        allow(game).to receive(:gets).and_return("10 5\n")
      end

      it "puts coordinate out of board" do
        expect(game).to receive(:puts).to be_include("coordinate out of board")
        game.player_turn_input
      end
    end
    context "when y coordinate out of board" do
      before do
        allow(game).to receive(:gets).and_return("5 10\n")
      end

      it "puts coordinate out of board" do
        expect(game).to receive(:puts).to be_include("coordinate out of board")
        game.player_turn_input
      end
    end
    context "when x and y coordinate out of board" do
      before do
        allow(game).to receive(:gets).and_return("15 10\n")
      end

      it "puts coordinate out of board" do
        expect(game).to receive(:puts).to be_include("coordinate out of board")
        game.player_turn_input
      end
    end

    context "when the board cell with this coordinate is already occupied" do
      # TODO
    #   before do
    #     allow(game).to receive(:gets).and_return("0 0\n")
    #     allow()
    #   end
    end
  end

  describe "#player_turn" do
  end

  describe "#game_end?" do
  end
end
