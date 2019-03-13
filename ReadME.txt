Mastermind Game:

Rules:

Available Colors:
Yellow
Red
Orange
Blue
Green
White

Code Maker:
Generate a random 4 colored code, that may include more than one of any color. Example: Blue, Red, Yellow, Orange
Provide feedback to the player for each guess they make. This is may take on three forms, either Red, White, or Blank
  Feedback:
  Red = A guessed color was in the correct spot and is the correct color
  White = A guessed color was a correct color but not in the correct spot
  Blank = No correct colors were guessed
  There will be four colors given as feedback after each turn the Code Breaker makes, however the orientation of the
  feedback does not need to correlate with the position of any color. 
  For example:
  Lets say the original code is the above code of Blue, Red, Yellow, Orange
  The Code Breaker could guess: Red, Green, Yellow, Blue
  And the Feedback would be: Blank, White, Red, White if it was correlated with the position however it could come back as Red, Blank, White, White

Code Breaker:
Attempt to guess the code that the Code Maker created, this guess will be 4 colors in a specific sequence as the order will matter when guessing
the code. An example guess could be any of the 6 available colors above and any number of each, example: Yellow, Yellow, Blue, Red
The Code Maker will provide Feedback on how well each guess you made is, you must use this feedback to make more educated guesses and attempt to
make the correct code within 12 turns or else you lose.

Points:
The points will be determined by the number of turns taken and if the Code Breaker can break the code. The Code Maker will gain points for the number of turns the player had to 
make to break the code and if the Code Breaker cannot break the code in the 12 turns then the Code Maker gains 13 points. If the Code Maker is caught lying in the feedback then
the game is reset and the Code Breaker gains 3 points. After each game the role will be switched for the Code Breaker and Code Maker, at the end of an even number of Games whoever
has the highest score wins. The number of games to be played will be determined upon starting the game.







                                            #Program Break Down#
        
Objects:
Game Object
Code Maker
Code Breaker
Player Object
Board Object
Row Object
Cell Object

Object Uses:
Game:
The main hub for the other objects to return information to and show the current state of the Board and show the current Points
Determine how many games the player wants to play with the computer, must be an even number for fairness
Determine which role to player would like to start as
Accept input from the user to make guesses or return results to the computer player
Compare the Players Guesses with the Code held inside the CodeMaker object and accept back results from the CodeMaker to be printed on the screen
Accept and store the players made Code if they are acting as the Code Maker and show the player so they can return appropriate results to the computer player

CodeMaker:
Creates a random Code to be held in memory that will always be compared against user guesses from the game object
Generate results based on the players guess and send that result, in a random order, back to the game object

CodeBreaker:
Creates random codes at first to test against the players made code
Accept results from the player for the guesses made and keep probablities for certain colors to be in the code.
Generate more and more educated guesses as the game progresses and more results are made
Intelligently check to see if it can detect that the player is lying about the results

Player:
Contain the details about the player, including the name, points, and current role

Board:
Contain 12 Row objects and 12 Result objects that will always display what is currently in place on it
draw itself to the screen everytime a Row or a Result object is updated

Row:
Contain 4 Cells and Keep track of their positions

Cell:
Contain details about what color it is