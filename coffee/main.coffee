Math.TAO = Math.PI * 2

class window.Game extends Backbone.Model
  # TODO: separate out game view!

  initialize: ->
    window.silo = new MissileCollection({})
    window.robotorium = new RobotCollection({})
    @listenTo(window.robotorium, "finalSurvivor", @finalSurvivor)
    @showInstructions()

  addRobot: (options)->
    r = new Robot(options)
    r.readRecord() if r.get('roboRecord')
    rView = new RobotView({model: r})
    cmdv = new RobotCommandView({model: r})
    cmdv.render()
    $('.arena').append(rView.render().el)
    window.robotorium.add(r)

  invite: (name)->
    @addRobot()
    bot = robotorium.models[robotorium.models.length-1]

  start: ->
    _(window.robotorium.models).each((bot)-> bot.startOnce())
    console.log('start')

  finalSurvivor: ->
    @winner = robotorium.models[0]
    alert "#{@winner.get('name')} is victorious!"
    @winner.die()
    @playerbot = null
    @enemybot = null

  loadRobot: (event, name)=>
    # name || name = prompt "Who would you like to load?", name
    @getEnemyNext = false
    unless name
      $('.rightbar').hide()
      $('.loader').show()
      return

    $('.rightbar').show()
    unless @playerbot
      botSource = @checkDBforBot(name, (result)=>
        @addRobot({
          roboRecord: result
          name: result.get('name')
          source: result.get('source')
        })
        @playerbot = robotorium.models[robotorium.models.length-1]
        @playerbot.readRecord()
      )
    else @playerbot.download(name)

  loadEnemy: (event, name)=>
    # name = name || prompt "Who would you like to load?"
    @getEnemyNext = true
    unless name
      $('.rightbar').hide()
      $('.loader').show()
      return

    $('.rightbar').show()
    unless @enemybot
      botSource = @checkDBforBot(name, (result)=>
        @addRobot({
          roboRecord: result
          name: result.get('name')
          source: result.get('source')
          enemy: true
        })
        @enemybot = robotorium.models[robotorium.models.length-1]
        @enemybot.readRecord()
      )
    else @enemybot.download(name)

  checkDBforBot: (name, foundCB, notFoundCB)=>
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    query = new Parse.Query('RoboScript')
    query.equalTo('name', name)
    that = @
    promise = query.first(
      success: (result)=>
        if (result)
          foundCB(result) if foundCB
        else
          notFoundCB() if notFoundCB
      error: (error)=>
        alert("Error fetching bot from Parse: #{error.message}")
    )

  getBotsStartingWith: (str, foundCB, noneCB)=>
    Parse.initialize("ws2K2mzPe0YayCqXOT50STBeZqFe3PJIvkwbmsyG", "Q32iv4tLwEOS5gEiWXwOBRQX2xtA75Fu5SRuIFV9");
    query = new Parse.Query('RoboScript')
    promise = query.limit(10).startsWith('name', str).find(
      success: (results)=>
        if (results)
          names = []
          window.results = results
          _(results).each (bot)->
              names.push(bot.get('name'))
          console.log names
          foundCB(names)
        else
          return false
    )

  hideInstructions: ()->
    $('.help').animate(
      opacity: 0
    , 1000, ()-> $('.help').hide()
    )
    $('.main').animate(
      opacity: 1
    , 1000
    )

  showInstructions: ()->
    $('.help').animate(
      opacity: 1
    , 1000
    )
    $('.main').animate(
      opacity: .4
    , 1000, ()-> $('.help').show()
    )

  updateBotSearch: ()=>
    search = $('.botsearch').val()
    $('.loader h3').text("Searching server for: " +search)
    bots = @getBotsStartingWith(search,
      (names)=>
        listEl = '<ul>'
        _(names).each (name)->
          listEl += "<li class='botSelect'>#{name}</li>"
        listEl += '</ul'>
        $('.loader ul').replaceWith(listEl)
    )

  selectBotToLoad: ()->
    if (game.getEnemyNext)
      game.loadEnemy(null, $(@).text())
    else
      game.loadRobot(null, $(@).text())
    $('.loader').hide()

$(document).ready ->
  window.game = new Game()
  $('.loader').hide()
  window.robotorium.models[0].die() #TODO prevent creation of default bot
  $('.addRobot').click(game.addRobot)
  $('.loadRobot').click(game.loadRobot)
  $('.start').click(game.start)
  $('.loadEnemy').click(game.loadEnemy)
  $('.help').click(game.hideInstructions)
  $('.instructions').click(game.showInstructions)
  $('.loader').on('keyup', game.updateBotSearch)
  $('.loader').on('click', '.botSelect', game.selectBotToLoad)

