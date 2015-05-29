Phaser = require 'phaser'

###
# Page setup for main game state.
#
# Builds page from list of word objects, separating them into fixed size
# "blocks" that are only rendered and processed when part of the block is on
# screen. Shows a loading bar based on the number of blocks loaded.
###

{spacing, type} = require './config.coffee'
Word = require './word.coffee'


class DrawPage extends Phaser.State

  constructor: -> super

  # Helper function
  drawHoriz: (y) ->
    gfx = @add.graphics(0, 0)
    gfx.lineStyle(1, 0x808080, 1)
    gfx.moveTo(spacing.padding, y)
    gfx.lineTo(spacing.length, y)

  init: (@words) ->
    console.log @words.length + ' words'
    @x = @y = spacing.padding
    @lastType = type.NEWLINE
    @blocks = []
    @idx = 0
    @numBlocks = 1 + @words.length // spacing.blockSize

  create: ->
    @loadSprite = @add.sprite @game.camera.width/2 - 200,
                              @game.camera.height/2 - 20,
                              'preloadBar'
    @loadSprite.fixedToCamera = true
    @loadWidth = @loadSprite.width
    @loadRect = new Phaser.Rectangle(0, 0, 1, @loadSprite.height)
    @loadSprite.crop @loadRect

  update: ->
    if @idx >= @words.length
      @world.resize(spacing.length + 2 * spacing.padding,
                    @w.bottom + spacing.padding)
      @loadSprite.destroy()
      return @state.start('Game', false, false, @blocks)

    # Create one block of words per call to update()
    block =
      group: new Phaser.Group(@game, null)
      onScreen: false
      top: @y
      bottom: @y
    for i in [0 ... spacing.blockSize]
      word = @words[@idx++]
      if @idx > @words.length
        break

      # NEWLINE does not generate text
      if word.t is type.NEWLINE
        @x = spacing.padding
        @y += switch @lastType
          when type.TITLE0
            spacing.beforeTagline
          when type.TAGLINE, type.TITLE1, type.TITLE2, type.TITLE3
            spacing.afterTitle
          else
            spacing.paragraph
        @lastType = word.t
        continue

      # No spacing between word and punctuation
      if @lastType is type.PRE or word.t is type.POST
        @x -= spacing.word
      # Consider line break
      else if @x > spacing.length
        @x = spacing.padding
        @y += spacing.line

      # Create text
      @w = new Word(@game, @x, @y, word)
      block.group.add @w

      # Add lines under titles
      if @lastType is type.NEWLINE and (word.t is type.TITLE0 or
                                        word.t is type.TITLE1)
        @drawHoriz @w.bottom

      @x += @w.width + spacing.word
      @lastType = word.t

    # Finish block
    block.bottom = @y
    @blocks.push block

    # Update loading bar
    @loadRect.width = Math.floor(@loadWidth * @blocks.length / @numBlocks)
    @loadSprite.updateCrop()

module.exports = DrawPage
