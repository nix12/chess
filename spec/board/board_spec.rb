require 'board/board'
require 'board/game'

RSpec.describe Board do
  describe 'new board' do
    let(:board) { Board.new }

    it "should be an instance of 'Board'" do
      expect(board).to be_an_instance_of(described_class)
    end

    it 'should respond to board and display' do
      expect(board).to respond_to(:board)
      expect(board).to respond_to(:display)
    end

    it 'should build the board with 64 spaces' do
      board.build_board
      expect(board.board.length).to eq(64)
    end

    describe '#find' do
      let(:board) { Board.new }

      before do
        board.build_board
      end

      it 'should find node location [5, 5]' do
        expect(board.find([5, 5]).location).to eq([5, 5])
      end

      it 'should return nil if node does not exist' do
        expect(board.find([-1, 9])).to eq(nil)
      end
    end

    describe '#find_by_piece' do
      let(:board) { Board.new }
      let(:game) { Game.new(board) }

      it 'should find king pieces' do
        game.setup_board
        expect(board.find_by_piece('king')).to eq([[1, 5], [8, 5]])
      end
    end
  end
end
