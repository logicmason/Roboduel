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
    @set('x', Math.random()* @maxX()) unless @attributes.x
    @set('y', Math.random()* @maxY()) unless @attributes.y
    unless @attributes.script
      commands = []
      _(6).times(->
        num = Math.floor(Math.random()*5)
        commands.push "move" if num == 0
        commands.push "left" if num == 1
        commands.push "right" if num == 2
        commands.push "fire" if num == 3
        commands.push "idle" if num == 4
      )
      @set('script',  commands)
    @set('source', @attributes.script.join('\n'))
    @set('lineNum', 0)
    @env = {
      move: "move", idle: "idle", fire: "fire",
      right: "right", left: "left", self: @,
      locateSelf: "locateSelf", locateEnemy: "locateEnemy",
      targetSeen: "targetSeen"
    }

  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0
  deg: -> @attributes.dir * 360 / Math.TAO
  centerX: -> @attributes.x + @attributes.width/2
  centerY: -> @attributes.y + @attributes.height/2

  noisy: false

  enemy: ->
    unless @collection and @collection.length
      throw "cannot find enemies unless robot is in a collection!"
    myloc = @collection.indexOf(@)
    @collection.at((myloc+1) % @collection.length)

  die: ->
    console.log "#{@attributes.name} has died" if @noisy
    clearInterval(@intervalID)
    @destroy()
    window.robotorium.remove(@)

  start: ->
    @intervalID = setInterval =>
      @step()
    ,@frequency

  step: =>
    @collisionCheck()

    command = @attributes.script[@attributes.lineNum]
    evaledCommand = roboEval(command, @env);
    @[evaledCommand]() if @[evaledCommand]
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
    @set('dy', Math.sin @get('dir') * -1)

  left: ->
    @set('dir', (Math.TAO + @attributes.dir-0.03) % Math.TAO)
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir') * -1)

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

  locateSelf: ->
    @env.x = @get('x') + @get('width') / 2
    @env.y = @get('y') + @get('height') / 2
    @env.dir = (360 - @get('dir') * 360 / Math.TAO) % 360  #kid-friendly

  locateEnemy: ->
    return unless @enemy()
    @env.ex = @enemy().get('x') + @enemy().get('width') / 2
    @env.ey = @enemy().get('y') + @enemy().get('height') / 2
    @env.edir = (360 - @enemy().get('dir') * 360 / Math.TAO) % 360 #kid-friendly

  targetSeen: =>
    #calculates distance a shot fired would miss an enemy's center by
    #returns yes if the error is smaller than the width of the target
    cos = Math.cos
    sin = Math.sin
    pow = Math.pow
    sqrt = Math.sqrt
    dist = @distanceToEnemy()
    theta = @angleToEnemy()
    thetap = @get('dir')
    epsilon = sqrt(  pow( dist* (cos(thetap) - cos(theta)  ),2) + pow(  dist* (sin(thetap) - sin(theta)  ),2))
    (epsilon < @enemy().get('width') / 2)

  angleToEnemy: ->
    #TODO: replace the hack for handling flipped y-axis
    dy = @enemy().get('y') - @get('y')
    dx = @enemy().get('x') - @get('x')
    if (dx > 0)
      Math.atan(dy/dx)
    else
      (Math.atan(dy/dx) + Math.PI) % Math.TAO

  distanceToEnemy: ->
    dy = @enemy().get('y') - @get('y')
    dx = @enemy().get('x') - @get('x')
    Math.sqrt(dx*dx + dy*dy)

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
      @model.set('source', @$('textarea').val())
      try
        parsedCommands = parseRobot(@model.get('source'))
        console.log parsedCommands
      catch error
        console.log("Parse error: ", error)
        parsedCommands = ['idle']
        alert("robot's program doesn't parse!")
      finally
        @model.set('lineNum', 0)
        @model.set('script', parsedCommands)
        @render()
    console.log "#{@display} display"

  render: ->
    @$el.html('<div class="editButton">Edit</div>')
    @$el.append('<h3 class="heading">'+"#{@model.get('name')}'s program</h3>")
    @$el.append("<ol>")
    for x in @model.get('script')
      @$el.append("<li>#{x}</li>")
    @$el.append("</ol>")
    @display = 'standard'
    @

  renderInput: ->
    @$el.html('<div class="editButton">Done</div>')
    @$el.append('<h3 class="heading">'+"#{@model.get('name')}'s program</h3>")
    area = ('<textarea>')
    area += @model.get('source')
    @$el.append(area+'</textarea>')
    @display = 'input'
    @

