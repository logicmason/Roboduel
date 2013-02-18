Math.TAO = Math.PI * 2

class window.Game extends Backbone.Model

  initialize: ->
    $(document).ready ->
    window.silo = new MissileCollection({})

  addRobot: (options)->
    r = new Robot(options)
    rView = new RobotView({model: r})
    cmdv = new RobotCommandView({model: r})
    r.start()
    cmdv.render()
    $('.arena').append(rView.render().el)

$(document).ready ->
  window.game = new Game()
  $('.addRobot').click(game.addRobot)
  game.addRobot({name: "somebot"})