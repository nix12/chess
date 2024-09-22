require 'board/square'
require 'pieces/knight'

RSpec.describe Square do
  describe 'new square for gameboard' do
    let(:square) { Square.new([5, 4]) }

    it 'should be an instance of square' do
      expect(square).to be_an_instance_of(described_class)
    end

    it 'should respond to location and piece' do
      expect(square).to respond_to(:location)
      expect(square).to respond_to(:piece)
    end

    it 'should have initialized location of [5, 4]' do
      expect(square.location).to eq([5, 4])
    end

    it 'should have an x axis between 1 and 8' do
      expect(square.location[1]).to be >= 1
      expect(square.location[1]).to be <= 8
    end

    it 'should have an y axis between 1 and 8' do
      expect(square.location[0]).to be >= 1
      expect(square.location[0]).to be <= 8
    end

    it 'calls piece' do
      knight = Knight.new('white')
      square.piece = knight.icon

      expect(square).to receive(:piece).and_return(knight.icon)
      square.piece
    end

    it 'calls location' do
      expect(square).to receive(:location).and_return([5, 4])
      square.location
    end
  end
end
