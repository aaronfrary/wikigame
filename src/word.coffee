Phaser = require "phaser"

###
# Generates a solid text sprite from a word object.
###

{wordCfg, type} = require './config.coffee'

class Word extends Phaser.Text

  constructor: (game, x, y, word) ->
    text = word.w
    style = {} # Shallow copy
    style[k] = v for k,v of wordCfg.defaultStyle

    if word.t is type.LINK
      style.fill = wordCfg.linkColor.blue
    if word.t is type.ITAL
      style.fontStyle = 'italic'
    if word.t is type.BOLD
      style.fontWeight = 'bold'
    if word.t is type.TAGLINE
      style.fontSize = wordCfg.size.note
    if word.t is type.TITLE0
      style.font = 'Serif'
      style.fontSize = wordCfg.size.t0
    if word.t is type.TITLE1
      style.font = 'Serif'
      style.fontSize = wordCfg.size.t1
    if word.t is type.TITLE2
      style.fontSize = wordCfg.size.t2
    if word.t is type.TITLE3
      style.fontSize = wordCfg.size.t3

    super(game, x, y, text, style)

    @link = word.link

    @game.physics.arcade.enable this
    @body.allowGravity = false
    @body.immovable = true

module.exports = Word
