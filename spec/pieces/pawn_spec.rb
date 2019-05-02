require 'board/board'
require 'board/setup_board'
require 'board/setup_display'
require 'pieces/pawn'

RSpec.describe Pawn do
  describe 'movements' do
    let(:board) { Board.new }
    let(:game) { SetupBoard.new(board) }
    let(:display) { SetupDisplay.new(board) }
    let(:white_pawn) { game.white_pawn }
    let(:black_pawn) { game.black_pawn }

    before(:each) do
      game.setup_board
      display.setup_display
    end

    describe '#pawn_diagonal' do
      before(:each) do
        8.times do |space|
          black_pawn.move(board, [6, space], [5, space])
          black_pawn.move(board, [5, space], [4, space])
          black_pawn.move(board, [4, space], [3, space])
          black_pawn.move(board, [3, space], [2, space])
        end
      end

      it 'white pawn takes black pawn (+, +)' do
        white_pawn.take_piece(board, [1, 0], [2, 1])
        expect(board.find([2, 1]).piece).to eq(white_pawn)
      end

      it 'white pawn takes black pawn (+, -)' do
        white_pawn.take_piece(board, [1, 1], [2, 0])
        expect(board.find([2, 0]).piece).to eq(white_pawn)
      end

      it 'black pawn takes white pawn (-, -)' do
        black_pawn.take_piece(board, [2, 1], [1, 0])
        expect(board.find([1, 0]).piece).to eq(black_pawn)
      end

      it 'black pawn takes white pawn (-, +)' do
        black_pawn.take_piece(board, [2, 1], [1, 2])
        expect(board.find([1, 2]).piece).to eq(black_pawn)
      end
    end

    describe '#pawn_two_moves_forward' do
      context 'should be able to move 2 spaces forward when path is free' do
        it 'white pawn should move foward two spaces' do
          expect(board.find([3, 0]).piece).to eq(nil)
          white_pawn.move(board, [1, 0], [3, 0])
          expect(board.find([3, 0]).piece).to eq(white_pawn)
        end

        it 'black pawn should move foward two spaces' do
          expect(board.find([4, 0]).piece).to eq(nil)
          black_pawn.move(board, [6, 0], [4, 0])
          expect(board.find([4, 0]).piece).to eq(black_pawn)
        end
      end
    end
  end
end
