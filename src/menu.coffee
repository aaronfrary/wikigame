Phaser = require 'phaser'

###
# Placeholder for real menu
###

config = require './config.coffee'

class Menu extends Phaser.State
  constructor: -> super

  init: (@error) ->
    return

  create: ->
    logo = @add.sprite(@game.world.centerX, @game.world.centerY,
                       'wikipediaLogo')
    logo.anchor.setTo(0.5, 1)

    x = @game.world.centerX
    y = @game.world.centerY
    fontSize = 32
    if @error?
      console.log @error
      message = @error.name + ': ' + @error.message
      fill = '#F00'
      text = @add.text(x, y, message, {fontSize, fill})
      text.anchor.setTo(0.5, 0)

    message = '\n\nClick to start'
    fill = '#000'
    text = @add.text(x, y, message, {fontSize, fill})
    text.anchor.setTo(0.5, 0)

  update: ->
    if @input.activePointer.justPressed()
      @state.start('LoadPage', true, false, config.startPage)

module.exports = Menu
