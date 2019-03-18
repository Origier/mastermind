class CodeBreaker
  attr_accessor :guess
  def initialize
    @colors = ["yellow", "red", "orange", "blue", "green", "white"]
    @guesses = []
    @color_probability = {}
    @colors.each do |color|
      @color_probability[color.to_sym] = {chance: 16.66, location: {slot0: 25, slot1: 25, slot2, 25, slot3: 25}}
    end
  end

  def guess
    guess = []
    if @guesses.length == 0
      code_index = rand(6)
      4.times do
        guess << @colors[code_index]
      end
      return guess
    else

    end
  end

  def recieveResults
    
  end
end