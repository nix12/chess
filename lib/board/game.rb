require_relative 'board'
require_relative '../pieces/knight'
require_relative '../pieces/rook'
require_relative '../pieces/bishop'
require_relative '../pieces/queen'
require_relative '../pieces/king'
require_relative '../pieces/pawn'
require 'enumerator'

# Handles the "Setup" of chess board with chess pieces.
class Game
  attr_reader :interface,
              :white_knight,
              :black_knight,
              :white_rook,
              :black_rook,
              :white_bishop,
              :black_bishop,
              :white_queen,
              :black_queen,
              :white_king,
              :black_king,
              :white_pawn,
              :black_pawn

  def initialize(interface)
    @interface = interface

    @white_knight = Knight.new('white')
    @white_rook = Rook.new('white')
    @white_bishop = Bishop.new('white')
    @white_queen = Queen.new('white')
    @white_king = King.new('white')
    @white_pawn = Pawn.new('white')

    @black_knight = Knight.new('black')
    @black_rook = Rook.new('black')
    @black_bishop = Bishop.new('black')
    @black_queen = Queen.new('black')
    @black_king = King.new('black')
    @black_pawn = Pawn.new('black')
  end

  # Set up full chess board

  def setup_board
    interface.build_board
    build_white_side
    build_black_side
  end

  def compose_display
    interface.board.map do |square|
      if square.piece 
        interface.display << square.piece.icon
      else
        interface.display << '*'
      end
    end
      
    assign_labels
  end

  def assign_labels
    y_coord = ['1', '2', '3', '4', '5', '6', '7', '8']
    interface.display = interface.display.each_slice(8).to_a

    interface.display.map.with_index { |row, i| row.prepend(y_coord[i]) }
    interface.display.prepend([' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'])
  end

  def print_display
    interface.display.reverse_each { |row| p row.join(' ') }
  end

  # White pieces

  def build_white_side
    create_white_knights
    create_white_rooks
    create_white_bishops
    create_white_queen
    create_white_king
    create_white_pawns
  end

  def create_white_knights
    interface.find([1, 2]).piece = white_knight
    interface.find([1, 7]).piece = white_knight
  end

  def create_white_rooks
    interface.find([1, 1]).piece = white_rook
    interface.find([1, 8]).piece = white_rook
  end

  def create_white_bishops
    interface.find([1, 3]).piece = white_bishop
    interface.find([1, 6]).piece = white_bishop
  end

  def create_white_queen
    interface.find([1, 4]).piece = white_queen
  end

  def create_white_king
    interface.find([1, 5]).piece = white_king
  end

  def create_white_pawns
    8.times do |space|
      interface.find([2, space + 1]).piece = white_pawn
    end
  end

  # Black peices

  def build_black_side
    create_black_knights
    create_black_rooks
    create_black_bishops
    create_black_queen
    create_black_king
    create_black_pawns
  end

  def create_black_knights
    interface.find([8, 2]).piece = black_knight
    interface.find([8, 7]).piece = black_knight
  end

  def create_black_rooks
    interface.find([8, 1]).piece = black_rook
    interface.find([8, 8]).piece = black_rook
  end

  def create_black_bishops
    interface.find([8, 3]).piece = black_bishop
    interface.find([8, 6]).piece = black_bishop
  end

  def create_black_queen
    interface.find([8, 4]).piece = black_queen
  end

  def create_black_king
    interface.find([8, 5]).piece = black_king
  end

  def create_black_pawns
    8.times do |space|
      interface.find([7, space + 1]).piece = black_pawn
    end
  end
end
