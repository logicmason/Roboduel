class window.Missile extends Backbone.Model
  defaults:
    hp: 1
    damage: 1
    x: 0
    y: 0
    dir: 0
    frequency: 1000/30
    arena:
      width: 600
      height: 600
    width: 10
    height: 4

  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0
  deg: -> @attributes.dir * 360 / Math.TAO
  dx: -> (Math.cos @get('dir')) * 10
  dy: -> (Math.sin @get('dir')) * 10

  initialize: ->
    @set('x', @attributes.x - @attributes.width/2)
    @set('y', @attributes.y - @attributes.height/2)
    @set('script',  [
      "move"
    ])
    @set('lineNum', 0)
    @start()

  die: ->
    console.log "missile destroyed" if @noisy
    clearInterval(@intervalID)
    @destroy()
    window.silo.remove(@)

  start: ->
    @intervalID = setInterval =>
      @step()
    ,@frequency

  step: =>
    command = @attributes.script[@attributes.lineNum]
    @[command]()
    console.log("from Step()", @attributes) if @noisy
    @attributes.lineNum = (@attributes.lineNum + 1) % @attributes.script.length
  #Commands -- these are read from the script[] and executed in step()
  move: =>
    newx = @attributes.x + @dx()
    @die() if newx > @maxX()
    @die() if newx < @minX()
    newy = @attributes.y + @dy()
    @die() if newy > @maxY()
    @die() if newy < @minY()
    @set('x', newx)
    @set('y', newy)
    console.log("from Step()", @attributes) if @noisy

  class window.MissileView extends Backbone.View
    className: 'missile'

    initialize: =>
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @remove)

    render: ->
      @$el.html("")
      @$el.css("left", @model.get('x'))
      @$el.css("top", @model.get('y'))
      @$el.css("transform", "rotate("+@model.deg()+"deg)")
      @$el.appendTo('.arena')
      @
