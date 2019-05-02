require_relative 'piece'

# Handles the creation of the King chess pieces
class King < Piece
  attr_reader :move_set,
              :icon,
              :checkmate,
              :checkmate_bools,
              :checkmate_result

  def initialize(color)
    super(color)
    @icon = set_icon
    @move_set = [
      [1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]
    ].freeze
    @checkmate = []
    @checkmate_bools = [
      method(:top),
      method(:upper_right),
      method(:right),
      method(:bottom_right),
      method(:bottom),
      method(:bottom_left),
      method(:left),
      method(:upper_left),
      method(:knight_check)
    ]
    @checkmate_result = []
  end

  def check(board, king_location)
    checkmate_bools.map do |bool|
      checkmate.clear
      bool.call(board, king_location)
    end
  end

  def checkmate?(board, start_location)
    create_moves(start_location)
    moves.reject! { |move| move.include?(nil) }
    moves.reject! { |move| !board.find(move).piece.nil? if board.find(move).respond_to?(:piece) }
    bool = []

    moves.sort.each do |move|
      board.find(move).piece = dup
      checkmate_result << board.find(move).piece.check(board, move)
      board.find(move).piece = nil
    end

    if checkmate_result.empty?
      bool << false
    else
      checkmate_result.each do |res|
        bool << res.any?
      end
    end

    moves.clear
    checkmate_result.clear
    bool.all?
  end

  def prevent_move_into_check(board, start_location)
    create_moves(start_location)
    moves.reject! { |move| move.include?(nil) }
    moves.reject! { |move| !board.find(move).piece.nil? if board.find(move).respond_to?(:piece) }

    moves.sort.each do |move|
      board.find(move).piece = dup
      checkmate_result << move if board.find(move).piece.check(board, move).none?
      board.find(move).piece = nil
    end

    checkmate_result
  end

  private

  def set_icon
    color == 'white' ? "\u265A" : "\u2654"
  end

  def upper_right(board, king_location)
    (king_location[0]..7).each.with_index do |_range, i|
      checkmate << [king_location[0] + i, king_location[1] + i] unless i.zero?
    end

    piece_in_path(board)
  end

  def upper_left(board, king_location)
    (king_location[0]..7).reverse_each.with_index do |_range, i|
      checkmate << [king_location[0] + i, king_location[1] - i] unless i.zero?
    end

    piece_in_path(board)
  end

  def bottom_right(board, king_location)
    king_location[0].downto(0).each.with_index do |_range, i|
      checkmate << [king_location[0] - i, king_location[1] + i] unless i.zero?
    end

    piece_in_path(board)
  end

  def bottom_left(board, king_location)
    king_location[0].downto(0).reverse_each.with_index do |_range, i|
      checkmate << [king_location[0] - i, king_location[1] - i] unless i.zero?
    end

    piece_in_path(board)
  end

  def top(board, king_location)
    (king_location[0]..7).each.with_index do |range, i|
      checkmate << [range, king_location[1]] unless i.zero?
    end

    piece_in_path(board)
  end

  def bottom(board, king_location)
    king_location[0].downto(0).each.with_index do |range, i|
      checkmate << [range, king_location[1]] unless i.zero?
    end

    piece_in_path(board)
  end

  def right(board, king_location)
    (king_location[1]..7).each.with_index do |range, i|
      checkmate << [king_location[0], range] unless i.zero?
    end

    piece_in_path(board)
  end

  def left(board, king_location)
    king_location[1].downto(0).each.with_index do |range, i|
      checkmate << [king_location[0], range] unless i.zero?
    end

    piece_in_path(board)
  end

  def knight_check(board, king_location)
    knight = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]

    knight.each do |move|
      checkmate << [move[0] + king_location[0], move[1] + king_location[1]]
    end

    piece_in_path(board)
  end

  def valid_path
    checkmate.reject! do |location|
      location if location[0] < 0 || location[0] > 7 || location[1] < 0 || location[1] > 7
    end
  end

  def piece_in_path(board)
    valid_path
    valid = []

    checkmate.each do |location|
      chain = []

      caller_locations.each do |caller|
        chain << caller.label
      end

      valid << location if board.find(location).respond_to?(:piece) &&
                           board.find(location).piece.respond_to?(:color) &&
                           board.find(location).piece.color != color

      opponent_first_piece = nil
      opponent_first_piece = board.find(valid.first).piece.color unless valid.first.nil?
      blocking_piece = board.find(location).piece.color if board.find(location).respond_to?(:piece) &&
                                                               !board.find(location).piece.nil?
      # Prevents movement from passing opponents first piece
      valid_first_occupied = !board.find(location).piece.nil? if board.find(location).respond_to?(:piece) &&
                                                                     location != valid.first

      next if (opponent_first_piece != color && valid_first_occupied) ||
              (blocking_piece == color && !board.find(location).piece.nil?)

      if (chain.include?('upper_right') ||
         chain.include?('upper_left') ||
         chain.include?('bottom_right') ||
         chain.include?('bottom_left')) &&
         (board.find(valid.first).respond_to?(:piece) &&
         board.find(valid.first).piece.respond_to?(:color) &&
         board.find(valid.first).piece.color != color) &&
         (board.find(valid.first).piece.class.to_s == 'Bishop' ||
         board.find(valid.first).piece.class.to_s == 'Queen')

        return true
      elsif (chain.include?('right') ||
            chain.include?('left') ||
            chain.include?('top') ||
            chain.include?('bottom')) &&
            (board.find(valid.first).respond_to?(:piece) &&
            board.find(valid.first).piece.respond_to?(:color) &&
            board.find(valid.first).piece.color != color) &&
            (board.find(valid.first).piece.class.to_s == 'Rook' ||
            board.find(valid.first).piece.class.to_s == 'Queen')

        return true
      elsif chain.include?('knight_check') &&
            (board.find(valid.first).respond_to?(:piece) &&
            board.find(valid.first).piece.respond_to?(:color) &&
            board.find(valid.first).piece.color != color) &&
            board.find(valid.first).piece.class.to_s == 'Knight'

        return true
      end
    end

    false
  end
end
