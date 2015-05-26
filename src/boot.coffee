Phaser = require 'phaser'

###
# Prepare loading bar image to show during preload.
###

config = require './config.coffee'

class Boot extends Phaser.State
  constructor: -> super

  preload: ->
    @load.pack('boot', config.pack)

  create: ->
    @state.start 'Preload'

module.exports = Boot
