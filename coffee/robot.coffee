class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 100
    maxHP: 1
    attack: 5
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
    @set('hp', defaults["hp"]) unless @attributes.hp
    @set('script',  [
      "move"
      "move"
      "move"
      "move"
      "left"
      "fire"
      "idle"
    ]) unless @attributes.script
    @set('lineNum', 0)


  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0
  deg: -> @attributes.dir * 360 / Math.TAO
  centerX: -> @attributes.x + @attributes.width/2
  centerY: -> @attributes.y + @attributes.height/2

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
    @collisionCheck()

    command = @attributes.script[@attributes.lineNum]
    @[command]() if @[command]
    console.log("from Step()", @attributes) if @noisy
    @attributes.lineNum = (@attributes.lineNum + 1) % @attributes.script.length

  collisionCheck: =>
    window.silo.each((missile)=>
      mLeft = missile.get('x') + missile.dx()*2
      mRight = missile.get('x') + missile.get('width') + missile.dx()*2
      rLeft = @get('x')
      rRight = @get('x') + @get('width')

      mTop = missile.get('y') + missile.dy()*2
      mBottom = missile.get('y') + missile.get('height') + missile.dy()*2
      rTop = @get('y')
      rBottom = @get('y') + @get('height')

      if ((mRight > rLeft) and (mLeft < rRight) and
          (mTop < rBottom) and (mBottom > rTop))
            console.log([mLeft,mRight,mTop,mBottom]) if @noisy
            @takeDamage(missile.get('damage'))
          )

  takeDamage: (damage)->
    @set('hp', @attributes.hp - damage)
    @trigger('damage')
    @die() if @attributes.hp < 0

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

  right: ->
    @set('dir', (@attributes.dir+0.03) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  left: ->
    @set('dir', (Math.TAO + @attributes.dir-0.03) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir'))

  fire: ->
    mult = 20
    missile = new Missile({
      id: @missile
      x: @get('x')+@get('width')/2 + Math.cos(@get('dir')) * mult
      y: @get('y')+@get('height')/2 + Math.sin(@get('dir')) * mult
      dir: @get('dir')
      damage: @attack
    })
    missileView = new MissileView({model: missile})
    window.silo.add(missile)

  idle: ->
    @


class window.RobotView extends Backbone.View
  className: 'robot'

  initialize: =>
    console.log(@model)
    @listenTo(@model, 'change', @render)
    @listenTo(@model, 'damage', @blink)
    @listenTo(@model, 'destroy', @remove)

  blink: ->
    @$el.addClass('damage')
    setTimeout (=> @$el.removeClass('damage')), 10

  render: ->
    @$el.css("left", @model.get('x'))
    @$el.css("top", @model.get('y'))
    @$el.css("transform", "rotate("+@model.deg()+"deg)")
    @$el.appendTo('.arena')
    @

class window.RobotCommandView extends Backbone.View
  className: 'commands'

  events:
    'click .editButton': 'toggleView'

  initialize: ->
    @listenTo(@model, 'change:script', @render)
    @listenTo(@model, 'destroy', @remove)
    $('.rightbar').append(@$el)
    @render()

  toggleView: ->
    if @display == "standard"
      @renderInput()
    else if @display == "input"
      @model.set('script', @$('textarea').val().split("\n"))
      @render()
    console.log "#{@display} display"

  render: ->
    @$el.html('<div class="editButton">Edit</div>')
    @$el.append('<h3 class="heading">'+"#{@model.get('name')}'s control program</h3>")
    @$el.append("<ol>")
    for x in @model.get('script')
      @$el.append("<li>#{x}</li>")
    @$el.append("</ol>")
    @display = 'standard'
    @

  renderInput: ->
    @$el.html('<div class="editButton">Done</div>')
    @$el.append('<h3 class="heading">'+"#{@model.get('name')}'s control program</h3>")
    area = ('<textarea>')
    for x in @model.get('script')
      area += ("\n#{x}")
    @$el.append(area+'</textarea>')
    @display = 'input'
    @

