class Player
  attr_accessor :name, :score
  def initialize(name)
    @name = name
    @score = 0
  end

  def name
    @name.downcase.capitalize
  end
end