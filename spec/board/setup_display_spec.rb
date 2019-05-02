require 'board/setup_display'

RSpec.describe SetupDisplay do
  describe 'setup of display with pieces' do
    let(:gameboard) { Board.new }
    let(:setup) { SetupDisplay.new(gameboard) }

    before { gameboard.build_display }

    describe '#setup_display' do
      it "calls gameboard's build_board method" do
        allow(gameboard).to receive(:build_board)
        setup.setup_display
      end

      it 'calls build_white_side method' do
        allow(setup).to receive(:build_white_side)
        setup.setup_display
      end

      it 'calls build_white_side method' do
        allow(setup).to receive(:build_black_side)
        setup.setup_display
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
        expect(gameboard.display[0][1]).to eq(setup.white_knight.icon)
        expect(gameboard.display[0][6]).to eq(setup.white_knight.icon)
      end
    end

    describe '#create_white_rooks' do
      it 'places the white rooks on the board' do
        setup.create_white_rooks
        expect(gameboard.display[0][0]).to eq(setup.white_rook.icon)
        expect(gameboard.display[0][7]).to eq(setup.white_rook.icon)
      end
    end

    describe '#create_white_bishops' do
      it 'places the white bishops on the board' do
        setup.create_white_bishops
        expect(gameboard.display[0][2]).to eq(setup.white_bishop.icon)
        expect(gameboard.display[0][5]).to eq(setup.white_bishop.icon)
      end
    end

    describe '#create_white_queen' do
      it 'places the white queen on the board' do
        setup.create_white_queen
        expect(gameboard.display[0][3]).to eq(setup.white_queen.icon)
      end
    end

    describe '#create_white_king' do
      it 'places the white king on the board' do
        setup.create_white_king
        expect(gameboard.display[0][4]).to eq(setup.white_king.icon)
      end
    end

    describe '#create_white_pawns' do
      it 'places the white pawns on the board' do
        setup.create_white_pawns

        8.times do |space|
          expect(gameboard.display[1][space]).to eq(setup.white_pawn.icon)
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
        expect(gameboard.display[7][1]).to eq(setup.black_knight.icon)
        expect(gameboard.display[7][6]).to eq(setup.black_knight.icon)
      end
    end

    describe '#create_black_rooks' do
      it 'places the black rooks on the board' do
        setup.create_black_rooks
        expect(gameboard.display[7][0]).to eq(setup.black_rook.icon)
        expect(gameboard.display[7][7]).to eq(setup.black_rook.icon)
      end
    end

    describe '#create_black_bishops' do
      it 'places the black bishops on the board' do
        setup.create_black_bishops
        expect(gameboard.display[7][2]).to eq(setup.black_bishop.icon)
        expect(gameboard.display[7][5]).to eq(setup.black_bishop.icon)
      end
    end

    describe '#create_black_queen' do
      it 'places the black queen on the board' do
        setup.create_black_queen
        expect(gameboard.display[7][3]).to eq(setup.black_queen.icon)
      end
    end

    describe '#create_black_king' do
      it 'places the black king on the board' do
        setup.create_black_king
        expect(gameboard.display[7][4]).to eq(setup.black_king.icon)
      end
    end

    describe '#create_black_pawns' do
      it 'places the black pawns on the board' do
        setup.create_black_pawns

        8.times do |space|
          expect(gameboard.display[6][space]).to eq(setup.black_pawn.icon)
        end
      end
    end
  end
end
