class ConnectFour
  def initialize
    @board = nil
    @winner = nil
    @player_names = nil
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
end
