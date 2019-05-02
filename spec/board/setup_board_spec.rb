require 'board/setup_board'

RSpec.describe SetupBoard do
  describe 'setup of board with pieces' do
    let(:gameboard) { Board.new }
    let(:setup) { SetupBoard.new(gameboard) }

    before { gameboard.build_board }

    describe '#setup_board' do
      it "calls gameboard's build_board method" do
        allow(gameboard).to receive(:build_board)
        setup.setup_board
      end

      it 'calls build_white_side method' do
        allow(setup).to receive(:build_white_side)
        setup.setup_board
      end

      it 'calls build_white_side method' do
        allow(setup).to receive(:build_black_side)
        setup.setup_board
      end
    end

    describe '#build_white_side' do
      it 'calls method to place white knights' do
        allow(setup).to receive(:create_white_knights)
        setup.build_white_side
      end

      it 'calls method to place white rooks' do
        allow(setup).to receive(:create_white_rooks)
        setup.build_white_side
      end

      it 'calls method to place white bishops' do
        allow(setup).to receive(:create_white_rooks)
        setup.build_white_side
      end

      it 'calls method to place white queen' do
        allow(setup).to receive(:create_white_queen)
        setup.build_white_side
      end

      it 'calls method to place white king' do
        allow(setup).to receive(:create_white_king)
        setup.build_white_side
      end

      it 'calls method to place white pawn' do
        allow(setup).to receive(:create_white_pawns)
        setup.build_white_side
      end
    end

    describe '#create_white_knights' do
      it 'places the white knights on the board' do
        setup.create_white_knights
        expect(gameboard.find([0, 1]).piece).to eq(setup.white_knight)
        expect(gameboard.find([0, 6]).piece).to eq(setup.white_knight)
      end
    end

    describe '#create_white_rooks' do
      it 'places the white rooks on the board' do
        setup.create_white_rooks
        expect(gameboard.find([0, 0]).piece).to eq(setup.white_rook)
        expect(gameboard.find([0, 7]).piece).to eq(setup.white_rook)
      end
    end

    describe '#create_white_bishops' do
      it 'places the white bishops on the board' do
        setup.create_white_bishops
        expect(gameboard.find([0, 2]).piece).to eq(setup.white_bishop)
        expect(gameboard.find([0, 5]).piece).to eq(setup.white_bishop)
      end
    end

    describe '#create_white_queen' do
      it 'places the white queen on the board' do
        setup.create_white_queen
        expect(gameboard.find([0, 3]).piece).to eq(setup.white_queen)
      end
    end

    describe '#create_white_king' do
      it 'places the white king on the board' do
        setup.create_white_king
        expect(gameboard.find([0, 4]).piece).to eq(setup.white_king)
      end
    end

    describe '#create_white_pawns' do
      it 'places the white pawns on the board' do
        setup.create_white_pawns

        8.times do |space|
          expect(gameboard.find([1, space]).piece).to eq(setup.white_pawn)
        end
      end
    end

    describe '#build_white_side' do
      it 'calls method to place black knights' do
        allow(setup).to receive(:create_black_knights)
        setup.build_black_side
      end

      it 'calls method to place black rooks' do
        allow(setup).to receive(:create_black_rooks)
        setup.build_black_side
      end

      it 'calls method to place black bishops' do
        allow(setup).to receive(:create_black_rooks)
        setup.build_black_side
      end

      it 'calls method to place black queen' do
        allow(setup).to receive(:create_black_queen)
        setup.build_black_side
      end

      it 'calls method to place black king' do
        allow(setup).to receive(:create_black_king)
        setup.build_black_side
      end

      it 'calls method to place black pawn' do
        allow(setup).to receive(:create_black_pawns)
        setup.build_black_side
      end
    end

    describe '#create_black_knights' do
      it 'places the black knights on the board' do
        setup.create_black_knights
        expect(gameboard.find([7, 1]).piece).to eq(setup.black_knight)
        expect(gameboard.find([7, 6]).piece).to eq(setup.black_knight)
      end
    end

    describe '#create_black_rooks' do
      it 'places the black rooks on the board' do
        setup.create_black_rooks
        expect(gameboard.find([7, 0]).piece).to eq(setup.black_rook)
        expect(gameboard.find([7, 7]).piece).to eq(setup.black_rook)
      end
    end

    describe '#create_black_bishops' do
      it 'places the black bishops on the board' do
        setup.create_black_bishops
        expect(gameboard.find([7, 2]).piece).to eq(setup.black_bishop)
        expect(gameboard.find([7, 5]).piece).to eq(setup.black_bishop)
      end
    end

    describe '#create_black_queen' do
      it 'places the black queen on the board' do
        setup.create_black_queen
        expect(gameboard.find([7, 3]).piece).to eq(setup.black_queen)
      end
    end

    describe '#create_black_king' do
      it 'places the black king on the board' do
        setup.create_black_king
        expect(gameboard.find([7, 4]).piece).to eq(setup.black_king)
      end
    end

    describe '#create_black_pawns' do
      it 'places the black pawns on the board' do
        setup.create_black_pawns

        8.times do |space|
          expect(gameboard.find([6, space]).piece).to eq(setup.black_pawn)
        end
      end
    end
  end
end
