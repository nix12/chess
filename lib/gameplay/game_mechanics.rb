require 'singleton'

# Contains methods for general gameplay
class GameMechanics
  include Singleton

  attr_accessor :conversion

  def initialize
    @conversion = {
      a: 1,
      b: 2,
      c: 3,
      d: 4,
      e: 5,
      f: 6,
      g: 7,
      h: 8
    }.freeze
  end

  def select_piece(board, start_location, end_location)
    start_piece = board.find(start_location).piece
    destination_piece = board.find(end_location).piece

    if destination_piece.respond_to?(:color)
      if destination_piece.color != start_piece.color
        start_piece.take_piece(board, start_location, end_location)
      end
    else
      start_piece.move(board, start_location, end_location)
    end
  end

  def create_white_player
    puts "Enter first player's name:"
    new_player = $stdin.gets.chomp.to_s

    Player.new(new_player, 'white')
  end

  def create_black_player
    puts "Enter second player's name:"
    new_player = $stdin.gets.chomp.to_s

    Player.new(new_player, 'black')
  end

  def change_turn(board, player1, player2)
    if !player1.active && !player2.active
      player1.active = true
    elsif player1.active
      player1.active = false
      player2.active = true
    elsif player2.active
      player1.active = true
      player2.active = false
    end

    get_enemy_king(board, Player.active_user)
  end

  def get_my_king(board, player)
    king_locations = board.find_by_piece('king')

    king_locations.find do |king|
      board.find(king).piece if board.find(king).piece.color == player.color
    end
  end

  def get_enemy_king(board, player)
    king_locations = board.find_by_piece('king')

    king_locations.find do |king|
      board.find(king).piece if board.find(king).piece.color != player.color
    end
  end

  def has_check?(board, enemy_king)
    board.find(enemy_king).piece.check(board, enemy_king).any?
  end

  def check_prevention(board, enemy_king)
    board.find(enemy_king).piece.prevent_move_into_check(board, enemy_king)
  end

  def has_checkmate?(board, enemy_king)
    king = board.find(enemy_king).piece.check(board, enemy_king).any?
    possible_moves = board.find(enemy_king).piece.checkmate?(board, enemy_king)

    [king, possible_moves].all?
  end

  def error_check?(board, start_location)
    board.find(start_location).piece.error if board.find(start_location).piece.respond_to?(:error)
  end

  def reset_error(board, start_location)
    board.find(start_location).piece.error = false
  end
end
