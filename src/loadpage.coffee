Phaser = require 'phaser'

###
# Request parsed (JSON) wiki page from server before starting main game state.
###

config = require './config.coffee'
wikipedia = require './wikipedia.coffee'

class LoadPage extends Phaser.State
  constructor: -> super

  init: (@pageTitle) ->
    return

  preload: ->
    # Show loading screen
    @load.setPreloadSprite(@add.sprite @game.world.centerX - 160,
                                       @game.world.centerY - 16,
                                       'preloadBar')

  create: ->
    wikipedia.getPage(@pageTitle, (page) =>
      @state.start('Game', true, false, page)
    )

module.exports = LoadPage

