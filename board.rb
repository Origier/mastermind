require_relative "row"

class Board
  attr_accessor :size, :guesses, :results, :current_guess
  def initialize(size)
    @size = size
    @guesses = []
    @size.times {@guesses << Row.new(4)}
    @results = []
    @size.times {@results << Row.new(4)}
    @current_guess = 0
    @current_result = 0
  end

  def draw
    print "\n"
    puts "              `````````````````````````````````````````````````````````````````````````````````````````````"
    puts "              |                  Guesses                 |  |  |                 Results                  |"
    puts "              `````````````````````````````````````````````````````````````````````````````````````````````"
    @size.times do |i|
      if i >= 9
        print "            #{i + 1}"
      else
        print "             #{i + 1}"
      end
      @guesses[i].cells.each do |cell|
        print "| #{cell.color} |"
      end
      print "  |  "
      @results[i].cells.each do |cell|
        print "| #{cell.color} |"
      end
      print "\n\n"
    end
    puts "              `````````````````````````````````````````````````````````````````````````````````````````````"
  end

  def makeGuess(guess)
    @guesses[@current_guess].cells[0].color = guess[0].downcase
    @guesses[@current_guess].cells[1].color = guess[1].downcase
    @guesses[@current_guess].cells[2].color = guess[2].downcase
    @guesses[@current_guess].cells[3].color = guess[3].downcase
    @current_guess += 1
  end

  def enterResults(results)
    @results[@current_result].cells[0].color = results[0].downcase
    @results[@current_result].cells[1].color = results[1].downcase
    @results[@current_result].cells[2].color = results[2].downcase
    @results[@current_result].cells[3].color = results[3].downcase
    @current_result += 1
  end

  def reset
    @guesses = []
    @size.times {@guesses << Row.new(4)}
    @results = []
    @size.times {@results << Row.new(4)}
    @current_guess = 0
    @current_result = 0
  end
end