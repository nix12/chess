require 'gameplay/game_mechanics'
require 'board/board'
require 'board/setup_board'
require 'board/setup_display'
require 'player/player'

RSpec.describe GameMechanics do 
  let(:board) { Board.new }
  let(:game) { SetupBoard.new(board) }
  let(:display) { SetupDisplay.new(board) }
  let(:white_king) { game.white_king }
  let(:black_king) { game.black_king }
  let(:white_queen) { game.white_queen }
  let(:white_pawn) { game.white_pawn }
  let(:black_pawn) { game.black_pawn }
  let(:player1) { described_class.create_white_player }
  let(:player2) { described_class.create_black_player }
  
  before(:each) do
    game.setup_board
    display.setup_display
  end

  describe '::self.select_piece' do
    it 'should call move' do
      allow(white_pawn).to receive(:move).with(board, [1, 0], [3, 0])
      described_class.select_piece(game, [1, 0], [3, 0]) 
    end

    it 'should call take_piece' do
      8.times do |space|
        black_pawn.move(board, [6, space], [5, space])
        black_pawn.move(board, [5, space], [4, space])
        black_pawn.move(board, [4, space], [3, space])
        black_pawn.move(board, [3, space], [2, space])
      end

      allow(white_pawn).to receive(:take_piece).with(board, [1, 0], [2, 1])
      described_class.select_piece(game, [1, 0], [2, 1])
    end
  end

  describe '::self.create_white_player' do
    it 'should output "Enter first player\'s name:" to console' do
      allow($stdin).to receive(:gets).and_return('test')
      expect { player1 }.to output(puts "Enter first player's name:").to_stdout
      allow($stdin).to receive(:gets).and_return("test\n")
      expect(player1).to be_instance_of(Player)
      expect(player1.name).to eq('test')
    end
  end

  describe '::self.create_black_player' do
    it 'should output "Enter second player\'s name:" to console' do
      allow($stdin).to receive(:gets).and_return('user')
      expect { player2 }.to output(puts "Enter second player's name:").to_stdout
      allow($stdin).to receive(:gets).with("user\n")
      expect(player2).to be_instance_of(Player)
      expect(player2.name).to eq('user')
    end
  end

  describe '::self.change_turn' do
    before(:each) do
      allow($stdin).to receive(:gets).and_return('test', 'user')
    end

    it 'should start with player1 and player2 not active' do
      expect(player1.active).to eq(false)
      expect(player2.active).to eq(false)
    end

    it 'should start with player1 active after change_turn is called the first time' do
      expect(player1.active).to eq(false)
      described_class.change_turn(player1, player2)
      expect(player1.active).to eq(true)
    end

    it 'should make player2 active if player1 is already active' do
      player1.active = true
      expect(player1.active).to eq(true)
      expect(player2.active).to eq(false)
      described_class.change_turn(player1, player2)
      expect(player1.active).to eq(false)
      expect(player2.active).to eq(true)
    end

    it 'should make player1 active if player2 is already active' do
      player2.active = true
      expect(player1.active).to eq(false)
      expect(player2.active).to eq(true)
      described_class.change_turn(player1, player2)
      expect(player1.active).to eq(true)
      expect(player2.active).to eq(false)
    end
  end

  describe '::self.get_my_king' do
    before(:each) do
      allow($stdin).to receive(:gets).and_return('test')
    end

    it 'should return location of owners king' do
      allow(board).to receive(:find_by_piece).with('king').and_return([[0, 4], [7, 4]])
      expect(described_class.get_my_king(board, player1)).to eq([0, 4])
    end
  end

  describe '::self.get_my_king' do
    before(:each) do
      allow($stdin).to receive(:gets).and_return('test')
    end

    it 'should return location of owners king' do
      allow(board).to receive(:find_by_piece).with('king').and_return([[0, 4], [7, 4]])
      expect(described_class.get_enemy_king(board, player1)).to eq([7, 4])
    end
  end

  describe '::self.has_check?' do
    it 'should return false when enemy king is in check' do
      expect(described_class.has_check?(game, [7, 4])).to eq(false)
    end

    it 'should return true when enemy king is in check' do
      8.times do |space|
        white_pawn.remove_piece(board, [1, space], [2, space])
        white_pawn.moves.clear
        black_pawn.remove_piece(board, [6, space], [5, space])
        black_pawn.moves.clear
      end

      white_queen.move(board, [0, 3], [1, 4])
      expect(described_class.has_check?(game, [7, 4])).to eq(true)
    end
  end

  describe '::self.check_prevention' do
    it 'calls prevent_move_into_check' do
      allow(black_king).to receive(:prevent_move_into_check)
        .with(board, [7, 4])
        .and_return(false)
      black_king.prevent_move_into_check(board, [7, 4])
    end

    it 'should return empty array when no moves are available' do
      expect(described_class.check_prevention(game, [7, 4])).to eq([])
    end

    it 'should return array of available moves' do
      8.times do |space|
        white_pawn.remove_piece(board, [1, space], [2, space])
        white_pawn.moves.clear
        black_pawn.remove_piece(board, [6, space], [5, space])
        black_pawn.moves.clear
      end

      white_queen.move(board, [0, 3], [1, 4])
      expect(described_class.check_prevention(game, [7, 4])).to eq([[6, 3], [6, 5]])
    end
  end

  describe '::self.has_checkmate?' do
    it "should call enemy king's check method" do
      allow(black_king).to receive_message_chain(:check, :any?)
      described_class.has_checkmate?(game, [7, 4])
    end

    it "should call enemy king's checkmate? method" do
      allow(black_king).to receive(:checkmate?).with(board, [7, 4])
      described_class.has_checkmate?(game, [7, 4])
    end

    it 'should return false when not in checkmate' do
      expect(described_class.has_checkmate?(game, [7, 4])).to eq(false)
    end

    it 'should return true when in checkmate' do
      8.times do |space|
        white_pawn.remove_piece(board, [1, space], [2, space])
        white_pawn.moves.clear
        black_pawn.remove_piece(board, [6, space], [5, space])
        black_pawn.moves.clear
      end

      white_queen.move(board, [0, 3], [1, 4])
      white_queen.move(board, [1, 4], [6, 4])

      expect(described_class.has_checkmate?(game, [7, 4])).to eq(true)
    end
  end

  describe '::self.error_check?' do
    it 'should return false if there is no error' do
      expect(described_class.error_check?(game, [0, 4])).to eq(false)
    end

    it 'should return true if there is an error' do
      white_pawn.move(board, [1, 0], [2, 1])
      expect(described_class.error_check?(game, [1, 0])).to eq(true)
    end
  end

  describe '::self.reset_error' do
    it 'sets a pieces error back to false' do
      white_pawn.move(board, [1, 0], [2, 1])
      expect(described_class.error_check?(game, [1, 0])).to eq(true)
      described_class.reset_error(game, [1, 0])
      expect(described_class.error_check?(game, [1, 0])).to eq(false)
    end
  end
end
