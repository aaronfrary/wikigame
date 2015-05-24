Phaser = require "phaser"

###
# Main game state.
#
# Builds page from list of word objects, creates player, and checks for
# collisions.
###

{spacing} = require './config.coffee'
{type} = require '../shared.coffee'
Word = require './word.coffee'
Player = require './player.coffee'
FollowCamera = require './camera.coffee'

class Game extends Phaser.State

  constructor: -> super

  init: (@words) ->
    return

  create: ->
    # Platforms setup
    # TODO: clean up this code
    x = y = spacing.padding
    pre = false
    @blocks = []
    block =
      group: @add.group()
      visible: true
      top: y
    for word in @words
      # Special case, NEWLINE does not generate text
      if word.t is type.NEWLINE
        x = spacing.padding
        y += spacing.paragraph / 2
        continue
      # Handle punctuation
      if pre or word.t is type.POST
        x -= spacing.word
      else if x > spacing.length
        x = spacing.padding
        y += spacing.line
      if y > spacing.blockSize * (@blocks.length + 1)
        block.bottom = y
        @blocks.push block
        block =
          group: new Phaser.Group(@game, null)
          visible: false
          top: y
      pre = word.t is type.PRE
      # Create text
      w = new Word(@game, x, y, word)
      block.group.add w
      x += w.width + spacing.word
    block.bottom = y
    @blocks.push block

    @world.resize(spacing.length + 2 * spacing.padding,
                  w.bottom + spacing.padding)

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
        @world.add block.group unless block.visible
        block.visible = true
      else
        @world.remove block.group if block.visible
        block.visible = false

    # Collide
    for block in @blocks when block.visible
      @physics.arcade.collide(@movers, block.group, (mover, platform) ->
        if platform.onCollision?
          platform.onCollision mover
        if mover.onPlatform?
          mover.onPlatform platform
      )

module.exports = Game
