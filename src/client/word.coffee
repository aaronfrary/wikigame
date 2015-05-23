Phaser = require "phaser"

###
# Generates a solid text sprite from a word object.
###

{type} = require '../shared.coffee'
{wordCfg} = require './config.coffee'

class Word extends Phaser.Text

  constructor: (game, x, y, word) ->
    text = word.w
    style = {} # Shallow copy
    style[k] = v for k,v of wordCfg.defaultStyle

    if word.t is type.LINK
      style.fill = wordCfg.linkColor.blue

    super(game, x, y, text, style)

    @game.physics.arcade.enable this
    @body.allowGravity = false
    @body.immovable = true

module.exports = Word
