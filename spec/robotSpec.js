describe("Robot", function() {
  var robot;

  beforeEach(function() {
    robot = new Robot({name: 'Johnny5'})
    rView = new RobotView({model: robot})
    cmdv = new RobotCommandView({model: robot})
    robot.start()
    cmdv.render()
  });

  it("new robot should have default attributes", function() {
    expect(robot.get('hp')).toBeTruthy();
    expect(robot.get('x')).toBeTruthy();
    expect(robot.get('y')).toBeTruthy();
    expect(robot.get('dir')).toEqual(0);
    expect(robot.get('name')).toBeTruthy();
  });
});