Phaser = require "phaser"

###
# Main game state.
#
# Builds page from list of word objects, creates player, and checks for
# collisions.
###

config = require './config.coffee'
{type} = require '../shared.coffee'
Word = require './word.coffee'
Player = require './player.coffee'
FollowCamera = require './camera.coffee'

class Game extends Phaser.State

  constructor: -> super

  init: (@words) ->
    return

  create: ->
    # Platform setup
    @platforms = @add.group()

    x = y = config.spacing.padding
    pre = false
    for word in @words
      # Special case, NEWLINE does not generate text
      if word.t is type.NEWLINE
        x = config.spacing.padding
        y += config.spacing.paragraph / 2
        continue
      # Handle punctuation
      if pre or word.t is type.POST
        x -= config.spacing.word
      else if x > config.spacing.length
        x = config.spacing.padding
        y += config.spacing.line
      pre = word.t is type.PRE
      # Create text
      w = @add.existing(new Word(@game, x, y, word))
      @platforms.add w
      x += w.width + config.spacing.word

    @world.resize(config.spacing.length + 2 * config.spacing.padding,
                  w.bottom + config.spacing.padding)

    # Player setup
    @player = @add.existing(
      new Player(@game, config.spacing.padding + 32, 0, 'player')
    )
    @focus = @add.existing(new FollowCamera(@game, @player))

  update: ->
    @physics.arcade.collide(@player, @platforms)

module.exports = Game
