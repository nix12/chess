require 'pg'
require 'date'
require 'singleton'

# Method definition for saving chess games
class SaveMechanics
  include Singleton

  attr_accessor :conn

  def initialize
    setup_database unless system('psql -lqt postgresql://postgres:postgres@localhost:5432 | cut -d \| -f 1 | grep -qw chessdb')
    
    name = ENV['RUBY_ENV'] == 'test' ? 'chess_test' : 'chessdb'
    @conn = PG.connect(
      dbname: name, 
      user: "postgres", 
      password: "postgres", 
      port: 5432, 
      host: "localhost"
    )

    surpress_notice
    create_table
  end

  def preserve_turn(player1, player2)
    player1.active = !player1.active
    player2.active = !player2.active
  end

  def from_json!(string)
    JSON.parse(string).each do |var, val|
      if var.is_a?(Hash)
        var.each do |k, v|
          instance_variable_set(k, v)
        end
      end

      instance_variable_set(var, val) unless var.is_a?(Hash)
    end
  end

  def recursive_formatting(hash)
    my_hash = {}

    hash.each do |k, v|
      my_hash[convert_to_symbol(k)] = if v.is_a?(Hash)
        recursive_formatting(v)
      elsif v.is_a?(Array)
        v.each.with_index do |h, i|
          v[i] = recursive_formatting(h) if h.is_a?(Hash)
        end
      else
        v
      end
    end

    my_hash
  end

  # Removes the @ from them instance variable to the symbol can be used.
  # Otherwise, the instance variable will look like ':@symbol' and cannot
  # be used with loading a saved game.
  def convert_to_symbol(instance_variable)
    instance_variable.delete('@').to_sym
  end

  def create_table
    conn.exec(
      'CREATE TABLE IF NOT EXISTS chess(
        Id SERIAL PRIMARY KEY,
        Board TEXT,
        Player1 TEXT,
        Player2 TEXT,
        Created_at TIMESTAMP,
        Updated_at TIMESTAMP
      )'
    )
  end

  def surpress_notice
    conn.exec("SELECT set_config('client_min_messages', 'error', false)")
  end

  def number_of_saved_games
    res = conn.exec(
      'SELECT COUNT(*)
      FROM chess'
    )

    res[0]['count'].to_i
  end

  def check_if_posgresql_is_installed
    if system('which psql')
      puts 'Postgresql database found.'
      true
    else
      puts 'Please install postgresql before running.'
      exit(0)
    end
  end

  def setup_database
    if check_if_posgresql_is_installed
      puts 'Creating database cluster.'

      if system('psql postgresql://postgres:postgres@localhost:5432 -c "CREATE DATABASE chessdb"')
        puts'Cluster created.'
      else
        puts'Cluster creation failed.'
      end
    else
      puts 'Could not find psql command.'
    end
  end

  def save(board, player1, player2, created_at, updated_at)
    if number_of_saved_games >= 10
      puts 'You have exceeded the maximum number games of 10.'
      puts 'Would you like to delete a previously saved game'
      puts 'Enter (yes) or (no)'
      p SaveMechanics.list_games
      answer = $stdin.gets.chomp.to_s

      if answer == 'yes'
        list_games

        puts 'Please enter ID of game you would like to delete'
        id = $stdin.gets.to_i

        delete(id)

        puts "Game #{ id } has been deleted."
        puts 'Saving your game.'

        conn.exec_params(
          'INSERT INTO chess (board, player1, player2, created_at, updated_at)
          VALUES ($1, $2, $3, $4, $5)',
          [board, player1, player2, created_at, updated_at]
        )

        puts 'Your game has been saved.'

        disconnect if ENV['RUBY_ENV'] != 'test'
        exit(0)
      else
        puts 'Unable to save game.'
        return false
      end
    else
      puts 'Saving your game.'

      conn.exec_params(
        'INSERT INTO chess (board, player1, player2, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5)',
        [board, player1, player2, created_at, updated_at]
      )

      puts 'Your game has been saved.'

      disconnect if ENV['RUBY_ENV'] != 'test'
      exit(0)
    end
  end

  def delete(id)
    conn.exec_params(
      'DELETE FROM chess
      WHERE id = $1',
      [id]
    )
  end

  def load(id)
    res = conn.exec_params(
      'SELECT *
      FROM chess
      WHERE id = $1',
      [id]
    )

    res.map do |data|
      [data['board'], data['player1'], data['player2'], data['created_at']]
    end
  end

  def update(id, board, player1, player2, updated_at)
    conn.exec_params(
      'UPDATE chess
      SET board = $2, player1 = $3, player2 = $4, updated_at = $5
      WHERE id = $1',
      [id, board, player1, player2, updated_at]
    )

    puts 'Your game has been saved.'

    disconnect if ENV['RUBY_ENV'] != 'test'
    exit(0)
  end

  def list_games
    res = conn.exec(
      'SELECT *
      FROM chess
      ORDER BY Id ASC'
    )

    if res.ntuples.zero?
      puts 'There are no saved games at this time.'
      puts 'Exiting'
      exit(0)
    else
      puts 'ID      Player1   Player2    Created at               Updated at'
      res.map do |data|
        str = "#{ data['id'] }" +
              "#{ JSON.parse(data['player1'])['@name'].rjust(11) }" +
              "#{ JSON.parse(data['player2'])['@name'].rjust(11) }" +
              "#{ data['created_at'].rjust(25) }" +
              "#{ data['updated_at'].rjust(25) }"

        puts str
      end
    end
  end

  def disconnect
    puts 'Exiting.'
    conn.close
  end
end
