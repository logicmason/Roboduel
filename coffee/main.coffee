Math.TAO = Math.PI * 2

class window.Game extends Backbone.Model

  initialize: ->
    window.silo = new MissileCollection({})
    window.robotorium = new RobotCollection({})
    @listenTo(window.robotorium, "finalSurvivor", @finalSurvivor)

  addRobot: (options)->
    r = new Robot(options)
    r.readRecord() if r.get('roboRecord')
    rView = new RobotView({model: r})
    cmdv = new RobotCommandView({model: r})
    cmdv.render()
    # TODO: make game view
    $('.arena').append(rView.render().el)
    window.robotorium.add(r)

  invite: (name)->
    @addRobot()
    bot = robotorium.models[robotorium.models.length-1]

  start: ->
    _(window.robotorium.models).each((bot)-> bot.startOnce())
    console.log('start')

  finalSurvivor: ->
    @winner = robotorium.models[0]
    alert "#{@winner.get('name')} is victorious!"
    @winner.die()
    @playerbot = null
    @enemybot = null

  loadRobot: (event, name)=>
    name || name = prompt "Who would you like to load?", name
    unless @playerbot
      botSource = @checkDBforBot(name, (result)=>
        @addRobot({
          roboRecord: result
          name: result.get('name')
          source: result.get('source')
        })
        @playerbot = robotorium.models[robotorium.models.length-1]
        @playerbot.readRecord()
      )
    else @playerbot.download(name)

  loadEnemy: (event, name)=>
    name = name || prompt "Who would you like to load?"
    unless @enemybot
      botSource = @checkDBforBot(name, (result)=>
        @addRobot({
          roboRecord: result
          name: result.get('name')
          source: result.get('source')
          enemy: true
        })
        @enemybot = robotorium.models[robotorium.models.length-1]
        @enemybot.readRecord()
      )
    else @enemybot.download(name)

  checkDBforBot: (name, foundCB, notFoundCB)=>
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    query = new Parse.Query('RoboScript')
    query.equalTo('name', name)
    that = @
    promise = query.first(
      success: (result)=>
        if (result)
          foundCB(result) if foundCB
        else
          notFoundCB() if notFoundCB
      error: (error)=>
        alert("Error fetching bot from Parse: #{error.message}")
    )

$(document).ready ->
  window.game = new Game()
  window.robotorium.models[0].die() #TODO prevent creation of default bot
  $('.addRobot').click(game.addRobot)
  $('.loadRobot').click(game.loadRobot)
  $('.start').click(game.start)
  $('.loadEnemy').click(game.loadEnemy)

