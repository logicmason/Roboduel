$(document).ready ->
  robot = new Robot({position: {x: 20, y: 40}})
  console.log robot
  robotView = new RobotView({model: robot})

  $('.arena').append(robotView.render().el)