Phaser = require 'phaser'

###
# Placeholder for real menu
###

config = require './config.coffee'

class Menu extends Phaser.State
  constructor: -> super

  create: ->
    logo = @add.sprite(@game.world.centerX, @game.world.centerY,
                       'wikipediaLogo')
    logo.anchor.setTo(0.5, 1)

    text = @add.text(@game.world.centerX, @game.world.centerY,
      'Click to Start', { fontSize: '32px', fill: '#000' })
    text.anchor.setTo(0.5, 0)

  update: ->
    if @input.activePointer.justPressed()
      @state.start('LoadPage', true, false, config.startPage)

module.exports = Menu
