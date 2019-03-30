require_relative "codemaker"

class CodeBreaker
  attr_accessor :guess, :color_probability, :guesses_made
  def initialize
    @colors = ["yellow", "red", "orange", "blue", "green", "white"]
    @guesses = []
    @current_guess = []
    @results = []
    @color_probability = {}
    @colors.each do |color|
      @color_probability[color.to_sym] = {chance: -1, count: 0, location: [25,25,25,25]}
    end
    @guesses_made = 0
    @assumed_code = [nil,nil,nil,nil]
    @assumed_colors = []
    @not_included = []
  end

  def reset
    @guesses = []
    @current_guess = []
    @results = []
    @color_probability = {}
    @colors.each do |color|
      @color_probability[color.to_sym] = {chance: -1, count: 0, location: [25,25,25,25]}
    end
    @guesses_made = 0
    @assumed_code = [nil,nil,nil,nil]
    @assumed_colors = []
    @not_included = []
  end

  def guess
    @current_guess = []
    if @guesses.length == 0
      code_index = rand(6)
      4.times do
        @current_guess << @colors[code_index]
      end
      @guesses << @current_guess
      return @current_guess
    else
      guess = []
      i = 0
      until i == 4 do
        guess << getColor
        if @color_probability[guess[i].to_sym][:location][i] == -1
          guess.delete_at(i)
          next
        else
          i += 1
          next
        end
      end
      if @guesses.include?(guess)
        guess
      else
        @current_guess = guess
        @guesses << @current_guess
        return @current_guess
      end
    end
  end

  def getColor
    color = @colors[rand(6)]
    while @not_included.include?(color)
      color = @colors[rand(6)]
    end
    return color
  end

  def count(results)
    hash = {white: 0, red: 0, blank: 0, orange: 0, yellow: 0, blue: 0, green: 0}
    results.each do |result|
      hash[result.to_sym] += 1
    end
    return hash
  end

  def recalculateLocation(color, reds, whites)                               #color = "orange", reds = 1, whites = 2 
    if @color_probability[color.to_sym][:count] > 0                          #@color_probability[:orange][:count] = 0 > 0 returns false
      percentage = @color_probability[color.to_sym][:count] * 100
    else                                                                     #current block
      percentage = 100                                                       #percentage = 100
    end
    if reds == 0                                                             # 1 == 0 returns false : Block Skipped
      i = 0
      @current_guess.each do |guess|
        if guess == color
          @color_probability[color.to_sym][:location][i] = -1
        end
        i += 1
      end
    end
    numberAvailable = 0                                                      #numberAvailable = 0
    @color_probability[color.to_sym][:location].each do |location|           #loops through @color_probability[:orange][:location] array, each index that is greater than zero is counted towards numberAvailable
      if location == -1                                                       
        next
      else
        numberAvailable += 1
      end
    end                                                                      #@color_probability[:orange][:location] = [25,25,25,25] therefore numberAvailable = 4
    location_probablity = ((reds / numberAvailable.to_f) * 100).round(2)     #location_probablity = ((1 / 4.0) * 100) = 25.00
    i = 0
    @current_guess.each do |guess|
      if guess == color
        @color_probability[color.to_sym][:location][i] = location_probablity unless location_probablity < @color_probability[color.to_sym][:location][i] or @color_probability[color.to_sym][:location][i] == -1
      end
      i += 1
    end
    highest_percent = 0
    number_of_highest = 0
    @color_probability[color.to_sym][:location].each do |location|
      if location > highest_percent
        highest_percent = location
        number_of_highest = 1
      elsif location == highest_percent
        number_of_highest += 1
      else
        next
      end
    end
    numberAvailable = 0
    @color_probability[color.to_sym][:location].each do |location|
      if location > 0
        numberAvailable += 1
      else
        next
      end
    end
    numberAvailable -= number_of_highest
    remaining_percentage = ((percentage - (highest_percent * number_of_highest)) / numberAvailable.to_f).round(2)
    i = 0
    @color_probability[color.to_sym][:location].each do |location|
      if location == highest_percent
        i += 1
        next
      else
        @color_probability[color.to_sym][:location][i] = remaining_percentage unless @color_probability[color.to_sym][:location][i] == -1
        i += 1
      end
    end
  end

  def recalculateCount(color)                               #color = "orange"
    until @color_probability[color.to_sym][:chance] < 100   #@color_probability[:orange][:chance] = 75.0 < 100 : Block skipped
      @assumed_colors << color
      @color_probability[color.to_sym][:chance] -= 100
      @color_probability[color.to_sym][:count] += 1
    end
  end

  def recalculateProbability(color, amount, reds, whites)
    result_amount = reds + whites
    probability_not_hit = 0
    probability = 0
    other_options = 4 - amount
    total_options = 4
    if @color_probability[color.to_sym][:count] <= amount
      while result_amount > 0 
        if probability_not_hit == 0
          if other_options == 0
            @color_probability[color.to_sym][:count] += 1 unless @color_probability[color.to_sym][:count] == amount
            result_amount -= 1
            total_options -= 1
            next
          else
            probability_not_hit = (other_options.to_f / total_options.to_f).round(6)
            result_amount -= 1
            other_options -= 1
            total_options -= 1
          end
        else
          if other_options == 0
            @color_probability[color.to_sym][:count] += 1 unless @color_probability[color.to_sym][:count] == amount
            result_amount -= 1
            total_options -= 1
            next
          else
            probability_not_hit *= (other_options.to_f / total_options.to_f).round(6)
            result_amount -= 1
            other_options -= 1
            total_options -= 1
          end
        end
      end
    end
    probability += 100 - (probability_not_hit == 0 ? 100 : (probability_not_hit * 100))
    if @color_probability[color.to_sym][:chance] == -1
      @color_probability[color.to_sym][:chance] = probability.round(2)     #complex probability: calculate based on the chance of randomly not hitting the color from the guess
    else
      @color_probability[color.to_sym][:chance] += probability.round(2) 
    end
  end

  def balanced?(guessHash)
    amount = 0
    guessHash.each do |key, value|
      if value == 0
        next
      else
        amount = value if amount == 0
        return false unless amount == value
      end
    end
    return true
  end

  def recieveResults(results)                            #@current_guess = ["orange","blue","yellow","green"] results = ["red","white","white","blank"]
    countedHash = count(results)                         #countedHash = {red: 1, white: 2, blank: 0}
    guess = []                                           #guess = ["orange","blue","yellow","green"]
    i = 0
    @current_guess.each do |color|                       #loops through @current_guess and deletes any colors from guess if they are already considered not in the code
      if @not_included.include?(color)
        i += 1                   
        next
      else
        guess << @current_guess[i]
        i += 1
      end
    end                                                  #guess = ["orange","blue","yellow","green"]
    guessHash = count(guess)                             #guessHash = {orange: 1, blue: 1, yellow: 1, green: 1}
    guessedColors = []                                   #guessedColors = []
    guessHash.each do |color, value|                     #loops through guessHash to check for which specific colors were used in the guess.
      if value > 0
        guessedColors << color.to_s
      else
        next
      end
    end                                                  #guessedColors = ["orange","blue","yellow","green"]
    whites = countedHash[:white]                         #whites = 2
    reds = countedHash[:red]                             #reds = 1
    resultsCount = reds + whites                         #resultsCount = 3
    differentColors = guessedColors.length               #differentColors = 4
    @results << results                                  #results = [["red","white","white","blank"]]
    is_blank = results.all? {|result| result == "blank"} #is_blank = false
    is_white = results.all? {|result| result == "white" or result == "red"} #is_white = false
    if is_blank                                          #skipped
      @current_guess.each do |color|
        @color_probability[color.to_sym] = {chance: 0, count: 0, location: [-1,-1,-1,-1]}
        @not_included << color
      end
    elsif is_white                                       #skipped
      @current_guess.each do |color|
        recalculateProbability(color, guessHash[color.to_sym], reds, whites) unless @color_probability[color.to_sym][:count] >= guessHash[color.to_sym] or (@color_probability[color.to_sym][:chance] == 0 and @color_probability[color.to_sym][:count] == 0)
        recalculateCount(color)
        recalculateLocation(color, reds, whites)
      end
    else                                                 #This block is the current block due to conditionals
      guessedColors.each do |color|                     #Current Block    guessedColors = ["orange","blue","yellow","green"]
        i = 0                                           #i = 0      color = "orange"
        recalculateProbability(color, guessHash[color.to_sym], reds, whites) unless @color_probability[color.to_sym][:count] >= guessHash[color.to_sym] or (@color_probability[color.to_sym][:chance] == 0 and @color_probability[color.to_sym][:count] == 0)                                        #@color_probability[:orange][:chance] = 75.0
        recalculateCount(color)                         #Passed color = "orange"      Result: Skipped
        recalculateLocation(color, reds, whites)        #Passed color = "orange", reds = 1, whites = 2       Result: 
        no_location = @color_probability[color.to_sym][:location].all? {|location| location == -1}
        if no_location
          @color_probability[color.to_sym] = {chance: 0, count: 0, location: [-1,-1,-1,-1]}
          @not_included << color
        end
      end
    end
  end

