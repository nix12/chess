require 'gameplay/save_mechanics'
require 'board/board'
require 'player/player'
require 'date'

RSpec.describe SaveMechanics do
  let(:board) { Board.new }
  let(:player1) { Player.new('Test', 'White', true) }
  let(:player2) { Player.new('User', 'black', false) }
  let(:created_at) { DateTime.now.strftime("%b %-d %Y %-l:%M %p") }
  let(:updated_at) { DateTime.now.strftime("%b %-d %Y %-l:%M %p") }

  CONN = PG.connect(
    dbname: 'chess_test',
    host: 'localhost',
    port: 5432
  )

  before(:each) do
    board.build_board
    board.build_display

    described_class.surpress_notice
    described_class.create_table
  end

  after(:each) do
    CONN.exec('DROP TABLE chess')
  end

  after(:all) do
    described_class.disconnect
  end

  describe '::self.preserve_turn' do
    it 'should flip both players active status before save' do
      expect(player1.active).to eq(true)
      expect(player2.active).to eq(false)
      described_class.preserve_turn(player1, player2)
      expect(player1.active).to eq(false)
      expect(player2.active).to eq(true)
    end
  end

  describe '::self.from_json!' do
    let(:saved_board) { board.to_json }

    it 'should convert JSON string to hash' do
      expect(saved_board).to be_kind_of(String)

      converted_board = described_class.from_json!(saved_board)
      converted_board['@board'].each do |square|
        expect(square).to be_kind_of(Hash)
      end
    end
  end

  describe '::self.recursive_formatting' do
    let(:saved_board) { board.to_json }
    let(:converted_board) { described_class.from_json!(saved_board) }

    it 'should convert the JSON keys from strings to symbols' do

      converted_board['@board'].each do |key|
        expect(key).to be_kind_of(Hash)
      end

      formated_board = described_class.recursive_formatting(converted_board)
      formated_board.keys.each do |key|
        expect(key).to be_kind_of(Symbol)
      end
    end
  end

  describe '::self.save' do
    it 'should call number_of_saved_games' do
      expect(described_class).to receive(:number_of_saved_games).and_return(0)   

      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )
    end

    it 'should save one record to the database if there are no saved games' do
      allow(described_class).to receive(:number_of_saved_games).and_return(0)
      expect(described_class.number_of_saved_games).to eq(0)

      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )
    end

    it 'should call delete method when there are 10 or more saved games, and yes to delete' do
      10.times do
        described_class.save(
          board.to_json,
          player1.to_json,
          player2.to_json,
          created_at,
          updated_at
        )
      end

      allow(described_class).to receive(:delete).with(1)
      allow($stdin).to receive(:gets).and_return("yes\n", 1)

      expect { described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      ); exit }.to raise_error SystemExit

      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )
    end

    it 'should output "Unable to save game" when no is entered, but still continue current game' do
      10.times do
        described_class.save(
          board.to_json,
          player1.to_json,
          player2.to_json,
          created_at,
          updated_at
        )
      end

      allow($stdin).to receive(:gets).and_return("no\n")
      expect { described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      ) }.to output(puts 'Unable to save game.').to_stdout

      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )
    end
  end

  describe "::self.delete" do
    it 'should remove 1 record when called' do
      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )

      res = CONN.exec(
        'SELECT COUNT(*)
        FROM chess'
      )

      expect(res[0]['count'].to_i).to eq(1)

      described_class.delete(1)

      res = CONN.exec(
        'SELECT COUNT(*)
        FROM chess'
      )

      expect(res[0]['count'].to_i).to eq(0)
    end
  end

  describe '::self.load' do
    it 'should load previously saved game' do
      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )

      res = CONN.exec(
        'SELECT COUNT(*)
        FROM chess'
      )

      expect(res[0]['count'].to_i).to eq(1)

      data = described_class.load(1)

      expect(data[0][0]).to eq(board.to_json)
      expect(data[0][1]).to eq(player1.to_json)
      expect(data[0][2]).to eq(player2.to_json)
    end
  end

  describe '::self.update' do
    let(:id) { 1 }
    let(:current) { DateTime.now.strftime("%b %-d %Y %-l:%M %p") }

    it 'should update previously saved game' do
      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )

      res = CONN.exec(
        'SELECT *
        FROM chess
        WHERE id = $1',
        [id]
      )

      expect(DateTime.parse(res[0]['updated_at'])).to eq(DateTime.parse(updated_at))

      described_class.update(
        id,
        board.to_json,
        player1.to_json,
        player2.to_json,
        current
      )

      res2 = CONN.exec(
        'SELECT *
        FROM chess
        WHERE id = $1',
        [id]
      )
      
      expect(DateTime.parse(res2[0]['updated_at'])).to eq(DateTime.parse(current))
    end
  end

  describe '::self.list_games' do
    it "should output 'There are no saved games at this time.', then exit" do
      expect { described_class.list_games }.to output(
        puts 'There are no saved games at this time.'
      ).to_stdout

      expect { described_class.list_games }.to output(
        puts 'Exiting.'
      ).to_stdout

      allow(described_class).to receive(:exit)
      described_class.list_games
    end

    it 'should show all available saved games' do
      described_class.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        created_at,
        updated_at
      )

      expect { described_class.list_games }.to output(
        puts "1       Test       User      #{ created_at }      #{ updated_at }"
      ).to_stdout
    end
  end
end
