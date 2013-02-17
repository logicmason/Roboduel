describe("MakeWord", function() {
  var robot;

  beforeEach(function() {
    robot = new Robot();
  });

  it("new robot should have default attributes", function() {
    expect(robot.get('hp')).toBeTruthy();
    expect(robot.get('position')).toBeTruthy();
    expect(robot.get('speed')).toBeTruthy();
    expect(robot.get('name')).toBeTruthy();
  });
});