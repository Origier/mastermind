require_relative "board"
require_relative "codemaker"
code_maker = CodeMaker.new(4)
board = Board.new(12)

12.times do
  system "clear" or system "cls"
  code = code_maker.generateNewCode(4)
  board.makeGuess(code)
  board.draw
  sleep(1)
  system "clear" or system "cls"
  board.enterResults(code_maker.analyzeGuess(code))
  board.draw
end
puts code_maker.code
