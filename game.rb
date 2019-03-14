require_relative "board"
require_relative "codemaker"
require_relative "player"

class Mastermind
  attr_accessor :player, :computer
  def initialize
    @code_maker = CodeMaker.new(4)
    @colors = ["yellow", "red", "orange", "blue", "green", "white", "blank"]
    @valid_commands = ["exit", "start", "codebreaker", "codemaker", "rules"]
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
      until @valid_commands.include?(commands[0])
        puts "Sorry that isn't a valid command, please try again."
        commands = gets.chomp.gsub(/\s+/, ",").gsub(/,+/, ",").split(",")
      end
    elsif commands.length > 1 and commands.length < 4
      puts "Sorry that wasn't a valid number of commands, please try again"
      commands = recieveCommands
    elsif commands.length == 4
      commands.each do |command|
        if @colors.include?(command)
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

  def mainScreen(role = "codebreaker")
    if role == "codemaker"
      clearScreen
      displayTitle
      drawBoard
      showCode #create this function when you implemnet the code breaker object.
    elsif role == "codebreaker"
      clearScreen
      displayTitle
      drawBoard
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

  def playGame
    if @new_game
      startUpMenu
      createPlayer
      @new_game = false
      sleep(1)
    end
    until false
      mainScreen
      showScores
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