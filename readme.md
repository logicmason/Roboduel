RoboDuel
=========

Code the strongest bot to win
---

  - HTML5/JS Dom-node game
  - Control your robot by writing its program before the duel starts
  - The robot continually loops through its command list
  - Destroy the enemy robot before it destroys you

    
>"RoboDuel is the game I've wanted to play since the first time I  
discovered the wonderful flash game, [Light-bot].  The goal is  
fun with a sprinkle of educational value!"


### Development status
  - Started as 2 day personal project, many more updates to come in the next couple of days
  - Robots can be created
  - Parser and interpretter for the robots' programming language written
  - Programs are user editable and robots immediately respond
  - Robots can fire missiles
  - Branching, looping and variable declarations are supported in robocode
  - No network / multiplayer features yet
  - Game design still not set in stone


### Development tools and environment of choice
RoboDuel is written in [CoffeeScript], using the Sublime (with VIM support via Vintage and VintageEx).  All development has been on Chrome and MacOS.  [Backbone.js] is used to structure the code.  The parser for the robot language was made with [PEG.js] and the initial basis for the interpreter was scheme.

### Links
 - Author's [development blog]
 - [Introductory video and feedback page]
 - Author's twitter [@toshuo]


Installation
--------------

1. Clone the repo
2. `cd RoboDuel`
3. `open index.html`

Testing
-------
 - Jasmine (in the SpecRunner.html) for most things
 - For testing of the parsing of robot grammar run mocha from the command line

`mocha -u tdd -R spec roboParseSpec`


License
-

Creative Commons - Attribution, Share-Alike
  
  [Light-bot]: http://www.kongregate.com/games/Coolio_Niato/light-bot
  [development blog]: http://logicmason.com/
  [Introductory video and feedback page]: http://logicmason.com/2013/hack-reactor-diaries-3-roboduel-with-backbone-and-coffeescript/
  [CoffeeScript]: http://coffeescript.org/
  [Backbone.js]: http://backbonejs.org/
  [PEG.js]: http://pegjs.majda.cz/
  [@toshuo]: http://twitter.com/toshuo