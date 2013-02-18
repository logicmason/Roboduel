class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 100
    maxHP: 1
    damage: => console.log "ouch"
    name: "robot"
    x: 0
    y: 0
    dx: 0
    dy: 0
    frequency: 1000/15
    arena:
      width: 600
      height: 600
    width: 40
    height: 40

  initialize: ->
    @missiles = []

    @set('script',  [
      "move"
      "move"
      "move"
      "move"
      "left"
      "fire"
      "idle"
    ])
    @set('lineNum', 0)


  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0
  deg: -> @attributes.dir * 360 / Math.TAO

  noisy: false

  die: ->
    console.log "#{@attributes.name} has died" if @noisy
    clearInterval(@intervalID)
    @destroy()

  start: ->
    @intervalID = setInterval =>
      @step()
    ,@frequency

  step: =>
    command = @attributes.script[@attributes.lineNum]
    @[command]() if @[command]
    console.log("from Step()", @attributes) if @noisy
    @attributes.lineNum = (@attributes.lineNum + 1) % @attributes.script.length

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
    @set('dir', (@attributes.dir+0.05) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  right: ->
    @set('dir', (Math.TAO + @attributes.dir-0.05) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  fire: ->
    missile = new Missile({
      id: @missile
      x: @get('x')+@get('width')/2
      y: @get('y')+@get('height')/2
      dir: @get('dir')
    })
    missileView = new MissileView({model: missile})
    @missiles.push {model: missile, view: missileView}

  idle: ->
    @


class window.RobotView extends Backbone.View
  className: 'robot'

  initialize: =>
    console.log(@model)
    @listenTo(@model, 'change', @render)
    @listenTo(@model, 'destroy', @remove)

  render: ->
    @$el.css("left", @model.get('x'))
    @$el.css("top", @model.get('y'))
    @$el.css("transform", "rotate("+@model.deg()+"deg)")
    @$el.appendTo('.arena')
    @

class window.RobotCommandView extends Backbone.View
  className: 'commands'

  initialize: ->
    @listenTo(@model, 'change:[script]', @render)
    @listenTo(@model, 'destroy', @remove)
    $('.rightbar').append(@$el)
    @render()

  render: ->
    @$el.html("<h3>#{@model.get('name')}'s control program</h3>")
    @$el.append("<ol>")
    for x in @model.get('script')
      @$el.append("<li>#{x}</li>")
    @$el.append("</ol>")
    @

