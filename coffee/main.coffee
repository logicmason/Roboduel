Math.TAO = Math.PI * 2

class window.Game extends Backbone.Model

  initialize: ->
    window.silo = new MissileCollection({})
    window.robotorium = new RobotCollection({})

  addRobot: (options)->
    r = new Robot(options)
    rView = new RobotView({model: r})
    cmdv = new RobotCommandView({model: r})
    r.start()
    cmdv.render()
    # TODO: make game view
    $('.arena').append(rView.render().el)
    window.robotorium.add(r)

  loadRobot: =>
    name = prompt "Who would you like to load?"
    @invite(name)

  invite: (name)->
    @addRobot()
    bot = robotorium.models[robotorium.models.length-1]
    console.log !!bot.download(name)

  onServer: (name)->
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    query = new Parse.Query('RoboScript')
    query.equalTo('name', @get('name'))
    that = @
    promise = query.first(
      success: (result)=>
        if (result)
          return true
        else
          return false
      error: (error)=>
        alert("Error fetching bot from Parse: #{error.message}")
    )

$(document).ready ->
  window.game = new Game()
  window.robotorium.models[0].die() #TODO prevent creation of default bot
  $('.addRobot').click(game.addRobot)
  game.addRobot({name: "somebot"})
  $('.loadRobot').click(game.loadRobot)
