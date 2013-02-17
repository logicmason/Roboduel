class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 100
    maxHP: 10
    damage: => console.log "ouch"
    name: "robot"
    position:
      x: 0
      y: 0
    speed:
      x: 0
      y: 0
    frequency: 300

  die: ->
    console.log "#{@attributes.name} has died"
    trigger('die')

  start: ->
    setInterval =>
      @step()
    ,@frequency

  step: =>
    @set({x: @get('position').x += @get('speed').x, y: @get('position').y += @get('speed').y})
    console.log("from Step()", @attributes.position)

class window.RobotView extends Backbone.View
  className: 'robot'

  initialize: =>
    console.log(@model)
    @listenTo(@model, 'change', @render)

  render: ->
    @$el.css("left", @model.get('position').x)
    @$el.css("top", @model.get('position').y)
    @$el.html("robot").appendTo('.arena')
    @
