require_relative "board"
require_relative "codemaker"
require_relative "player"

class Mastermind
  attr_accessor :player, :computer
  def initialize
    @code_maker = CodeMaker.new(4)
    @colors = ["yellow", "red", "orange", "blue", "green", "white", "blank"]
    @valid_commands = ["exit", "start", "codebreaker", "codemaker", "rules", "continue"]
    @computerPlayer = Player.new("Computer")
    @board = Board.new(12)
    @new_game = true
    @rounds = 0
  end

  def displayTitle
    puts "\n"
    puts "                                                        Mastermind"
    puts "\n"
  end

  def createPlayer
    clearScreen
    displayTitle
    puts "Please enter your name and press enter."
    name = gets.chomp.gsub(/\s+/, "")
    if name.length < 1
      until name.length >= 1
        puts "Please enter a valid name to continue."
        name = gets.chomp.gsub(/\s+/, "")
      end
    end
    @player = Player.new(name)
    puts "Welcome to Mastermind #{name.downcase.capitalize}!"
  end

  def recieveCommands
    commands = gets.chomp.gsub(/\s+/, ",").gsub(/,+/, ",").split(",")
    if commands.length == 1
      unless @valid_commands.include?(commands[0])
        puts "Sorry that isn't a valid command, please try again."
        commands = recieveCommands
      end
    elsif commands.length > 1 and commands.length < 4
      puts "Sorry that wasn't a valid number of commands, please try again"
      commands = recieveCommands
    elsif commands.length == 4
      commands.each do |command|
        if @colors.include?(command.downcase)
          next
        else
          puts "Sorry, #{command} is not a valid color, please try again."
          commands = recieveCommands
        end
      end
    else
      puts "Sorry that was incorrect format or too many arguements, please try again."
      commands = recieveCommands
    end
    return interpretCommands(commands)
  end

  def interpretCommands(commands)
    if commands.length == 1
      if commands[0] == "start"
        return commands[0]
      elsif commands[0] == "exit"
        exit
      else
        return commands[0]
      end
    else
      return commands
    end
  end

  def clearScreen
    system "clear" or system "cls"
  end

  def drawBoard
    @board.draw
  end

  def mainScreen(role = :codebreaker)
    if role == :codemaker
      clearScreen
      displayTitle
      drawBoard
      showScores unless @new_game
      showCode #create this function when you implemnet the code breaker object.
    elsif role == :codebreaker
      clearScreen
      displayTitle
      drawBoard
      showScores unless @new_game
    end
  end

  def startUpMenu
    mainScreen
    puts "Welcome to Mastermind Ruby Edition. Type start to begin."
    command = recieveCommands
    if command == "start"
      return true
    else
      exit
    end
  end

  def showScores
    puts "Your Current Score: #{@player.score}                  Computers Current Score: #{@computerPlayer.score}                   Rounds Left: #{@rounds}"
    puts "\n"
  end

  def showRules
    clearScreen
    puts "\n"
    File.open("ReadME.txt").each {|line| puts line}
    sleep(3)
    puts "\n"
    puts "Once you are ready type \"continue\" to go back to the main menu."
    command = recieveCommands
  end

  def codeBroken?(results)
    results.all? {|result| result == "red"}  
  end

  def makeCode

  end

  def breakCode
    @rounds -= 1
    @code_maker.generateNewCode!(4)
    @board.reset
    results = ["blank"]
    turn = 0
    until codeBroken?(results) or @board.current_guess == 12
      mainScreen(:codebreaker)
      puts "Type in a four color guess and press enter, separate each color with a comma or a space. Colors: Yellow, Red, Orange, Blue, Green, White"
      guess = recieveCommands
      @board.makeGuess(guess)
      mainScreen(:codebreaker)
      results = @code_maker.analyzeGuess(guess)
      print "The computer is thinking"
      3.times do
        sleep(1)
        print "."
      end
      @board.enterResults(results)
      turn += 1
      if codeBroken?(results)
        @computerPlayer.score += turn
        mainScreen(:codebreaker)
        puts "Congrats it looks like you have cracked the code and win this round. It took you #{turn} turns to crack the code. Type \"continue\" to go to the next round."
        command = recieveCommands
      elsif turn == 12 and !codeBroken?(results)
        @computerPlayer.score += 13
        mainScreen(:codebreaker)
        puts "Well, looks like you didn't manage to break the code. The actual code was #{@code_maker.code[0].capitalize} #{@code_maker.code[1].capitalize} #{@code_maker.code[2].capitalize} #{@code_maker.code[3].capitalize}. Better luck next time, type \"continue\" to continue to the next round."
        command = recieveCommands
      else
        mainScreen(:codebreaker)
        puts "The computer gives you the results of: #{results[0].capitalize} #{results[1].capitalize} #{results[2].capitalize} #{results[3].capitalize}"
        sleep(3)
      end
    end
  end

  def playAs(role)
    roles = [:codebreaker, :codemaker]
    @player.role = role
    index = roles.index(role)
    @computerPlayer.role = index == 0 ? roles[1] : roles[0]
    mainScreen
    puts "Alright you will be playing as the #{role == :codebreaker ? "Code Breaker" : "Code Maker"}, type how many rounds you would like to play(must be an even number):"
    number = gets.chomp.gsub(/\s+/, "").to_i
    until number % 2 == 0
      puts "Please enter an even number: "
      number = gets.chomp.gsub(/\s+/, "").to_i
    end
    @rounds = number
    if @player.role == :codebreaker
      breakCode
    else
      makeCode
    end
  end

  def playGame
    if @new_game
      startUpMenu
      createPlayer
      @new_game = false
      sleep(1)
    end
    until false
      mainScreen
      puts "Welcome to Mastermind #{@player.name}. This is the main menu where you will decide how you wish to play the game.
Type one of the following gamemodes or rules continue. (codebreaker, codemaker, rules):"
      command = recieveCommands
      until command == "codebreaker" or command == "codemaker" or command == "rules"
        puts "Sorry that wasn't one of the options, please try again."
        command = recieveCommands
      end
      if command == "codebreaker"
        playAs(:codebreaker)
      elsif command == "codemaker"
        playAs(:codemaker)
      else 
        showRules
      end
    end
  end
end