// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Robot = (function(_super) {
    var _this = this;

    __extends(Robot, _super);

    function Robot() {
      this.step = __bind(this.step, this);
      return Robot.__super__.constructor.apply(this, arguments);
    }

    Robot.prototype.defaults = {
      dir: 0,
      hp: 100,
      maxHP: 10,
      damage: function() {
        return console.log("ouch");
      },
      name: "robot",
      position: {
        x: 0,
        y: 0
      },
      speed: {
        x: 0,
        y: 0
      },
      frequency: 300
    };

    Robot.prototype.die = function() {
      console.log("" + this.attributes.name + " has died");
      return trigger('die');
    };

    Robot.prototype.start = function() {
      var _this = this;
      return setInterval(function() {
        return _this.step();
      }, this.frequency);
    };

    Robot.prototype.step = function() {
      this.set({
        x: this.get('position').x += this.get('speed').x,
        y: this.get('position').y += this.get('speed').y
      });
      return console.log("from Step()", this.attributes.position);
    };

    return Robot;

  }).call(this, Backbone.Model);

  window.RobotView = (function(_super) {

    __extends(RobotView, _super);

    function RobotView() {
      this.initialize = __bind(this.initialize, this);
      return RobotView.__super__.constructor.apply(this, arguments);
    }

    RobotView.prototype.className = 'robot';

    RobotView.prototype.initialize = function() {
      console.log(this.model);
      return this.listenTo(this.model, 'change', this.render);
    };

    RobotView.prototype.render = function() {
      this.$el.css("left", this.model.get('position').x);
      this.$el.css("top", this.model.get('position').y);
      this.$el.html("robot").appendTo('.arena');
      return this;
    };

    return RobotView;

  })(Backbone.View);

}).call(this);
