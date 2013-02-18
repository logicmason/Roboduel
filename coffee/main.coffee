Math.TAO = Math.PI * 2

$(document).ready ->
  window.robot = new Robot({position: {x: 20, y: 40}})
  console.log robot
  window.robotView = new RobotView({model: robot})

  $('.arena').append(robotView.render().el)