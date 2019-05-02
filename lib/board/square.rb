require_relative '../base/base'

# Stores data for each individual space.
class Square < Base
  attr_reader :location
  attr_accessor :piece

  def initialize(location, piece = nil)
    @location = location
    @piece = piece
  end
end
