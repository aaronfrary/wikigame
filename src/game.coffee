Phaser = require "phaser"

###
# Main game state.
#
# Builds page from list of word objects, separating them into fixed size
# "blocks" that are only rendered and processed when part of the block is on
# screen. Also creates player and sets up camera.
#
# Handles collisions and lazy rendering of blocks.
###

{spacing, type} = require './config.coffee'
Word = require './word.coffee'
Player = require './player.coffee'
FollowCamera = require './camera.coffee'

class Game extends Phaser.State

  constructor: -> super

  init: (@words) ->
    return

  create: ->
    # Platforms setup {{{
    x = y = spacing.padding
    lastType = null
    @blocks = []
    # First block
    block =
      group: @add.group()
      onScreen: true
      top: y
    for word in @words
      # NEWLINE does not generate text
      if word.t is type.NEWLINE
        x = spacing.padding
        y += spacing.paragraph / 2
        continue
      # No spacing between word and punctuation
      if lastType is type.PRE or word.t is type.POST
        x -= spacing.word
      # Consider line break
      else if x > spacing.length
        x = spacing.padding
        y += spacing.line
      # Consider block break
      if y > spacing.blockSize * (@blocks.length + 1)
        block.bottom = y
        @blocks.push block
        block =
          group: new Phaser.Group(@game, null)
          onScreen: false
          top: y
      # Create text
      w = new Word(@game, x, y, word)
      block.group.add w
      x += w.width + spacing.word
      lastType = word.t
    # Wrap up
    block.bottom = y
    @blocks.push block

    @world.resize(spacing.length + 2 * spacing.padding,
                  w.bottom + spacing.padding)
    # }}}

    # Player setup
    @movers = @add.group()
    @player = new Player(@game, spacing.padding + 32,
                                spacing.padding - 48,
                                'player')
    @movers.add @player

    # Camera setup
    @focus = @add.existing(new FollowCamera(@game, @player))

    # Get some stats
    console.log @blocks.length

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
