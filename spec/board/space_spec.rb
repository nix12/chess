require 'board/space'
require 'pieces/knight'

RSpec.describe Space do
  describe 'new space for gameboard' do
    let(:space) { Space.new([5, 4]) }

    it 'should be an instance of space' do
      expect(space).to be_an_instance_of(Space)
    end

    it 'should respond to location and piece' do
      expect(space).to respond_to(:location)
      expect(space).to respond_to(:piece)
    end

    it 'should have initialized location of [5, 4]' do
      expect(space.location).to eq([5, 4])
    end

    it 'should have an x axis between 0 and 7' do
      expect(space.location[1]).to be >= 0
      expect(space.location[1]).to be <= 7
    end

    it 'should have an y axis between 0 and 7' do
      expect(space.location[0]).to be >= 0
      expect(space.location[0]).to be <= 7
    end

    it 'calls piece' do
      knight = Knight.new('white')
      space.piece = knight.icon

      expect(space).to receive(:piece).and_return(knight.icon)
      space.piece
    end

    it 'calls location' do
      expect(space).to receive(:location).and_return([5, 4])
      space.location
    end
  end
end