=begin
  def recieveResults(results)
    countedHash = count(results)
    guessHash = count(@current_guess)
    whites = countedHash[:white]
    reds = countedHash[:red]
    @results << results
    is_blank = results.all? {|result| result == "blank"}
    is_white = results.all? {|result| result == "white"}
    if is_blank
      @current_guess.each do |color|
        @color_probability[color.to_sym] = {chance: 0, count: 0, location: [0,0,0,0]}
      end
    elsif is_white
      i = 0
      @current_guess.each do |color|
        @color_probability[color.to_sym][:chance] = 100
        @color_probability[color.to_sym][:location][i] = 0
        @color_probability[color.to_sym][:count] += 1
        recalculateLocation(color)
        i += 1
      end
    else
      i = 0
      @current_guess.each do |color|
        @color_probability[color.to_sym][:chance] = ((whites + reds)*25) * guessHash[color.to_sym] unless guessHash[color.to_sym] == @color_probability[color.to_sym][:count] or @color_probability[color.to_sym][:chance] == 0
        if reds > 0
          @color_probability[color.to_sym][:location][i] = reds * 25 unless @color_probability[color.to_sym][:chance] == 0
        else
          @color_probability[color.to_sym][:location][i] = 0
        end
        i += 1
      end
      @current_guess.each do |color|
        recalculateLocation(color, reds, whites)
        recalculateCount(color)
      end
    end
  end
