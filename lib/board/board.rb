require_relative 'square'
require_relative '../base/base'
require 'ostruct'

# Handles initializing, building and displaying chess board.
# Also, provides ability to find specifc spaces in the chess board.
class Board < Base
  attr_accessor :board, :display

  def initialize(board = [], display = [])
    @board = board
    @display = display
  end

  def self.x_coordinate
    (0..7).to_a
  end

  def self.y_coordinate
    (0..7).to_a
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
    Board.x_coordinate.each.with_index do |_x, _i|
      row = []
      display << row

      Board.y_coordinate.each.with_index do |_y, _j|
        row << '*'
      end
    end
  end

  def print_display
    display.reverse_each { |row| p row.join(' ') }
  end
end
