Phaser = require "phaser"

###
# Generates a solid text sprite from a word object.
###

{type} = require '../shared.coffee'

class Word extends Phaser.Text

  constructor: (game, x, y, word) ->
    text = word.w
    style =
      fontSize: '32px'
      fill: '#000'
    super(game, x, y, text, style)
    @game.physics.arcade.enable this
    @body.allowGravity = false
    @body.immovable = true

module.exports = Word
