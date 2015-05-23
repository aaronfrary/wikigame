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
    @platforms = @add.group()
    @movers = @add.group()

    x = y = spacing.padding
    pre = false
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
      pre = word.t is type.PRE
      # Create text
      w = @add.existing(new Word(@game, x, y, word))
      @platforms.add w
      x += w.width + spacing.word

    @world.resize(spacing.length + 2 * spacing.padding,
                  w.bottom + spacing.padding)

    # Player setup
    @player = @add.existing(
      new Player(@game, spacing.padding + 32,
                        spacing.padding - 48 * 2,
                        'player')
    )
    @movers.add @player

    @focus = @add.existing(new FollowCamera(@game, @player))

  update: ->
    @physics.arcade.collide(@movers, @platforms, (mover, platform) ->
      if platform.onCollision?
        platform.onCollision mover
      if mover.onPlatform?
        mover.onPlatform platform
    )

module.exports = Game
