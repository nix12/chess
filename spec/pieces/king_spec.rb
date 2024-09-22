require 'board/board'
require 'board/game'
require 'pieces/king'

RSpec.describe King do
  let(:board) { Board.new }
  let(:game) { Game.new(board) }
  let(:white_king) { game.white_king }
  let(:black_queen) { game.black_queen }
  let(:white_pawn) { game.white_pawn }
  let(:black_pawn) { game.black_pawn }
  let(:white_king_location) { [1, 5] }

  before(:each) do
    game.setup_board
    game.compose_display

    8.times do |space|
      white_pawn.remove_piece(board, [2, space], [3, space])
      white_pawn.moves.clear
      black_pawn.remove_piece(board, [7, space], [6, space])
      black_pawn.moves.clear
    end
  end

  describe 'movements' do
    describe '#prevent_move_into_check' do
      before(:each) do
        game.create_black_pawns
      end

      it 'should call create_moves and filter moves' do
        allow(white_king).to receive(:create_moves).with(white_king_location)
        white_king.instance_variable_set(
          :@moves,
          [[2, 4], [2, 5], [2, 6]]
        )

        expect(white_king.prevent_move_into_check(board, white_king_location)).to eq(
          [[2, 4], [2, 5], [2, 6]]
        )
      end
    end
  end

  describe 'directional checks' do
    describe '#top' do
      it 'should return false if piece not in path' do
        expect(white_king.send(:top, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [7, 5])
        expect(white_king.send(:top, board, white_king_location)).to eq(true)
      end
    end

    describe '#upper_right' do
      it 'shoul.0d return false if piece not in path' do
        expect(white_king.send(:upper_right, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [7, 5])
        black_queen.move(board, [7, 5], [2, 5])
        black_queen.move(board, [2, 5], [2, 6])
        expect(white_king.send(:upper_right, board, white_king_location)).to eq(true)
      end
    end

    describe '#right' do
      let(:white_king_location) { [2, 4] }

      before(:each) do
        white_king.move(board, [1, 5], [2, 5])
      end

      it 'should return false if piece not in path' do
        expect(white_king.send(:right, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [7, 5])
        black_queen.move(board, [7, 5], [2, 5])
        black_queen.move(board, [2, 5], [2, 6])
        expect(white_king.send(:right, board, white_king_location)).to eq(true)
      end
    end


    describe '#bottom_right' do
      let(:white_king_location) { [3, 5] }

      before(:each) do
        white_king.move(board, [1, 5], [2, 5])
        white_king.move(board, [2, 5], [3, 5])
      end

      it 'should return false if piece not in path' do
        expect(white_king.send(:bottom_right, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [7, 5])
        black_queen.move(board, [7, 5], [2, 5])
        black_queen.move(board, [2, 5], [2, 6])
        expect(white_king.send(:bottom_right, board, white_king_location)).to eq(true)
      end
    end

    describe '#bottom' do
      let(:white_king_location) { [3, 5] }

      before(:each) do
        white_king.move(board, [1, 5], [2, 5])
        white_king.move(board, [2, 5], [3, 5])
      end

      it 'should return false if piece not in path' do
        expect(white_king.send(:bottom, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [7, 5])
        black_queen.move(board, [7, 5], [2, 5])
        expect(white_king.send(:bottom, board, white_king_location)).to eq(true)
      end
    end

    describe '#bottom_left' do
      let(:white_king_location) { [3, 5] }

      before(:each) do
        white_king.move(board, [2, 6], [3, 6])
        white_king.move(board, [3, 6], [4, 6])
      end

      it 'should return false if piece not in path' do
        expect(white_king.send(:bottom_left, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [2, 4])
        expect(white_king.send(:bottom_left, board, white_king_location)).to eq(true)
      end
    end

    describe '#left' do
      let(:white_king_location) { [2, 5] }

      before(:each) do
        white_king.move(board, [1, 5], [2, 5])
      end

      it 'should return false if piece not in path' do
        expect(white_king.send(:left, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [2, 4])
        expect(white_king.send(:left, board, white_king_location)).to eq(true)
      end
    end

    describe '#upper_left' do
      let(:white_king_location) { [1, 5] }

      it 'should return false if piece not in path' do
        expect(white_king.send(:upper_left, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_queen.move(board, [8, 4], [2, 4])
        expect(white_king.send(:upper_left, board, white_king_location)).to eq(true)
      end
    end

    describe '#knight_check' do
      let(:white_king_location) { [1, 5] }
      let(:black_knight) { game.black_knight }

      it 'should return false if piece not in path' do
        expect(white_king.send(:knight_check, board, white_king_location)).to eq(false)
      end

      it 'should return true if piece in path' do
        black_knight.move(board, [8, 2], [7, 4])
        black_knight.move(board, [7, 4], [5, 3])
        black_knight.move(board, [5, 3], [3, 4])
        expect(white_king.send(:knight_check, board, white_king_location)).to eq(true)
      end
    end
  end

  describe 'checkmate functionality' do
    describe '#checkmate?' do
      it 'should return false if no checkmate is available' do
        allow(white_king).to receive(:create_moves).with(white_king_location)
        white_king.instance_variable_set(
          :@moves,
          [[2, 4], [2, 5], [2, 6]]
        )

        expect(white_king.checkmate?(board, white_king_location)).to eq(false)
      end

      it 'should return true if there is checkmate' do
        black_queen.move(board, [8, 4], [7, 5])
        black_queen.move(board, [7, 5], [2, 5])

        allow(white_king).to receive(:create_moves).with(white_king_location)
        white_king.instance_variable_set(
          :@moves,
          [[2, 4], [2, 5], [2, 6]]
        )

        expect(white_king.checkmate?(board, white_king_location)).to eq(true)
      end
    end
  end
end
