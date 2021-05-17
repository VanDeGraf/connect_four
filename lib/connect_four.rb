class ConnectFour
  def initialize
    @board = [[]]
    @winner = nil
    @player_names = []
    @current_player = 0
  end

  def print_game_status
    player_marks = ["O", "X"]
    print " "
    (0).upto(@board[0].length - 1) { |i| print i }
    print "\n"
    (0).upto(@board.length - 1) do |i|
      row = i.to_s + @board[i].map { |player| player.nil? ? "+" : player_marks[player] }.join("")
      row += "\t\t#{@player_names[i]} mark: #{player_marks[i]}" if @player_names[i]
      puts row
    end
  end

  def print_game_result
    if @winner.nil?
      puts "No winners!"
    else
      puts "Player #{@player_names[@winner]} Win the game!"
    end
  end

  def player_name_input
    input = gets.chomp
    until input.length >= 3
      puts "Wrong input! Name length must more than 2! Type right: "
      input = gets.chomp
    end
    input
  end

  def board_size_input
    input = gets.chomp
    until input.match?(/^\d+$/) && input.to_i >= 4
      puts "Wrong input! Type integer less then 4: "
      input = gets.chomp
    end
    input.to_i
  end

  def introdution
    puts "Welcome to Connect Four game!"

    puts "Player 1, say your name: "
    @player_names << player_name_input
    puts "Player 2, say your name: "
    @player_names << player_name_input

    puts "Type board width: "
    width = board_size_input
    puts "Type board height: "
    height = board_size_input
    @board = Array.new(height) { Array.new(width, nil) }

    print_game_status
  end

  def player_turn_input
    input = gets.chomp
    until input.match?(/^\d+ \d+$/) &&
          input.split.map { |s| s.to_i }[0].between?(0, @board[0].length) &&
          input.split.map { |s| s.to_i }[1].between?(0, @board.length)
      puts "Wrong input! Type x,y coordinate on board: "
      input = gets.chomp
    end
    input.split.map { |s| s.to_i }
  end

  def player_turn
    puts "Player #{@player_names[@current_player]} turn. Type x,y coordinate on board: "
    x, y = player_turn_input
    until @board[y][x].nil?
      puts "Coordinate is already occupied! Type another: "
      x, y = player_turn_input
    end
    @board[y][x] = @current_player
    @current_player = @current_player == 0 ? 1 : 0
  end

  def count_elements_in_row_from_point(x, y)
    point_player = @board[y][x]
    return 0 if point_player.nil?
    axis = {
      vertical: 0,
      horizontal: 0,
      left_right_diagonal: 0,
      right_left_diagonal: 0,
    }
    axis[:vertical] += count_line_elements(x, y) { |xx, yy| [xx, yy + 1] }
    axis[:vertical] += count_line_elements(x, y) { |xx, yy| [xx, yy - 1] } - 1
    axis[:horizontal] += count_line_elements(x, y) { |xx, yy| [xx + 1, yy] }
    axis[:horizontal] += count_line_elements(x, y) { |xx, yy| [xx - 1, yy] } - 1
    axis[:left_right_diagonal] += count_line_elements(x, y) { |xx, yy| [xx + 1, yy + 1] }
    axis[:left_right_diagonal] += count_line_elements(x, y) { |xx, yy| [xx - 1, yy - 1] } - 1
    axis[:right_left_diagonal] += count_line_elements(x, y) { |xx, yy| [xx + 1, yy - 1] }
    axis[:right_left_diagonal] += count_line_elements(x, y) { |xx, yy| [xx - 1, yy + 1] } - 1
    axis.values.max
  end

  def game_end?
    win_line_length = 4
    has_empty_cell = false
    @board.each_with_index do |row, y|
      row.each_with_index do |player, x|
        has_empty_cell |= @board[y][x].nil?
        max_line_length = count_elements_in_row_from_point(x, y)
        if max_line_length >= win_line_length
          @winner = player
          return true
        end
      end
    end
    has_empty_cell ? false : true
  end

  def play_game
    introdution
    until game_end?
      player_turn
      print_game_status
    end
    print_game_result
  end

  private

  def count_line_elements(x, y)
    point_player = @board[y][x]
    target_player = point_player
    accumulator = 0
    while point_player == target_player
      accumulator += 1
      x, y = yield(x, y)
      if x < 0 || y < 0
        target_player = nil
      else
        target_player = @board.dig(y, x)
      end
    end
    accumulator
  end
end

# ConnectFour.new.play_game
