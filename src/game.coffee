Phaser = require "phaser"

###
# Main game state.
#
# Creates player and sets up camera. Handles collisions and lazy rendering of
# blocks, which will have been created and passed in from the previous state.
###

{spacing} = require './config.coffee'
Player = require './player.coffee'
FollowCamera = require './camera.coffee'

class Game extends Phaser.State

  constructor: -> super

  init: (@blocks) ->
    console.log @blocks.length + ' blocks'
    return

  create: ->
    @movers = @add.group()
    @player = new Player(@game, spacing.padding + 32,
                                spacing.padding - 48,
                                'player')
    @movers.add @player

    @focus = @add.existing(new FollowCamera(@game, @player))

  update: ->
    # Lazy Rendering
    top = @camera.y
    bottom = top + @camera.height
    top = Math.min(top, @player.body.top)
    bottom = Math.max(bottom, @player.body.bottom)

    for block in @blocks
      if block.top <= bottom or block.bottom >= top
        @world.add block.group unless block.onScreen
        block.onScreen = true
      else
        @world.remove block.group if block.onScreen
        block.onScreen = false

    # Collisions
    for block in @blocks when block.onScreen
      @physics.arcade.collide(@movers, block.group, (mover, platform) ->
        if platform.onCollision?
          platform.onCollision mover
        if mover.onPlatform?
          mover.onPlatform platform
      )

module.exports = Game
