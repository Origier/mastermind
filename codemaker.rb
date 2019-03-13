class CodeMaker
  attr_accessor :code
  def initialize(size)
    @colors = ["yellow", "red", "orange", "blue", "green", "white"]
    @code = generateNewCode(size)
  end

  def generateNewCode(size)
    code = []
    size.times do 
      code_number = rand(6)
      code << @colors[code_number]
    end
    return code
  end
end