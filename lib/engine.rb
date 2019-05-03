#!/usr/bin/env ruby
require 'dotenv/load'
Dotenv.load('db/settings.env')
require_relative 'board/board'
require_relative 'board/setup_board'
require_relative 'board/setup_display'
require_relative 'player/player'
require_relative 'gameplay/game_mechanics'
require_relative 'gameplay/save_mechanics'
require 'date'

SaveMechanics.surpress_notice
SaveMechanics.create_table

puts 'Press any other button to start a new game.'
puts 'Enter 1 to load a previous game.'
answer = $stdin.gets.chomp

if answer == '1'
  SaveMechanics.list_games

  puts 'Enter ID of previous board you would like to play'
  id = $stdin.gets.chomp

  data = SaveMechanics.load(id)

  saved_player1 = Hash[SaveMechanics.from_json!(data[0][1]).map do |k, v|
    [k.delete('@').to_sym, v]
  end]

  saved_player2 = Hash[SaveMechanics.from_json!(data[0][2]).map do |k, v|
    [k.delete('@').to_sym, v]
  end]

  saved_board = Hash[SaveMechanics.recursive_formatting(SaveMechanics.from_json!(data[0][0]))]

  player1 = Player.new(
    saved_player1[:name],
    saved_player1[:color],
    saved_player1[:active],
    saved_player1[:check]
  )

  player2 = Player.new(
    saved_player2[:name],
    saved_player2[:color],
    saved_player2[:active],
    saved_player2[:check]
  )

  saved_board_setup = saved_board[:board].map do |k, _v|
    piece = Object.const_get(k[:piece][:type]) unless k[:piece].nil?
    saved_piece = k[:piece].nil? ? nil : piece.new(k[:piece][:color])
    saved_board[:board][0][k] = Square.new(k[:location], saved_piece)
  end

  board = Board.new(
    saved_board_setup,
    saved_board[:display]
  )

  created_at = DateTime.parse(data[0][3])
else
  # Player setup
  player1 = GameMechanics.create_white_player
  player2 = GameMechanics.create_black_player

  # Board and Display setup
  board = Board.new
  game = SetupBoard.new(board)
  game.setup_board
  display = SetupDisplay.new(board)
  display.setup_display

  created_at = DateTime.parse(DateTime.now.strftime("%b %-d %Y %-l:%M %p"))
end

loop do
  GameMechanics.change_turn(player1, player2)

  # Enemy king location
  enemy_king = GameMechanics.get_enemy_king(board, Player.active_user)

  # board.print_board
  board.print_display
  puts "#{Player.active_user_name}'s turn"

  begin
    puts 'Select chess location you would like to move'
    start_location = $stdin.gets.chomp

    if start_location == 'save'
      SaveMechanics.preserve_turn(player1, player2)

      if created_at < DateTime.parse(DateTime.now.strftime("%b %-d %Y %-l:%M %p"))
        SaveMechanics.update(
          id,
          board.to_json,
          player1.to_json,
          player2.to_json,
          DateTime.now.strftime("%b %-d %Y %-l:%M %p")
        )
      else
        SaveMechanics.save(
          board.to_json,
          player1.to_json,
          player2.to_json,
          DateTime.now.strftime("%b %-d %Y %-l:%M %p"),
          DateTime.now.strftime("%b %-d %Y %-l:%M %p")
        ) || redo
      end
    else
      start_location = start_location.split(',')
      start_location.map.with_index do |num, i|
        next if i.zero? && num.is_a?(String)
        next if i == 1 && num.is_a?(Integer)

        start_location[0] = Integer(GameMechanics::CONVERSION[start_location[0].to_sym])
        start_location[1] = Integer(start_location[1])
        [start_location[1], start_location[0]]
      end
    end
  rescue ArgumentError
    retry
  end

  begin
    puts 'Where would you like to move to'
    end_location = $stdin.gets.chomp

    if end_location == 'save'
      SaveMechanics.preserve_turn(player1, player2)

      if created_at < DateTime.parse(DateTime.now.strftime("%b %-d %Y %-l:%M %p"))
        SaveMechanics.update(
          id,
          board.to_json,
          player1.to_json,
          player2.to_json,
          DateTime.now.strftime("%b %-d %Y %-l:%M %p")
        )
      else
        SaveMechanics.save(
          board.to_json,
          player1.to_json,
          player2.to_json,
          DateTime.now.strftime("%b %-d %Y %-l:%M %p"),
          DateTime.now.strftime("%b %-d %Y %-l:%M %p")
        ) || redo
      end
    else
      end_location = end_location.split(',')
      end_location.map.with_index do |num, i|
        next if i.zero? && num.is_a?(String)
        next if i == 1 && num.is_a?(Integer)

        end_location[0] = Integer(GameMechanics::CONVERSION[end_location[0].to_sym])
        end_location[1] = Integer(end_location[1])
        [end_location[1], end_location[0]]
      end
    end
  rescue ArgumentError
    retry
  end

  GameMechanics.reset_error(board, start_location)
  GameMechanics.select_piece(board, start_location, end_location) unless Player.active_user.check
  Player.inactive_user.check = true if GameMechanics.has_check?(board, enemy_king)

  if Player.inactive_user.check
    GameMechanics.change_turn(player1, player2)
    my_king = GameMechanics.get_my_king(board, Player.active_user)

    catch(:done) do
      loop do
        display.gameboard.print_display

        puts "#{Player.active_user_name}'s turn"
        puts 'Please move your king that is in check'

        puts 'Select chess location you would like to move'
        king_start_location = gets.chomp.split(',').flatten.map(&:to_i)

        puts 'Where would you like to move to'
        king_end_location = gets.chomp.split(',').flatten.map(&:to_i)

        if GameMechanics.check_prevention(board, enemy_king).include?(king_end_location)
          GameMechanics.select_piece(board, king_start_location, king_end_location)
          throw(:done) if king_start_location == my_king
        else
          next
        end
      end
    end
  end

  enemy_king = GameMechanics.get_enemy_king(board, Player.active_user)
  GameMechanics.change_turn(player1, player2) if GameMechanics.error_check?(board, start_location)

  puts "#{Player.inactive_user_name} is in checkmate" if GameMechanics.has_checkmate?(board, enemy_king)
end
