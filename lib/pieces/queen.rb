require_relative 'piece'

# Handles the creation of the Queen chess piece

class Queen < Piece
  attr_reader :move_set, :icon

  def initialize(color)
    super(color)
    @icon = set_icon
    @move_set = [
      [1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]
    ].freeze
  end

  private

  def set_icon
    color == 'white' ? "\u265B" : "\u2655"
  end
end
