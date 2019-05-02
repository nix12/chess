require 'board/board'
require 'board/setup_board'
require 'board/setup_display'
require 'pieces/knight'
require 'pieces/queen'
require 'pieces/pawn'

RSpec.describe Piece do
  describe 'creation and movements' do
    let(:board) { Board.new }
    let(:game) { SetupBoard.new(board) }
    let(:display) { SetupDisplay.new(board) }
    let(:knight) { game.white_knight }
    let(:white_queen) { game.white_queen }
    let(:black_queen) { game.black_queen }
    let(:white_pawn) { game.white_pawn }
    let(:black_pawn) { game.black_pawn }

    before do
      game.setup_board
      display.setup_display

      8.times do |space|
        white_pawn.remove_piece(board, [1, space], [2, space])
        white_pawn.moves.clear
        black_pawn.remove_piece(board, [6, space], [5, space])
        black_pawn.moves.clear
      end
    end

    it 'calls color' do
      allow(knight).to receive(:color).and_return('white')
      knight.color
    end

    it 'calls moves' do
      allow(knight).to receive(:moves).and_return(knight.move_set)
      knight.moves
    end

    describe '#add_piece' do
      let(:start_location) { [0, 1] }
      let(:end_location) { [2, 2] }

      context 'should create and validate moves' do
        it 'calls create_moves' do
          allow(knight).to receive(:create_moves).with(start_location)
          knight.instance_variable_set(:@moves, [[1, 3], [1, nil], [nil, 3], [nil, nil], [2, 2], [2, 0], [nil, 2], [nil, 0]])
          expect(knight.moves).to eq(
            [[1, 3], [1, nil], [nil, 3], [nil, nil], [2, 2], [2, 0], [nil, 2], [nil, 0]]
          )
        end

        it 'calls valid_moves? and returns true' do
          allow(knight).to receive(:valid_moves?).with(end_location).and_return(true)
          knight.add_piece(board, start_location, end_location)
          expect(knight.valid_moves?(end_location)).to eq(true)
        end

        it 'call valid_moves? and returns false' do
          end_location = [9, 9]

          allow(knight).to receive(:valid_moves?).with(end_location).and_return(false)
          knight.add_piece(board, start_location, end_location)
          expect(knight.valid_moves?(end_location)).to eq(false)
        end
      end

      context 'should move a piece in on the board and in the display' do
        it 'should add a piece to the board' do
          board.find(end_location).piece = knight
          expect(board.find(end_location).piece).to eq(knight)
        end

        it 'should add a piece to the display' do
          board.display[end_location[0]][end_location[1]] = knight.icon
          expect(board.display[end_location[0]][end_location[1]]).to eq(knight.icon)
        end
      end

      it 'adds piece to specified end location' do
        knight.add_piece(board, start_location, end_location)
        expect(board.find(end_location).piece).to eq(knight)
        expect(board.display[end_location[0]][end_location[1]]).to eq(knight.icon)
      end
    end

    describe '#remove_piece' do
      let(:start_location) { [0, 1] }
      let(:end_location) { [2, 2] }

      context 'should create and validate moves' do
        it 'calls create_moves' do
          allow(knight).to receive(:create_moves).with(start_location)
                                                 .and_return(knight.moves)
          knight.create_moves(start_location)
        end

        it 'calls valid_moves? returns and returns true' do
          allow(knight).to receive(:valid_moves?).with(end_location).and_return(true)
          knight.valid_moves?(end_location)
          expect(knight.valid_moves?(end_location)).to eq(true)
        end

        it 'call valid_moves? and returns false' do
          end_location = [9, 9]

          allow(knight).to receive(:valid_moves?).with(end_location).and_return(false)
          knight.add_piece(board, start_location, end_location)
          expect(knight.valid_moves?(end_location)).to eq(false)
        end
      end

      context 'should remove a piece on the board and in the display' do
        it 'should remove a piece to the board' do
          expect(board.find(end_location).piece).to eq(nil)
        end

        it 'should remove a piece to the display' do
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
        end
      end

      it 'removes piece from specified start location' do
        knight.remove_piece(board, start_location, end_location)
        expect(board.find(end_location).piece).to eq(nil)
        expect(board.display[end_location[0]][end_location[1]]).to eq('*')
      end
    end

    describe '#replace_piece' do
      let(:start_location) { [0, 1] }
      let(:end_location) { [2, 2] }

      context 'should create and validate moves' do
        it 'calls create_moves' do
          allow(knight).to receive(:create_moves).with(start_location)
                                                 .and_return(knight.moves)
          knight.create_moves(start_location)
        end

        it 'calls valid_moves? returns and returns true' do
          allow(knight).to receive(:valid_moves?).with(end_location).and_return(true)
          knight.valid_moves?(end_location)
          expect(knight.valid_moves?(end_location)).to eq(true)
        end

        it 'call valid_moves? and returns false' do
          end_location = [9, 9]

          allow(knight).to receive(:valid_moves?).with(end_location).and_return(false)
          knight.add_piece(board, start_location, end_location)
          expect(knight.valid_moves?(end_location)).to eq(false)
        end
      end

      context 'should replace a piece on the board and in the display' do
        it 'should replace a piece to the board' do
          expect(board.find(end_location).piece).to eq(nil)
          board.find(end_location).piece = knight
          expect(board.find(end_location).piece).to eq(knight)
        end

        it 'should replace a piece to the display' do
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          board.display[end_location[0]][end_location[1]] = knight.icon
          expect(board.display[end_location[0]][end_location[1]]).to eq(knight.icon)
        end
      end

      it 'replaces piece from specified start location' do
        expect(board.find(end_location).piece).to eq(nil)
        expect(board.display[end_location[0]][end_location[1]]).to eq('*')
        knight.replace_piece(board, start_location, end_location)
        expect(board.find(end_location).piece).to eq(knight)
        expect(board.display[end_location[0]][end_location[1]]).to eq(knight.icon)
      end
    end

    describe '#move' do
      let(:start_location) { [0, 3] }
      let(:end_location) { [1, 2] }

      it 'calls add_piece' do
        allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
        white_queen.move(board, start_location, end_location)
      end

      it 'calls remove_piece' do
        allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
        white_queen.move(board, start_location, end_location)
      end

      context 'diagonally' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [3, 0] }

        it 'calls ranged_diagonal' do
          allow(white_queen).to receive(:ranged_diagonal)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.move(board, start_location, end_location)
        end

        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end

        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end

        it 'should move a piece diagonally on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece diagonally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context 'vertically' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [5, 3] }
  
        it 'calls ranged_vertical' do
          allow(white_queen).to receive(:ranged_vertical)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.move(board, start_location, end_location)
        end
  
        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end
      end
  
      context 'horizontally' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [0, 7] }
  
        before do
          (0..7).each.with_index do |space, i|
            board.find([0, space]).piece = nil unless i == 3
            board.display[0][space] = '*' unless i == 3
          end
        end
  
        it 'calls ranged_horizontal' do
          allow(white_queen).to receive(:ranged_horizontal)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.move(board, start_location, end_location)
        end
  
        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.move(board, start_location, end_location)
        end
      end

      context 'pawn movment' do
        let(:start_location) { [1, 0] }
        let(:end_location) { [3, 0] }
        
        before(:each) do
          game.create_white_pawns
        end

        it 'should move a pawn two spaces forward' do
          allow(white_pawn).to receive(:pawn_two_moves_forward).with(board, start_location)
          white_pawn.move(board, start_location, end_location)
        end

        it 'calls add_piece' do
          allow(white_pawn).to receive(:add_piece).with(board, start_location, end_location)
          white_pawn.move(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_pawn).to receive(:remove_piece).with(board, start_location, end_location)
          white_pawn.move(board, start_location, end_location)
        end
      end
    end

    describe '#take_piece' do
      let(:start_location) { [0, 3] }
      let(:end_location) { [1, 2] }

      it 'calls add_piece' do
        allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
        white_queen.take_piece(board, start_location, end_location)
      end

      it 'calls remove_piece' do
        allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
        white_queen.take_piece(board, start_location, end_location)
      end

      context 'diagonally' do
        it 'calls ranged_diagonal' do
          start_location = [0, 3]
          end_location = [3, 0]

          8.times do |space|
            black_pawn.move(board, [6, space], [5, space])
            black_pawn.move(board, [5, space], [4, space])
            black_pawn.move(board, [4, space], [3, space])
          end

          allow(white_queen).to receive(:ranged_diagonal)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.take_piece(board, start_location, end_location)
        end

        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end

        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end

        it 'should take a piece diagonally on board' do
          8.times do |space|
            black_pawn.move(board, [6, space], [5, space])
            black_pawn.move(board, [5, space], [4, space])
            black_pawn.move(board, [4, space], [3, space])
            black_pawn.move(board, [3, space], [2, space])
            black_pawn.move(board, [2, space], [1, space])
          end

          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(black_pawn)
          white_queen.take_piece(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should take a piece diagonally in display' do
          8.times do |space|
            black_pawn.move(board, [6, space], [5, space])
            black_pawn.move(board, [5, space], [4, space])
            black_pawn.move(board, [4, space], [3, space])
            black_pawn.move(board, [3, space], [2, space])
            black_pawn.move(board, [2, space], [1, space])
          end

          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq(black_pawn.icon)
          white_queen.take_piece(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context 'vertically' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [5, 3] }

        
        it 'calls ranged_vertical' do
          8.times do |space|
            black_pawn.move(board, [6, space], [5, space])
          end

          allow(white_queen).to receive(:ranged_vertical)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.take_piece(board, start_location, end_location)
        end
  
        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end
      end
  
      context 'horizontally' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [0, 7] }
  
        before do
          (0..7).each.with_index do |space, i|
            board.find([0, space]).piece = nil unless i == 3
            board.display[0][space] = '*' unless i == 3
          end
        end
  
        it 'calls ranged_horizontal' do
          allow(white_queen).to receive(:ranged_horizontal)
            .with(board, start_location, end_location)
            .and_return(true)
          white_queen.take_piece(board, start_location, end_location)
        end
  
        it 'calls add_piece' do
          allow(white_queen).to receive(:add_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_queen).to receive(:remove_piece).with(board, start_location, end_location)
          white_queen.take_piece(board, start_location, end_location)
        end
      end

      context 'pawn movement' do
        let(:start_location) { [1, 0] }
        let(:end_location) { [2, 1] }

        before(:each) do
          game.create_white_pawns

          8.times do |space|
            black_pawn.move(board, [6, space], [5, space])
            black_pawn.move(board, [5, space], [4, space])
            black_pawn.move(board, [4, space], [3, space])
            black_pawn.move(board, [3, space], [2, space])
          end
        end

        it 'should move a pawn two spaces forward' do
          allow(white_pawn).to receive(:pawn_diagonal).with(board, start_location, end_location)
          white_pawn.move(board, start_location, end_location)
        end

        it 'calls add_piece' do
          allow(white_pawn).to receive(:add_piece).with(board, start_location, end_location)
          white_pawn.move(board, start_location, end_location)
        end
  
        it 'calls remove_piece' do
          allow(white_pawn).to receive(:remove_piece).with(board, start_location, end_location)
          white_pawn.move(board, start_location, end_location)
        end
      end
    end

    describe '#ranged_diagonal' do
      context '[x, y]' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [4, 7] }

        it 'should move a piece diagonally on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece diagonally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context '[-x, y]' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [3, 0] }

        it 'should move a piece diagonally on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece diagonally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context '[-x, -y]' do
        let(:start_location) { [7, 3] }
        let(:end_location) { [3, 7] }

        it 'should move a piece diagonally on board' do
          expect(board.find(start_location).piece).to eq(black_queen)
          expect(board.find(end_location).piece).to eq(nil)
          black_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(black_queen)
        end

        it 'should move a piece diagonally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(black_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          black_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(black_queen.icon)
        end
      end

      context '[-x, -y]' do
        let(:start_location) { [7, 3] }
        let(:end_location) { [4, 0] }

        it 'should move a piece diagonally on board' do
          expect(board.find(start_location).piece).to eq(black_queen)
          expect(board.find(end_location).piece).to eq(nil)
          black_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(black_queen)
        end

        it 'should move a piece diagonally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(black_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          black_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(black_queen.icon)
        end
      end

      it 'calls check_if_occupied?' do
        allow(white_queen).to receive(:check_if_occupied?)
          .with(board)
          .and_return(false)
        white_queen.ranged_diagonal(board, [0, 3], [3, 0])
      end
    end

    describe '#ranged_vertical' do
      context 'positive y-axis' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [5, 3] }

        it 'should move a piece vertically on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece vertically in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context 'negative y-axis' do
        let(:start_location) { [7, 3] }
        let(:end_location) { [2, 3] }

        it 'should move a piece vertically on board' do
          expect(board.find(start_location).piece).to eq(black_queen)
          expect(board.find(end_location).piece).to eq(nil)
          black_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(black_queen)
        end

        it 'should move a piece vertically in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(black_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          black_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(black_queen.icon)
        end
      end

      it 'calls check_if_occupied?' do
        allow(white_queen).to receive(:check_if_occupied?)
          .with(board)
          .and_return(false)
        white_queen.ranged_vertical(board, [0, 3], [5, 3])
      end
    end

    describe '#ranged_horizontal' do
      before do
        (0..7).each.with_index do |space, i|
          board.find([0, space]).piece = nil unless i == 3
          board.display[0][space] = '*' unless i == 3

          board.find([7, space]).piece = nil unless i == 3
          board.display[7][space] = '*' unless i == 3
        end
      end

      context 'positive x-axis' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [0, 7] }

        it 'should move a piece horizontally on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece horizontally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      context 'negative x-axis' do
        let(:start_location) { [0, 3] }
        let(:end_location) { [0, 0] }

        it 'should move a piece horizontally on board' do
          expect(board.find(start_location).piece).to eq(white_queen)
          expect(board.find(end_location).piece).to eq(nil)
          white_queen.move(board, start_location, end_location)
          expect(board.find(start_location).piece).to eq(nil)
          expect(board.find(end_location).piece).to eq(white_queen)
        end

        it 'should move a piece horizontally in display' do
          expect(board.display[start_location[0]][start_location[1]]).to eq(white_queen.icon)
          expect(board.display[end_location[0]][end_location[1]]).to eq('*')
          white_queen.move(board, start_location, end_location)
          expect(board.display[start_location[0]][start_location[1]]).to eq('*')
          expect(board.display[end_location[0]][end_location[1]]).to eq(white_queen.icon)
        end
      end

      it 'calls check_if_occupied?' do
        allow(white_queen).to receive(:check_if_occupied?)
          .with(board)
          .and_return(false)
        white_queen.ranged_horizontal(board, [0, 3], [0, 7])
      end
    end

    describe '#check_if_occupied?' do
      occupied_moves = [[0, 0], [0, 1], [0, 2], [0, 3]]
      unoccupied_moves = [[3, 0], [3, 1], [3, 2], [3, 3]]
      let(:space_double) { instance_double(Space) }

      unoccupied_moves.each do |move|
        it 'calls boards find method' do
          allow(board).to receive(:find).with(move).and_return(board.find(move))
          allow(space_double).to receive(:piece).and_return(nil)

          white_queen.check_if_occupied?(board)
        end
      end

      context 'occupied' do
        occupied_moves.each do |move|
          it 'should return true' do
            expect(!board.find(move).piece.nil?).to be true
          end
        end
      end

      context 'unoccupied' do
        unoccupied_moves.each do |move|
          it 'should return false' do
            expect(!board.find(move).piece.nil?).to be false
          end
        end
      end
    end
  end
end
