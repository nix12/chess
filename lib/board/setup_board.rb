require_relative 'board'
require_relative '../pieces/knight'
require_relative '../pieces/rook'
require_relative '../pieces/bishop'
require_relative '../pieces/queen'
require_relative '../pieces/king'
require_relative '../pieces/pawn'

# Handles the "Setup" of chess board with chess pieces.
class SetupBoard
  attr_reader :gameboard,
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

  def initialize(gameboard)
    @gameboard = gameboard

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
    gameboard.build_board
    build_white_side
    build_black_side
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
    gameboard.find([1, 2]).piece = white_knight
    gameboard.find([1, 7]).piece = white_knight
  end

  def create_white_rooks
    gameboard.find([1, 1]).piece = white_rook
    gameboard.find([1, 8]).piece = white_rook
  end

  def create_white_bishops
    gameboard.find([1, 3]).piece = white_bishop
    gameboard.find([1, 6]).piece = white_bishop
  end

  def create_white_queen
    gameboard.find([1, 4]).piece = white_queen
  end

  def create_white_king
    gameboard.find([1, 5]).piece = white_king
  end

  def create_white_pawns
    8.times do |space|
      gameboard.find([2, space + 1]).piece = white_pawn
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
    gameboard.find([8, 2]).piece = black_knight
    gameboard.find([8, 7]).piece = black_knight
  end

  def create_black_rooks
    gameboard.find([8, 1]).piece = black_rook
    gameboard.find([8, 8]).piece = black_rook
  end

  def create_black_bishops
    gameboard.find([8, 3]).piece = black_bishop
    gameboard.find([8, 6]).piece = black_bishop
  end

  def create_black_queen
    gameboard.find([8, 4]).piece = black_queen
  end

  def create_black_king
    gameboard.find([8, 5]).piece = black_king
  end

  def create_black_pawns
    8.times do |space|
      gameboard.find([7, space + 1]).piece = black_pawn
    end
  end
end
