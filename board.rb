require_relative "row"

class Board
  attr_accessor :size, :rows, :results
  def initialize(size)
    @size = size
    @rows = []
    @size.times {@rows << Row.new(4)}
    @results = []
    @size.times {@results << Row.new(4)}
  end

  def draw
    print "\n"
    puts "              `````````````````````````````````````````````````````````````````````````````````````````````"
    puts "              |                  Guesses                 |  |  |                 Results                  |"
    puts "              `````````````````````````````````````````````````````````````````````````````````````````````"
    (@size - 1).times do |i|
      if i >= 9
        print "            #{i + 1}"
      else
        print "             #{i + 1}"
      end
      @rows[i].cells.each do |cell|
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
end