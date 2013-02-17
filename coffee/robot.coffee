class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 100
    maxHP: 10
    damage: => console.log "ouch"
    name: "robot"
    x: 0
    y: 0
    dx: 0
    dy: 0
    frequency: 1000/30
    arena:
      width: 600
      height: 600
    width: 40
    height: 40

  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0

  script: [
    "move"
    "left"
  ]
  lineNum: 0

  noisy: false

  die: ->
    console.log "#{@attributes.name} has died"
    trigger('die')

  start: ->
    setInterval =>
      @step()
    ,@frequency

  step: =>
    command = @script[@lineNum]
    @[command]()
    console.log("from Step()", @attributes.position) if @noisy
    @lineNum = (@lineNum + 1) % @script.length

  #Commands -- these are read from the script[] and executed in step()
  move: =>
    dx = Math.cos @get('dir')
    dy = Math.sin @get('dir')
    newx = @attributes.x + dx
    newx = @maxX() if newx > @maxX()
    newx = @minX() if newx < @minX()
    newy = @attributes.y + dy
    newy = @maxY() if newy > @maxY()
    newy = @minY() if newy < @minY()
    @set('x', newx)
    @set('y', newy)
    console.log("from Step()", @attributes) if @noisy

  left: ->
    @set('dir', (@attributes.dir+0.01) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  right: ->
    @set('dir', (Math.TAO + @attributes.dir-0.01) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  idle: ->
    @


class window.RobotView extends Backbone.View
  className: 'robot'

  initialize: =>
    console.log(@model)
    @listenTo(@model, 'change', @render)

  render: ->
    @$el.css("left", @model.get('x'))
    @$el.css("top", @model.get('y'))
    @$el.html("robot").appendTo('.arena')
    @
