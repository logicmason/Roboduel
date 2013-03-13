class window.RobotCollection extends Backbone.Collection
  model: Robot
  initialize: ->
    @on "destroy", @botDied

  botDied: ->
    @.remove()
    console.log "#{@.models.length} survivors left"
    @trigger "finalSurvivor" if @models.length == 1
