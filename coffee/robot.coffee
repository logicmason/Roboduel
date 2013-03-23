class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 500
    maxHP: 500
    attack: 3
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
    @updateDxDy()

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
      queue: [],
      move: "move", idle: "idle", fire: "fire",
      right: "right", left: "left", self: @,
      locateSelf: "locateSelf", locateEnemy: "locateEnemy",
      targetSeen: "targetSeen"
    }
    @startOnce = _.once @start

  maxX: -> @attributes.arena.width - @attributes.width
  minX: -> 0
  maxY: -> @attributes.arena.height - @attributes.height
  minY: -> 0
  deg: -> @attributes.dir * 360 / Math.TAO
  centerX: -> @attributes.x + @attributes.width/2
  centerY: -> @attributes.y + @attributes.height/2
  noisy: false
  updateDxDy: ->
    @set('dx', Math.cos @get('dir'))
    @set('dy', Math.sin @get('dir') * -1)

  enemy: ->
    unless @collection and @collection.length
      console.log "cannot find enemies unless robot is in a collection!"
      return @
    myloc = @collection.indexOf(@)
    @collection.at((myloc+1) % @collection.length)

  die: ->
    console.log "#{@attributes.name} has died" if @noisy
    clearInterval(@intervalID)
    @destroy()

  start: =>
    @intervalID = setInterval =>
      @step()
    ,@frequency

  step: =>
    @collisionCheck()
    if @env.queue.length > 0
      command = @env.queue.shift()
    else
      command = @attributes.script[@attributes.lineNum]
      @attributes.lineNum = (@attributes.lineNum + 1) % @attributes.script.length
    evaledCommand = roboEval(command, @env);
    @[evaledCommand]() if @[evaledCommand]

  collisionCheck: =>
    window.silo.each((missile)=>
      mLeft = missile.get('x') + missile.dx()
      mRight = missile.get('x') + missile.get('width') + missile.dx()
      rLeft = @get('x')
      rRight = @get('x') + @get('width')

      mTop = missile.get('y') + missile.dy()*2
      mBottom = missile.get('y') + missile.get('height') + missile.dy()
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
    dy = Math.sin @get('dir') #y is reversed elsewhere to fix flipped axis
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
    @updateDxDy()

  left: ->
    @set('dir', (Math.TAO + @attributes.dir-0.03) % Math.TAO)
    @updateDxDy()

  fire: ->
    mult = 20
    missile = new Missile({
      id: @missile
      x: @get('x')+@get('width')/2 + Math.cos(@get('dir')) * mult
      y: @get('y')+@get('height')/2 + Math.sin(@get('dir')) * mult
      dir: @get('dir')
      damage: @get('attack')
    })
    missileView = new MissileView({model: missile})
    window.silo.add(missile)

  idle: ->
    @

  locateSelf: ->
    @env.x = @get('x') + @get('width') / 2
    @env.y = @get('y') + @get('height') / 2
    @env.dir = Math.floor((360 - @get('dir') * 360 / Math.TAO) % 360)  #kid-friendly

  locateEnemy: ->
    return unless @enemy()
    @env.ex = @enemy().get('x') + @enemy().get('width') / 2
    @env.ey = @enemy().get('y') + @enemy().get('height') / 2
    @env.edir = Math.floor((360 - @enemy().get('dir') * 360 / Math.TAO) % 360) #kid-friendly

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
    dy = @env.ey - @enemy().get('height')/2 - @get('y')
    dx = @env.ex - @enemy().get('width')/2 - @get('x')
    if (dx > 0)
      Math.atan(dy/dx)
    else
      (Math.atan(dy/dx) + Math.PI) % Math.TAO

  distanceToEnemy: ->
    dy = @env.ey - @get('y')
    dx = @env.ex - @get('x')
    Math.sqrt(dx*dx + dy*dy)

  upload: (name)->
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    RoboRecord = Parse.Object.extend('RoboScript')
    @roboRecord = new RoboRecord() unless @roboRecord
    name = name || @get('name')
    @roboRecord.set('name', name)
    @roboRecord.set('source', @get('source'))

    query = new Parse.Query('RoboScript')
    query.equalTo('name', name || @get('name'))
    that = @
    promise = query.first(
      success: (result)=>
        if (result and result.id != that.get('roboRecord').id)
          alert "Oh noes!  An evil robot maker has already used up that name!"
        else
          @roboRecord.save(null, {
            success: (@roboRecord)->
              alert("#{name} has been saved to the Robo Server")
            error: (@roboRecord, error)->
              console.log "ran into an #{error}"
          })
      error: (error)=>
        alert("Error fetching bot from Parse: #{error.message}")
    )

  download: (name)->
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    query = new Parse.Query('RoboScript')
    query.equalTo('name', name)
    that = @
    promise = query.first(
      success: (result)=>
        if result
          that.roboRecord = result
          that.set('name', result.get('name'))
          that.set('source', result.get('source'))
          that.parseSource()
        else
          alert "No Robot named #{name}"
      error: (error)=>
        alert("Error fetching bot from Parse: #{error.message}")
    )

  readRecord: =>
    record = @get('roboRecord')
    @set('name', record.get('name'))
    @set('source', record.get('source'))
    @parseSource()

  parseSource: ->
    @attributes.lineNum = 0
    @set('script', parseRobot(@get('source')))


class window.RobotView extends Backbone.View
  className: 'robot'

  initialize: =>
    console.log(@model)
    @listenTo(@model, 'change', @render)
    @listenTo(@model, 'damage', @blink)
    @listenTo(@model, 'destroy', @remove)
    @$el.addClass('enemy') if @model.get('enemy')

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
    'click .saveButton': 'saveRobot'
    'click .heading': 'editName'
    'keyup .headingEdit': 'updateName'

  initialize: ->
    @listenTo(@model, 'change:script', @render)
    @listenTo(@model, 'change:source', @toggleView)
    @listenTo(@model, 'change:hp', @render)
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
      catch error
        console.log("Parse error: ", error)
        parsedCommands = ['idle']
        alert("robot's program doesn't parse!")
      finally
        @model.set('lineNum', 0)
        @model.set('script', parsedCommands)
        @render()
    console.log "#{@display} display"

  editName: ->
    @$('.heading').replaceWith('<input class="headingEdit" value="' + "#{@model.get('name')}" + '"/>')
    @$('.headingEdit').focus()

  updateName: (e)->
    if e.which == 13 #enter key was hit
      newName = @$('.headingEdit').val()
      @model.set('name', newName)
      @$('.headingEdit').replaceWith('<h3 class="heading">'+"#{@model.get('name')}</h3>")

  saveRobot: ->
    @model.upload()

  render: ->
    @$el.addClass('enemy') if @model.get('enemy')
    @$el.html('<div class="editButton">Edit</div>')
    @$el.append('<h3 class="heading">'+"#{@model.get('name')}</h3>")
    @$el.append('<div class="saveButton">Save</div>')

    @$el.append("<div class='hp'>HP: #{@model.get('hp')}</div>")
    pre = ('<pre>')
    pre += @model.get('source')
    @$el.append(pre + "</pre>")
    @display = 'standard'
    @$('heading').on('click')
    @

  renderInput: ->
    @$el.html('<div class="editButton">Done</div>')
    @$el.append('<input class="headingEdit" value="' + "#{@model.get('name')}" + '"/>')
    area = ('<textarea>')
    area += @model.get('source')
    @$el.append(area+'</textarea>')
    @$('textarea').select()
    @display = 'input'
    @

