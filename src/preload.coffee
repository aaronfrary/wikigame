Phaser = require 'phaser'

###
# Loads assets used throughout the game. Does not deal with wiki pages.
###

config = require './config.coffee'

class Preload extends Phaser.State
  constructor: -> super

  preload: ->
    # Show loading screen
    @load.setPreloadSprite(@add.sprite @game.world.centerX - 200,
                                       @game.world.centerY - 20,
                                       'preloadBar')

    # Set up game defaults
    @stage.backgroundColor = '#fff'
    @game.renderer.renderSession.roundPixels = true
    @time.advancedTiming = config.debug

    @physics.startSystem Phaser.Physics.ARCADE
    @physics.arcade.gravity.y = config.gravity

    @game.cursors = @input.keyboard.createCursorKeys()

    # Load game assets
    @load.pack('main', config.pack)

  create: ->
    @state.start 'Menu'

module.exports = Preload
