Phaser = require 'phaser'

###
# Placeholder for real menu.
###

config = require './config.coffee'

class Menu extends Phaser.State
  constructor: -> super

  init: (@error) ->
    return

  create: ->
    x = @game.camera.width / 2
    y = @game.camera.height / 2

    logo = @add.sprite(x, y, 'wikipediaLogo')
    logo.anchor.setTo(0.5, 1)
    logo.fixedToCamera = true

    fontSize = 32
    if @error?
      console.log @error
      message =
        if @error.name? and @error.message?
          @error.name + ': ' + @error.message
        else
          @error
      fill = '#F00'
      text = @add.text(x, y, message, {fontSize, fill})
      text.anchor.setTo(0.5, 0)
      text.fixedToCamera = true

    message = '\n\nClick to start'
    fill = '#000'
    text = @add.text(x, y, message, {fontSize, fill})
    text.anchor.setTo(0.5, 0)
    text.fixedToCamera = true

  update: ->
    if @input.activePointer.justPressed()
      @state.start('LoadPage', true, false, config.startPage)

module.exports = Menu
