require_relative "board"
require_relative "codemaker"

board = Board.new(13)
system "clear" or system "cls"
board.rows[0].cells[0].color = "Blue"
board.rows[0].cells[1].color = "Red"
board.rows[0].cells[2].color = "Orange"
board.rows[0].cells[3].color = "Green"
board.rows[1].cells[2].color = "Yellow"
board.rows[1].cells[3].color = "White"
board.draw

code_maker = CodeMaker.new(4)
puts code_maker.code