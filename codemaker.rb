class CodeMaker
  attr_accessor :code
  def initialize(size)
    @colors = ["yellow", "red", "orange", "blue", "green", "white"]
    @code = generateNewCode(size)
    @codeHash = generateCodeHash(@code)
  end

  def generateNewCode(size)
    code = []
    size.times do 
      code_number = rand(6)
      code << @colors[code_number]
    end
    return code
  end

  def generateNewCode!(size)
    @code = generateNewCode(size)
  end

  def generateCodeHash(code)
    codeHash = {}
    code.each do |color|
      if codeHash[color.to_sym] == nil
        codeHash[color.to_sym] = 1
      else
        codeHash[color.to_sym] += 1
      end
    end
    codeHash
  end

  def resultColor(color, i)
    if color == @code[i]
      return "red"
    elsif @code.include?(color)
      return "white"
    else
      return "blank"
    end
  end

  def analyzeGuess(guess)
    result = []
    countedHash = {}
    i = 0
    guess.each do |color|
      if countedHash[color.to_sym] == nil
        countedHash[color.to_sym] = 1
        result << resultColor(color, i)
      elsif @codeHash[color.to_sym] == nil
        result << "blank"
      elsif countedHash[color.to_sym] < @codeHash[color.to_sym]
        countedHash[color.to_sym] += 1
        result << resultColor(color, i)
      else
        result << "blank"
      end
      i += 1
    end
    return randomizeResults(result)
  end

  def randomizeResults(results)
    randResults = []
    iterations = results.length
    iterations.times do
      number = rand(results.length)
      randResults << results[number]
      results.delete_at(number)
    end
    return randResults
  end
end