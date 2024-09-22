require_relative '../base/base'

# Handles the Piece parent class that all chess
# pieces will inherit from.
class Piece < Base
  attr_accessor :color, :moves, :error, :count
  attr_reader :type

  def initialize(color)
    @color = color
    @moves = []
    @error = false
    @count = 0
    
    TracePoint.trace(:call) do |tp|
      @count += 1 if tp.method_id == :valid_moves?
      binding
    end
  end

  def add_piece(board, start_location, end_location)
    if create_moves(start_location) && valid_moves?(end_location)
      board.display[end_location[0]][end_location[1]] = icon
      board.find(end_location).piece = self
    end
  end

  def remove_piece(board, start_location, end_location)
    if create_moves(start_location) && valid_moves?(end_location)
      board.display[start_location[0]][start_location[1]] = '*'
      board.find(start_location).piece = nil
    end
  end

  def replace_piece(board, start_location, end_location)
    if create_moves(start_location) && valid_moves?(end_location)
      board.display[end_location[0]][end_location[1]] = '*'
      board.find(end_location).piece = nil

      board.display[end_location[0]][end_location[1]] = icon
      board.find(end_location).piece = self
    end
  end

  def take_piece(board, start_location, end_location)
    if (self.class.to_s == 'Bishop' || self.class.to_s == 'Queen') &&
       ((start_location[0] - end_location[0] > 1 ||
       start_location[0] - end_location[0] < -1) &&
       (start_location[1] - end_location[1] > 1 ||
       start_location[1] - end_location[1] < -1))

      check = ranged_diagonal(board, start_location, end_location)

      replace_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif (self.class.to_s == 'Rook' || self.class.to_s == 'Queen') &&
          (start_location[0] - end_location[0] > 1 ||
          start_location[0] - end_location[0] < -1)

      check = ranged_vertical(board, start_location, end_location)

      replace_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif (self.class.to_s == 'Rook' || self.class.to_s == 'Queen') &&
          (start_location[1] - end_location[1] > 1 ||
          start_location[1] - end_location[1] < -1)

      check = ranged_horizontal(board, start_location, end_location)

      replace_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif self.class.to_s == 'Pawn' &&
          ((start_location[0] - end_location[0] == 1 ||
            start_location[0] - end_location[0] == -1) &&
            (start_location[1] - end_location[1] == 1 ||
            start_location[1] - end_location[1] == -1))

      check = pawn_diagonal(board, start_location, end_location)

      replace_piece(board, start_location, end_location) if check
      remove_piece(board, start_location, end_location) if check
    else
      replace_piece(board, start_location, end_location)
      remove_piece(board, start_location, end_location)
    end

    moves.clear
  end

  def move(board, start_location, end_location)
    if (self.class.to_s == 'Bishop' || self.class.to_s == 'Queen') &&
       ((start_location[0] - end_location[0] > 1 ||
       start_location[0] - end_location[0] < -1) &&
       (start_location[1] - end_location[1] > 1 ||
       start_location[1] - end_location[1] < -1))

      check = ranged_diagonal(board, start_location, end_location)

      add_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif (self.class.to_s == 'Rook' || self.class.to_s == 'Queen') &&
          (start_location[0] - end_location[0] > 1 ||
          start_location[0] - end_location[0] < -1)

      check = ranged_vertical(board, start_location, end_location)

      add_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif (self.class.to_s == 'Rook' || self.class.to_s == 'Queen') &&
          (start_location[1] - end_location[1] > 1 ||
          start_location[1] - end_location[1] < -1)

      check = ranged_horizontal(board, start_location, end_location)

      add_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    elsif self.class.to_s == 'Pawn' &&
          (start_location[0] - end_location[0] == 2 ||
          start_location[0] - end_location[0] == -2)

      check = pawn_two_moves_forward(board, start_location)

      add_piece(board, start_location, end_location) unless check
      remove_piece(board, start_location, end_location) unless check
    else
      add_piece(board, start_location, end_location)
      remove_piece(board, start_location, end_location)
    end

    moves.clear
  end

  def create_moves(start_location)
    move_set.each do |move|
      if start_location[0] + move[0] >= 1 && start_location[0] + move[0] <= 8
        y = start_location[0] + move[0]
      end

      if start_location[1] + move[1] >= 1 && start_location[1] + move[1] <= 8
        x = start_location[1] + move[1]
      end

      moves << [y, x]
    end
  end

  def valid_moves?(end_location)
    moves.reject! { |move| move.include?(nil) }

    if moves.include?(end_location)
      return true
    else
      self.error = true
      puts 'Move INVALID' if count <= 1
      return false
    end
  end

  def ranged_vertical(board, start_location, end_location)
    if start_location[0] > end_location[0]
      start_location[0].downto(end_location[0]).each.with_index do |range, i|
        moves << [range, start_location[1]] unless i.zero?
      end
    else
      (start_location[0]..end_location[0]).each.with_index do |range, i|
        moves << [range, start_location[1]] unless i.zero?
      end
    end

    chain = []

    caller_locations.each do |caller|
      chain << caller.label
    end

    if chain.include?('in_checkmate?')
      false
    else
      check_if_occupied?(board)
    end
  end

  def ranged_horizontal(board, start_location, end_location)
    if start_location[1] > end_location[1]
      start_location[1].downto(end_location[1]).each.with_index do |range, i|
        moves << [start_location[0], range] unless i.zero?
      end
    else
      (start_location[1]..end_location[1]).each.with_index do |range, i|
        moves << [start_location[0], range] unless i.zero?
      end
    end

    chain = []

    caller_locations.each do |caller|
      chain << caller.label
    end

    if chain.include?('in_checkmate?')
      false
    else
      check_if_occupied?(board)
    end
  end

  def ranged_diagonal(board, start_location, end_location)
    if start_location[0] > end_location[0] && start_location[1] > end_location[1]
      start_location[0].downto(end_location[0]).reverse_each.with_index do |_range, i|
        moves << [start_location[0] - i, start_location[1] - i] unless i.zero?
      end
    elsif start_location[0] < end_location[0] && start_location[1] > end_location[1]
      (start_location[0]..end_location[0]).reverse_each.with_index do |_range, i|
        moves << [start_location[0] + i, start_location[1] - i] unless i.zero?
      end
    elsif start_location[0] > end_location[0] && start_location[1] < end_location[1]
      start_location[0].downto(end_location[0]).each.with_index do |_range, i|
        moves << [start_location[0] - i, start_location[1] + i] unless i.zero?
      end
    else
      (start_location[0]..end_location[0]).each.with_index do |_range, i|
        moves << [start_location[0] + i, start_location[1] + i] unless i.zero?
      end
    end

    chain = []

    caller_locations.each do |caller|
      chain << caller.label
    end

    if chain.include?('in_checkmate?')
      return false
    else
      check_if_occupied?(board)
    end
  end

  def check_if_occupied?(board)
    valid = []
    
    moves.each do |move|
      valid << move if board.find(move).respond_to?(:piece) &&
                       board.find(move).piece.respond_to?(:color) &&
                       board.find(move).piece.color != color

      opponent_first_piece = nil
      opponent_first_piece = board.find(valid.first).piece.color unless valid.first.nil?
      blocking_piece = board.find(move).piece.color if board.find(move).respond_to?(:piece) &&
                                                           !board.find(move).piece.nil?

      # Prevents movement from passing opponents first piece
      valid_first_occupied = !board.find(move).piece.nil? if board.find(move).respond_to?(:piece) &&
                                                                 move != valid.first

      next unless (opponent_first_piece != color && valid_first_occupied) ||
                  (blocking_piece == color && !board.find(move).piece.nil?)

      self.error = true
      puts 'Illegal movement'
      return true
    end

    false
  end
end
