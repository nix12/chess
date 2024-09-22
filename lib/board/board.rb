require_relative 'square'
require_relative '../base/base'

# Handles initializing, building and displaying chess board.
# Also, provides ability to find specifc spaces in the chess board.
class Board < Base
  attr_accessor :board, :display

  def initialize(board = [], display = [])
    @board = board
    @display = display
  end

  def self.x_coordinate
    (1..8).to_a
  end

  def self.y_coordinate
    (1..8).to_a
  end

  def find(value)
    board.detect { |node| node.location == value }
  end

  def find_by_piece(piece)
    piece = piece.capitalize

    board.map { |node| node.location if node.piece.class.to_s == piece }.compact
  end

  def build_board
    Board.x_coordinate.each do |x|
      Board.y_coordinate.each do |y|
        board << Square.new([x, y])
      end
    end
  end
end
