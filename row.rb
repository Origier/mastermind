require_relative "cell"

class Row
  attr_accessor :size, :cells
  def initialize(size)
    @size = size
    @cells = []
    @size.times {@cells << Cell.new}
  end
end