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
    (0).upto(@board[0].length) { |i| print i }
    print "\n"
    (0).upto(@board.length) do |i|
      row = i + @board[i].map { |player| j.nil? ? "+" : player_marks[player] }.join("")
      row += "\t\t#{@player_name[i]} mark: #{@player_marks[i]}" if @player_name[i]
      puts row
    end
  end

  def print_game_result
    if @winner.nil?
      puts "No winners!"
    else
      puts "Player #{@player_name[@winner]} Win the game!"
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
    puts "Player #{@player_name[@current_player]} turn. Type x,y coordinate on board: "
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
    axis[:vertical] += count_line_elements(x, y) { |x, y| [x, y - 1] }
    axis[:horizontal] += count_line_elements(x, y) { |x, y| [x + 1, y] }
    axis[:horizontal] += count_line_elements(x, y) { |x, y| [x - 1, y] }
    axis[:left_right_diagonal] += count_line_elements(x, y) { |x, y| [x + 1, y + 1] }
    axis[:left_right_diagonal] += count_line_elements(x, y) { |x, y| [x - 1, y - 1] }
    axis[:right_left_diagonal] += count_line_elements(x, y) { |x, y| [x + 1, y - 1] }
    axis[:right_left_diagonal] += count_line_elements(x, y) { |x, y| [x - 1, y + 1] }
    axis.max
  end

  def count_line_elements(x, y)
    point_player = @board[y][x]
    target_player = point_player
    accumulator = 0
    while point_player == target_player
      accumulator += 1
      x, y = yield(x, y)
      target_player = @board.dig(y, x)
    end
    accumulator
  end
end