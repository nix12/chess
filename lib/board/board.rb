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
    (0..8).to_a
  end

  def self.y_coordinate
    (0..8).to_a
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
        node = Square.new([x, y])
        board << node
      end
    end
  end

  def print_board
    pp board
  end

  def build_display
    y_coord = [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    Board.x_coordinate.each.with_index do |_x, i|
      row = []

      if i.zero?
        display << [' ', '1', '2', '3', '4', '5', '6', '7', '8']
      else
        display << row
      end

      Board.y_coordinate.each.with_index do |_y, j|
        if j.zero?
          row << y_coord[i]
        else
          row << '*'
        end
      end
    end
  end

  def print_display
    display.reverse_each { |row| p row.join(' ') }
  end
end
