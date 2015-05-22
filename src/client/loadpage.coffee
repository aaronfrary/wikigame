Phaser = require 'phaser'

###
# Request parsed (JSON) wiki page from server before starting main game state.
###

config = require './config.coffee'

class LoadPage extends Phaser.State
  constructor: -> super

  init: (@pageTitle) ->
    return

  preload: ->
    # Show loading screen
    @load.setPreloadSprite(@add.sprite @game.world.centerX - 160,
                                       @game.world.centerY - 16,
                                       'preloadBar')

    @load.json('page', './?q=' + @pageTitle)

  create: ->
    page = @cache.getJSON 'page'
    @cache.removeJSON 'page'

    @state.start('Game', true, false, page)

module.exports = LoadPage

