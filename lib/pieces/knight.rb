require_relative 'piece'

# Handles creation of the Knight chess piece.

class Knight < Piece
  attr_reader :move_set, :icon

  def initialize(color)
    super(color)
    @icon = set_icon
    @move_set = [
      [1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]
    ].freeze
  end

  private

  def set_icon
    color == 'white' ? "\u265E" : "\u2658"
  end
end
