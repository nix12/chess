require_relative 'board'
require_relative '../pieces/knight'
require_relative '../pieces/rook'
require_relative '../pieces/bishop'
require_relative '../pieces/queen'
require_relative '../pieces/king'
require_relative '../pieces/pawn'

# Handles "Setup" of the display and placement of the
# chess pieces in the display.
class SetupDisplay
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

  # Setup display of the full chess board

  def setup_display
    gameboard.build_display
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
    gameboard.display[0][1] = white_knight.icon
    gameboard.display[0][6] = white_knight.icon
  end

  def create_white_rooks
    gameboard.display[0][0] = white_rook.icon
    gameboard.display[0][7] = white_rook.icon
  end

  def create_white_bishops
    gameboard.display[0][2] = white_bishop.icon
    gameboard.display[0][5] = white_bishop.icon
  end

  def create_white_queen
    gameboard.display[0][3] = white_queen.icon
  end

  def create_white_king
    gameboard.display[0][4] = white_king.icon
  end

  def create_white_pawns
    8.times do |space|
      gameboard.display[1][space] = white_pawn.icon
    end
  end

  # Black pieces

  def build_black_side
    create_black_knights
    create_black_rooks
    create_black_bishops
    create_black_queen
    create_black_king
    create_black_pawns
  end

  def create_black_knights
    gameboard.display[7][1] = black_knight.icon
    gameboard.display[7][6] = black_knight.icon
  end

  def create_black_rooks
    gameboard.display[7][0] = black_rook.icon
    gameboard.display[7][7] = black_rook.icon
  end

  def create_black_bishops
    gameboard.display[7][2] = black_bishop.icon
    gameboard.display[7][5] = black_bishop.icon
  end

  def create_black_queen
    gameboard.display[7][3] = black_queen.icon
  end

  def create_black_king
    gameboard.display[7][4] = black_king.icon
  end

  def create_black_pawns
    8.times do |space|
      gameboard.display[6][space] = black_pawn.icon
    end
  end
end
