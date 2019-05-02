# Contains methods for general gameplay
module GameMechanics
  def self.select_piece(board, start_location, end_location)
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

  def self.create_white_player
    puts "Enter first player's name:"
    new_player = $stdin.gets.chomp.to_s

    Player.new(new_player, 'white')
  end

  def self.create_black_player
    puts "Enter second player's name:"
    new_player = $stdin.gets.chomp.to_s

    Player.new(new_player, 'black')
  end

  def self.change_turn(player1, player2)
    if !player1.active && !player2.active
      player1.active = true
    elsif player1.active
      player1.active = false
      player2.active = true
    elsif player2.active
      player1.active = true
      player2.active = false
    end
  end

  def self.get_my_king(board, player)
    king_locations = board.find_by_piece('king')

    king_locations.find do |king|
      board.find(king).piece if board.find(king).piece.color == player.color
    end
  end

  def self.get_enemy_king(board, player)
    king_locations = board.find_by_piece('king')

    king_locations.find do |king|
      board.find(king).piece if board.find(king).piece.color != player.color
    end
  end

  def self.has_check?(board, enemy_king)
    board.find(enemy_king).piece.check(board, enemy_king).any?
  end

  def self.check_prevention(board, enemy_king)
    board.find(enemy_king).piece.prevent_move_into_check(board, enemy_king)
  end

  def self.has_checkmate?(board, enemy_king)
    king = board.find(enemy_king).piece.check(board, enemy_king).any?
    possible_moves = board.find(enemy_king).piece.checkmate?(board, enemy_king)

    [king, possible_moves].all?
  end

  def self.error_check?(board, start_location)
    board.find(start_location).piece.error if board.find(start_location).piece.respond_to?(:error)
  end

  def self.reset_error(board, start_location)
    board.find(start_location).piece.error = false
  end
end
