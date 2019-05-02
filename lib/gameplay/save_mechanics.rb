require 'pg'
require 'date'

# Method definition for saving chess games
module SaveMechanics
  ENV['RUBY_ENV'] == 'test' ? name = ENV['DB_TEST'] : name = ENV['DB_NAME']
  
  CONN = PG.connect(
    dbname: name,
    user: ENV['USERNAME'],
    password: ENV['DB_PASSWORD'],
    host: 'localhost',
    port: 5433
  )

  def self.preserve_turn(player1, player2)
    player1.active = !player1.active
    player2.active = !player2.active
  end

  def self.from_json!(string)
    JSON.parse(string).each do |var, val|
      if var.is_a?(Hash)
        var.each do |k, v|
          instance_variable_set(k, v)
        end
      end

      instance_variable_set(var, val) unless var.is_a?(Hash)
    end
  end

  def self.recursive_formatting(hash)
    my_hash = {}

    hash.each do |k, v|
      my_hash[k.delete('@').to_sym] = if v.is_a?(Hash)
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

  def self.create_table
    CONN.exec(
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

  def self.surpress_notice
    CONN.exec("SELECT set_config('client_min_messages', 'error', false)")
  end

  def self.number_of_saved_games
    res = CONN.exec(
      'SELECT COUNT(*)
      FROM chess'
    )

    res[0]['count'].to_i
  end

  def self.save(board, player1, player2, created_at, updated_at)
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

        CONN.exec_params(
          'INSERT INTO chess (board, player1, player2, created_at, updated_at)
          VALUES ($1, $2, $3, $4, $5)',
          [board, player1, player2, created_at, updated_at]
        )

        puts 'Your game has been saved.'

        SaveMechanics.disconnect if ENV['RUBY_ENV'] != 'test'
        exit(0)
      else
        puts 'Unable to save game.'
        return false
      end
    else
      puts 'Saving your game.'

      CONN.exec_params(
        'INSERT INTO chess (board, player1, player2, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5)',
        [board, player1, player2, created_at, updated_at]
      )

      puts 'Your game has been saved.'

      SaveMechanics.disconnect if ENV['RUBY_ENV'] != 'test'
      exit(0)
    end
  end

  def self.delete(id)
    CONN.exec_params(
      'DELETE FROM chess
      WHERE id = $1',
      [id]
    )
  end

  def self.load(id)
    res = CONN.exec_params(
      'SELECT *
      FROM chess
      WHERE id = $1',
      [id]
    )

    res.map do |data|
      [data['board'], data['player1'], data['player2'], data['created_at']]
    end
  end

  def self.update(id, board, player1, player2, updated_at)
    CONN.exec_params(
      'UPDATE chess
      SET board = $2, player1 = $3, player2 = $4, updated_at = $5
      WHERE id = $1',
      [id, board, player1, player2, updated_at]
    )

    puts 'Your game has been saved.'

    SaveMechanics.disconnect if ENV['RUBY_ENV'] != 'test'
    exit(0)
  end

  def self.list_games
    res = CONN.exec(
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

  def self.disconnect
    puts 'Exiting.'
    CONN.close
  end
end
