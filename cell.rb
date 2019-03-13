class Cell
  attr_accessor :color
  def initialize(color = "       ")
    @color = color
    @colors = ["yellow", "red", "orange", "blue", "green", "white"]
  end

  def color=(color)
    if @colors.include?(color.downcase)
      case color.downcase
      when "yellow"
        @color = "Yellow "
      when "red"
        @color = "  Red  "
      when "orange"
        @color = "Orange "
      when "blue"
        @color = " Blue  "
      when "green"
        @color = " Green "
      when "white"
        @color = " White "
      end
    else
      puts "Sorry that isn't a valid color."
    end
  end
end