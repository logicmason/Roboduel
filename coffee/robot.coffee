class window.Robot extends Backbone.Model
  defaults:
    dir: 0
    hp: 100
    maxHP: 100
    damage: 5
    name: "robot"
    position:
      x:0
      y:0
    speed:
      x:0
      y:0

  die: ->
    console.log "#{@attributes.name} has died"

