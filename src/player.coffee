Phaser = require "phaser"

###
# Class for player sprite. Handles user input.
###

{playerCfg} = require './config.coffee'

class Player extends Phaser.Sprite

  constructor: (game, x, y) ->
    super(game, x, y, 'player')
    @game.physics.arcade.enable this
    @body.mass = playerCfg.mass
    @body.bounce.y = playerCfg.bounce
    @body.collideWorldBounds = true

    @body.setSize(28, 40, 2, 8)

    @animations.add('left', [0, 1, 2, 3], 10, true)
    @animations.add('right', [5, 6, 7, 8], 10, true)
    @platform = null

  update: ->
    @body.velocity.x = 0
    switch
      when @game.cursors.left.isDown
        @body.velocity.x = -1 * playerCfg.speed
        @animations.play 'left'
      when @game.cursors.right.isDown
        @body.velocity.x = playerCfg.speed
        @animations.play 'right'
      else
        @animations.stop()
        @frame = 4

    # Jump
    if @game.cursors.up.isDown and @body.touching.down
      @body.velocity.y = -1 * playerCfg.jumpHeight

  onPlatform: (platform) ->
    # Hyperlink
    if @game.cursors.down.isDown and @body.touching.down and platform.link?
      @game.state.start('LoadPage', true, false, platform.link)


module.exports = Player
