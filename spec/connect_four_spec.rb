require "./lib/connect_four.rb"

describe ConnectFour do
  subject(:game) { described_class.new }

  describe "#initialize" do
    # Don't need testing because only init variables
    it "defined" do
      expect(game).to respond_to(:initialize)
    end
  end

  describe "#print_game_status" do
    # Don't need testing because puts only
    it "defined" do
      expect(game).to respond_to(:print_game_status)
    end
  end

  describe "#print_game_result" do
    # Don't need testing because puts only
    it "defined" do
      expect(game).to respond_to(:print_game_result)
    end
  end

  describe "#play_game" do
    # Don't need testing because contains only testing methods
    it "defined" do
      expect(game).to respond_to(:play_game)
    end
  end

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
    context "when coordinate is valid" do
      before do
        allow(game).to receive(:gets).and_return("0 0\n")
      end

      it "return array of x and y coordinate" do
        expect(game.player_turn_input).to eql([0, 0])
      end
    end
  end

  describe "#player_turn" do
    context "when the board cell with this coordinate is already occupied, then is empty" do
      before do
        let(:current_player) { 0 }
        allow(game).to receive(:player_turn_input).and_return([0, 0], [1, 1])
        game.instance_variable_set(:@board, [[1, nil], [nil, nil]])
        game.instance_variable_set(:@current_player, current_player)
      end

      it "puts coordinate is already occupied" do
        expect(game).to receive(:puts).at_least(:twice)
        game.player_turn
      end

      it "call player_turn_input again" do
        expect(game).to receive(:player_turn_input).twice
        game.player_turn
      end

      it "update board cell to current player" do
        expect { game.player_turn }.to change {
          game.instace_variable_get(:@board)[0][0]
        }.from(nil).to(current_player)
      end

      it "change current player" do
        expect { game.player_turn }.to change {
          game.instace_variable_get(:@current_player)
        }.from(current_player).to(1)
      end
    end
  end

  describe "#count_elements_in_row_from_point" do
    context "when board is empty" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil],
        ])
      end
      it "return 0" do
        expect(game.count_elements_in_row_from_point(point)).to be_zero
      end
    end
    context "when board is full, besides center, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [0, 0, 0],
          [0, nil, 0],
          [0, 0, 0],
        ])
      end
      it "return 0" do
        expect(game.count_elements_in_row_from_point(point)).to be 0
      end
    end
    context "when board is empty, besides center, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [nil, nil, nil],
          [nil, 0, nil],
          [nil, nil, nil],
        ])
      end
      it "return 1" do
        expect(game.count_elements_in_row_from_point(point)).to be 1
      end
    end
    context "when board has horizontal line across center with length 3, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [nil, nil, nil],
          [0, 0, 0],
          [nil, nil, nil],
        ])
      end
      it "return 3" do
        expect(game.count_elements_in_row_from_point(point)).to be 3
      end
    end
    context "when board has vertical line across center with length 3, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [nil, 0, nil],
          [nil, 0, nil],
          [nil, 0, nil],
        ])
      end
      it "return 3" do
        expect(game.count_elements_in_row_from_point(point)).to be 3
      end
    end
    context "when board has left-right diagonal line across center with length 3, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [0, nil, nil],
          [nil, 0, nil],
          [nil, nil, 0],
        ])
      end
      it "return 3" do
        expect(game.count_elements_in_row_from_point(point)).to be 3
      end
    end
    context "when board has right-left diagonal line across center with length 3, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [nil, nil, 0],
          [nil, 0, nil],
          [0, nil, nil],
        ])
      end
      it "return 3" do
        expect(game.count_elements_in_row_from_point(point)).to be 3
      end
    end
    context "when board full by player 1 besides center by another player, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ])
      end
      it "return 1" do
        expect(game.count_elements_in_row_from_point(point)).to be 1
      end
    end
    context "when board has horizontal line across center with length 5, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [0, 0, 0, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 0, 0, 0],
        ])
      end
      it "return 5" do
        expect(game.count_elements_in_row_from_point(point)).to be 5
      end
    end
    context "when board has 2 lines across center with length 5 and 3 respectively, point center" do
      before do
        let(:point) { [1, 1] }
        game.instance_variable_set(:@board, [
          [0, 0, 1, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 1, 0, 0],
        ])
      end
      it "return max is 5" do
        expect(game.count_elements_in_row_from_point(point)).to be 5
      end
    end
  end

  describe "#game_end?" do
    context "when board has win line length from first point" do
      before do
        let(:winner) { 0 }
        allow(game).to receive(:count_elements_in_row_from_point).with(0, 0).and_return(4)
        game.instace_variable_set(:@board, [[winner]])
      end

      it "calls #count_elements_in_row_from_point once" do
        expect(game).to receive(:count_elements_in_row_from_point).once
        game.game_end?
      end

      it "return true" do
        expect(game.game_end?).to be true
      end

      it "set winner" do
        expect { game.game_end? }.to change { game.instance_variable_get(:@winner) }.from(nil).to(winner)
      end
    end
    context "when board is empty 3x3" do
      before do
        allow(game).to receive(:count_elements_in_row_from_point).and_return(0)
        game.instace_variable_set(:@board, Array.new(3) { Array.new(3, nil) })
      end

      it "calls 9 #count_elements_in_row_from_point" do
        expect(game).to receive(:count_elements_in_row_from_point).exactly(9).times
        game.game_end?
      end

      it "return false" do
        expect(game.game_end?).to be false
      end

      it "don't change winner" do
        expect { game.game_end? }.to_not change { game.instance_variable_get(:@winner) }
      end
    end
    context "when board is full 3x3 (without win line)" do
      before do
        allow(game).to receive(:count_elements_in_row_from_point).and_return(0)
        game.instace_variable_set(:@board, Array.new(3) { Array.new(3, 0) })
      end

      it "calls 9 #count_elements_in_row_from_point" do
        expect(game).to receive(:count_elements_in_row_from_point).exactly(9).times
        game.game_end?
      end

      it "return true" do
        expect(game.game_end?).to be true
      end

      it "don't change winner" do
        expect { game.game_end? }.to_not change { game.instance_variable_get(:@winner) }
      end
    end
  end
end
