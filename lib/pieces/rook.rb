require_relative 'piece'

# Handles creation of the Rook chess piece
class Rook < Piece
  attr_reader :move_set, :icon

  def initialize(color)
    super(color)
    @icon = set_icon
    @move_set = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ].freeze
  end

  private

  def set_icon
    color == 'white' ? "\u265C" : "\u2656"
  end
end
