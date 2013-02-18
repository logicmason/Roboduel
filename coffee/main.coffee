Math.TAO = Math.PI * 2

$(document).ready ->
  window.silo = new MissileCollection({})
  window.robot = new Robot({position: {x: 20, y: 40}})
  window.robotView = new RobotView({model: robot})

  $('.arena').append(robotView.render().el)