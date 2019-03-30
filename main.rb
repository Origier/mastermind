require_relative "game"
require_relative "codebreaker"

puts "How many rounds do you wish to test: "

game = Mastermind.new
#game.playGame
codebreaker = CodeBreaker.new
codemaker = CodeMaker.new(4)
rounds = gets.chomp.to_i
wins = 0

rounds.times do
  12.times do
    puts codemaker.code.to_s + "\n\n"
    guess = codebreaker.guess
    puts guess.to_s + "\n\n"
    results = codemaker.analyzeGuess(guess)
    if game.codeBroken?(results)
      wins += 1
      break
    end
    puts results.to_s + "\n\n"
    codebreaker.recieveResults(results)
    codebreaker.guesses_made += 1
    puts codebreaker.color_probability
  end
  codebreaker.reset
  codemaker.generateNewCode!(4)
end

puts "Out of #{rounds} rounds your AI was able to crack the code #{wins} times. That is a #{((wins.to_f / rounds.to_f) * 100).round(2)}% accuracy."