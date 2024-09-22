require 'board/game'

RSpec.describe Game do
  describe 'game of board with pieces' do
    let(:board) { Board.new }
    let(:game) { Game.new(board) }

    before { board.build_board }

    describe '#setup_board' do
      it "calls board's build_board method" do
        allow(board).to receive(:build_board)
        game.setup_board
      end

      it 'calls build_white_side method' do
        allow(game).to receive(:build_white_side)
        game.setup_board
      end

      it 'calls build_white_side method' do
        allow(game).to receive(:build_black_side)
        game.setup_board
      end
    end

    describe '#compose_display' do
      it 'should build display based on interface board' do
        allow(game).to receive(:compose_display)

        game.interface.display.map do |square|
          square.respond_to(:location)
        end
      end
    end

    describe '#build_white_side' do
      it 'calls method to place white knights' do
        allow(game).to receive(:create_white_knights)
        game.build_white_side
      end

      it 'calls method to place white rooks' do
        allow(game).to receive(:create_white_rooks)
        game.build_white_side
      end

      it 'calls method to place white bishops' do
        allow(game).to receive(:create_white_rooks)
        game.build_white_side
      end

      it 'calls method to place white queen' do
        allow(game).to receive(:create_white_queen)
        game.build_white_side
      end

      it 'calls method to place white king' do
        allow(game).to receive(:create_white_king)
        game.build_white_side
      end

      it 'calls method to place white pawn' do
        allow(game).to receive(:create_white_pawns)
        game.build_white_side
      end
    end

    describe '#create_white_knights' do
      it 'places the white knights on the board' do
        game.create_white_knights
        expect(board.find([1, 2]).piece).to eq(game.white_knight)
        expect(board.find([1, 7]).piece).to eq(game.white_knight)
      end
    end

    describe '#create_white_rooks' do
      it 'places the white rooks on the board' do
        game.create_white_rooks
        expect(board.find([1, 1]).piece).to eq(game.white_rook)
        expect(board.find([1, 8]).piece).to eq(game.white_rook)
      end
    end

    describe '#create_white_bishops' do
      it 'places the white bishops on the board' do
        game.create_white_bishops
        expect(board.find([1, 3]).piece).to eq(game.white_bishop)
        expect(board.find([1, 6]).piece).to eq(game.white_bishop)
      end
    end

    describe '#create_white_queen' do
      it 'places the white queen on the board' do
        game.create_white_queen
        expect(board.find([1, 4]).piece).to eq(game.white_queen)
      end
    end

    describe '#create_white_king' do
      it 'places the white king on the board' do
        game.create_white_king
        expect(board.find([1, 5]).piece).to eq(game.white_king)
      end
    end

    describe '#create_white_pawns' do
      it 'places the white pawns on the board' do
        game.create_white_pawns

        8.times do |space|
          expect(board.find([2, space + 1]).piece).to eq(game.white_pawn)
        end
      end
    end

    describe '#build_white_side' do
      it 'calls method to place black knights' do
        allow(game).to receive(:create_black_knights)
        game.build_black_side
      end

      it 'calls method to place black rooks' do
        allow(game).to receive(:create_black_rooks)
        game.build_black_side
      end

      it 'calls method to place black bishops' do
        allow(game).to receive(:create_black_rooks)
        game.build_black_side
      end

      it 'calls method to place black queen' do
        allow(game).to receive(:create_black_queen)
        game.build_black_side
      end

      it 'calls method to place black king' do
        allow(game).to receive(:create_black_king)
        game.build_black_side
      end

      it 'calls method to place black pawn' do
        allow(game).to receive(:create_black_pawns)
        game.build_black_side
      end
    end

    describe '#create_black_knights' do
      it 'places the black knights on the board' do
        game.create_black_knights
        expect(board.find([8, 2]).piece).to eq(game.black_knight)
        expect(board.find([8, 7]).piece).to eq(game.black_knight)
      end
    end

    describe '#create_black_rooks' do
      it 'places the black rooks on the board' do
        game.create_black_rooks
        expect(board.find([8, 1]).piece).to eq(game.black_rook)
        expect(board.find([8, 8]).piece).to eq(game.black_rook)
      end
    end

    describe '#create_black_bishops' do
      it 'places the black bishops on the board' do
        game.create_black_bishops
        expect(board.find([8, 3]).piece).to eq(game.black_bishop)
        expect(board.find([8, 6]).piece).to eq(game.black_bishop)
      end
    end

    describe '#create_black_queen' do
      it 'places the black queen on the board' do
        game.create_black_queen
        expect(board.find([8, 4]).piece).to eq(game.black_queen)
      end
    end

    describe '#create_black_king' do
      it 'places the black king on the board' do
        game.create_black_king
        expect(board.find([8, 5]).piece).to eq(game.black_king)
      end
    end

    describe '#create_black_pawns' do
      it 'places the black pawns on the board' do
        game.create_black_pawns

        8.times do |space|
          expect(board.find([7, space + 1]).piece).to eq(game.black_pawn)
        end
      end
    end
  end
end
