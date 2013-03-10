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

$(document).ready ->
  window.game = new Game()
  window.robotorium.models[0].die() #TODO prevent creation of default bot
  $('.addRobot').click(game.addRobot)
  game.addRobot({name: "somebot"})