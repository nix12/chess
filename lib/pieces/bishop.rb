require_relative 'piece'

# Handles the creation of the Bishop chess piece

class Bishop < Piece
  attr_reader :move_set, :icon

  def initialize(color)
    super(color)
    @icon = set_icon
    @move_set = [
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ].freeze
  end

  private

  def set_icon
    color == 'white' ? "\u265D" : "\u2657"
  end
end
