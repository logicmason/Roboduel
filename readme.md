RoboDuel
=========

Code the strongest bot to win
---

  - HTML5/JS Dom-node game
  - Control your robot by writing its program before the duel starts
  - The robot runs programs written in a RoboCode
  - Destroy the enemy robot before it destroys you

    
>"RoboDuel is the game I've wanted to play since the first time I  
discovered the wonderful flash game, [Light-bot].  The goal is  
fun with a sprinkle of educational value!"


### Development status
  - Robots can be either created or downloaded and placed into the arena
  - Parser and interpretter for the robots' programming language written
  - Programs are user editable and robots immediately respond
  - Robots can fire missiles
  - Branching, looping and variable declarations are supported in robocode
  - Robots can be saved and loaded to the server via load and save buttons
  - Minimal instructions added, but UI still bare
  - Game design still evolving


### Development tools and environment of choice
RoboDuel is written in [CoffeeScript], using the Sublime (with VIM support via Vintage and VintageEx).  All development has been on Chrome and MacOS.  [Backbone.js] is used to structure the code.  The parser for the robot language was made with [PEG.js] and the initial basis for the interpreter was scheme.

### Links
 - Author's [development blog]
 - [Introductory video and feedback page]
 - Author's twitter [@toshuo]


Installation
--------------

1. Clone the repo: `git clone https://github.com/logicmason/Roboduel.git`
2. Change to the RoboDuel directory: `cd RoboDuel`
3. compile the coffescript:
`coffee --compile -o js/ coffee/`
4. open the file: `open index.html`

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