describe("Robot", function() {
  var robot;
  beforeEach(function() {
    window.silo = new MissileCollection({});
    window.robotorium = new RobotCollection({})
    robot = new Robot({name: 'Johnny5', script: ['idle']})
    rView = new RobotView({model: robot})
    cmdv = new RobotCommandView({model: robot})
    cmdv.render()
  });

  it("new robot should have default attributes", function() {
    expect(robot.get('hp')).toBeTruthy();
    expect(robot.get('x')).toBeTruthy();
    expect(robot.get('y')).toBeTruthy();
    expect(robot.get('dir')).toEqual(0);
    expect(robot.get('name')).toBeTruthy();
  });

  describe("Mathematical calculations", function() {
    var bot1, bot2;

    beforeEach(function() {
      bot1 = new Robot({name: 'HAL', x:50, y:300, script: ['idle']});
      bot2 = new Robot({name: 'TOM', x:300, y: 200, script: ['idle']});
    });

    it("should calculate movement bounds from arena and robot size", function(){
      expect(bot1.maxX()).toEqual(600 - bot1.get('width'));
      expect(bot1.maxY()).toEqual(600 - bot1.get('height'));
    });

    it("should calculate center positions of bots", function(){
      expect(bot1.centerX()).toEqual(50 + bot1.get('width')/2);
      expect(bot2.centerX()).toEqual(300 + bot1.get('width')/2);
      expect(bot1.centerY()).toEqual(300 + bot1.get('height')/2);
      expect(bot2.centerY()).toEqual(200 + bot1.get('height')/2);
    });

    it("should caculate movement dx from robot direction", function(){
      var dir = bot1.get('dir');
      expect(bot1.get('dx')).toBeCloseTo(Math.cos(dir));
    });

    it("should caculate movement dy from robot direction and flip axis", function(){
      var dir = bot1.get('dir');
      expect(bot1.get('dy')).toBeCloseTo(Math.sin(dir) * -1);
    });

    it("should calculate degrees from radians", function(){
      bot1.set('dir', Math.PI);
      bot2.set('dir', Math.PI/4);
      expect(bot1.deg()).toBeCloseTo(180);
      expect(bot2.deg()).toBeCloseTo(45);
    });

    it("should calculate correct movement x,y vector from direction", function(){
      bot1.set('dir', Math.PI/2);
      bot1.updateDxDy();
      expect(bot1.get('dx')).toBeCloseTo(0);
      expect(bot1.get('dy')*-1).toBeCloseTo(1);
    });
  });

  it("Parse should work", function(){
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    var TestObject = Parse.Object.extend("TestObject");
    var testObject = new TestObject();
    var flag;

    runs(function() {
      testObject.save({foo: "bar"}, {
        success: function(object) {
          flag = true;
        },
        error: function(object) {
          flag = false;
        }
      });
    });

    waitsFor(function() {
      return flag;
    }, "Waits for message", 1500);

    runs(function() {
      expect(flag).toBeTruthy();
    });
  });
});