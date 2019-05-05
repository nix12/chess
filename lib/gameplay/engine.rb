require_relative '../board/board'
require_relative '../board/setup_board'
require_relative '../board/setup_display'
require_relative '../player/player'
require_relative 'game_mechanics'
require_relative 'save_mechanics'
require 'date'

class Engine
  attr_accessor :game_mechanics,
                :save_mechanics,
                :data,
                :board,
                :player1,
                :player2,
                :created_at,
                :id

  def initialize
    @game_mechanics = GameMechanics.instance
    @save_mechanics = SaveMechanics.instance
  end

  def load_player1
    saved_player1 = Hash[save_mechanics.from_json!(data[0][1]).map do |k, v|
      [save_mechanics.convert_to_symbol(k), v]
    end]

    @player1 = Player.new(
      saved_player1[:name],
      saved_player1[:color],
      saved_player1[:active],
      saved_player1[:check]
    )
  end

  def load_player2
    saved_player2 = Hash[save_mechanics.from_json!(data[0][2]).map do |k, v|
      [save_mechanics.convert_to_symbol(k), v]
    end]

    @player2 = Player.new(
      saved_player2[:name],
      saved_player2[:color],
      saved_player2[:active],
      saved_player2[:check]
    )
  end

  def load_saved_board
    saved_board = Hash[save_mechanics.recursive_formatting(save_mechanics.from_json!(data[0][0]))]

    saved_board_setup = saved_board[:board].map do |k, _v|
      piece = Object.const_get(k[:piece][:type]) unless k[:piece].nil?
      saved_piece = k[:piece].nil? ? nil : piece.new(k[:piece][:color])
      saved_board[:board][0][k] = Square.new(k[:location], saved_piece)
    end

    @board = Board.new(saved_board_setup, saved_board[:display])
  end

  def load_date
    @created_at = DateTime.parse(data[0][3])
  end

  def start
    puts '(1) To start a new game.'
    puts '(2) To load a previous game.'
    puts '(3) To exit game.'
    answer = $stdin.gets.chomp

    begin
      if answer == '1'
        new_game
        play
      elsif answer == '2'
        save_mechanics.list_games
        puts 'Enter ID of previous board you would like to play'
        @id = $stdin.gets.chomp
        @data = save_mechanics.load(id)
        load_game
        play
      elsif answer == '3'
        puts 'Goodbye.'
        exit(0)
      else
        raise ArgumentError, 'That is not an option.'
      end
    rescue ArgumentError
      retry
    end
  end

  def new_game
    # Player setup.
    @player1 = game_mechanics.create_white_player
    @player2 = game_mechanics.create_black_player

    # Board and Display setup.
    @board = Board.new
    game = SetupBoard.new(board)
    game.setup_board
    display = SetupDisplay.new(board)
    display.setup_display

    # Create new formatted date show when a new game was made.
    @created_at = DateTime.parse(DateTime.now.strftime("%b %-d %Y %-l:%M %p"))
  end

  def load_game
    load_saved_board
    load_player1
    load_player2
    load_date
  end

  def retrieve_location(location)
    location = location.split(',')
    location.map.with_index do |num, i|
      next if i.zero? && num.is_a?(String)
      next if i == 1 && num.is_a?(Integer)

      location[0] = Integer(game_mechanics.conversion[location[0].to_sym])
      location[1] = Integer(location[1])
      [location[1], location[0]]
    end

    location
  end

  def save_or_update_game
    if created_at < DateTime.parse(DateTime.now.strftime("%b %-d %Y %-l:%M %p"))
      save_mechanics.update(
        id,
        board.to_json,
        player1.to_json,
        player2.to_json,
        DateTime.now.strftime("%b %-d %Y %-l:%M %p")
      )
    else
      save_mechanics.save(
        board.to_json,
        player1.to_json,
        player2.to_json,
        DateTime.now.strftime("%b %-d %Y %-l:%M %p"),
        DateTime.now.strftime("%b %-d %Y %-l:%M %p")
      )
    end
  end

  def move_piece
    begin
      location = $stdin.gets.chomp

      if location == 'save'
        save_mechanics.preserve_turn(player1, player2)
        save_or_update_game
      else
        retrieve_location(location)
      end
    rescue ArgumentError
      retry
    end
  end

  def play
    loop do
      enemy_king = game_mechanics.change_turn(board, player1, player2)
      board.print_display
      puts "#{Player.active_user_name}'s turn"

      puts 'Select chess piece you would like to move'
      start_location = move_piece

      puts 'Select location you would like to move to'
      end_location = move_piece

      game_mechanics.reset_error(board, start_location)
      game_mechanics.select_piece(board, start_location, end_location) unless Player.active_user.check
      Player.inactive_user.check = true if game_mechanics.has_check?(board, enemy_king)

      inactive_check

      if game_mechanics.error_check?(board, start_location)
        enemy_king = game_mechanics.change_turn(player1, player2)
      end

      if game_mechanics.has_checkmate?(board, enemy_king)
        puts "#{Player.inactive_user_name} is in checkmate"
      end
    end
  end

  def inactive_check
    if Player.inactive_user.check
      enemy_king = game_mechanics.change_turn(board, player1, player2)
      my_king = game_mechanics.get_my_king(board, Player.active_user)

      loop do
        board.print_display

        puts "#{Player.active_user_name}'s turn"
        puts 'Please move your king that is in check'

        puts "Select your king's location"
        king_start_location = move_piece

        puts 'Select where you would like to move your king'
        king_end_location = move_piece

        if game_mechanics.check_prevention(board, enemy_king).include?(king_end_location)
          game_mechanics.select_piece(board, king_start_location, king_end_location)
          return if king_start_location == my_king
        else
          next
        end
      end
    end
  end
end