=end
end

#code orange, green, blue, orange

=begin example results and what they should mean
Guess 1: green,green,green,green     Result 1: blank,red,blank,blank      Meaning: 100% chance one of the colors is green with a 25% chance of it being in any position                                                                                                                         
Guess 2: yellow,green,white,orange   Result 2: red,red,blank,blank        Meaning: Each color that isn't green has a 33.33% chance of existing and green is 100% in slot 2                                                                                                                      
Guess 3: red,yellow,green,yellow     Result 3: white,blank,blank,blank    Meaning: Each color here only has a 25% chance of existing and each of them have a 0% of being where they are. Since we know about green existing we can eliminate that none of the other colors exist.               
Guess 4: orange,red,orange,orange    Result 4: red,blank,red,blank        Meaning: There is 100% chance that one of the colors is orange and a 66.6% chance that an additional color is also orange while only a 33.3% chance that one of the colors is red. Since we know that the color green is in slot 2 we can conclude that there is no red and two oranges. Since two of the three oranges are in the correct spot then there is a 66.6% chance that an orange is in slot 1, 3 and 4.
Guess 5: white,yellow,red,green      Result 5: blank,blank,white,blank    Meaning: We already know we have green so we can determine that there is no white either.
Guess 6: orange,orange,green,blue    Result 6: red,white,white,white      Meaning: We have now figured out that there are two oranges, one green, and one blue. We know where green belongs so we know that each other color has a 33.3% chance of being where it is at except for the orange in slot 2.


Conclusion after each step.
Current Assumed Code: green somewhere
Current Assumed Code: green in slot 2
Current Assumed Code: green in slot 2, no red or yellow
Current Assumed Code: green in slot 2, two of the colors are orange, no red or yellow
Current Assumed Code: green in slot 2, two of the colors are orange, no red, yellow, white
Current Assumed Code: green in slot 2, two of the colors are orange and the last one is blue, no red, yellow, white

Other Notes:
If you recieve all blanks as a result then you can determine that none of those colors exist in the code.
If you recieve reds and some whites then you can determine that there is a 25% * (number of whites + number of reds) * (the amount of that chosen color) chance that each color exists.
So if your guess what orange,orange,white,blue and the result was white,blank,blank,blank then you can determine that there is a 50% chance that orange
is one of the colors while the other two are each 25% chance of existing. If the results however were: white,white,white,blank then you could determine that without a doubt
one of the colors is orange and a 66.6% chance that orange, white or blue are the remaining color since there are 2 remaining whites and 3 different remaining colors. If for
example the original guess you made was orange,orange,white,orange and the result was the same: blank,red,white,white then you can determine that there is at least 2 oranges
and a 50% chance of it being white or orange. 
An easier way to understand is if there is a less number of differing colors in the guess then there are white or red results or if one of the colors is guessed more than the others
and the number of different colors is equal to the number of the results that are white or red then the color that was guessed the most is
guaranteed to be one of the colors and the number of whites and reds should be subtracted by one as well as the color that was considered guaranteed and then checked again. 

=end
