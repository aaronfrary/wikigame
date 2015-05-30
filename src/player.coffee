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

    @platform = null
    @jumpEvent = null

  jump: ->
    @jumping = true
    @body.velocity.y = -1 * playerCfg.jumpSpeed
    @jumpEvent = @game.time.events.add(playerCfg.jumpTime, @endJump, this)

  endJump: ->
    @body.velocity.y = Math.max(@body.velocity.y / 2, @body.velocity.y)
    @jumping = false

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
        
    if @jumping and not @game.cursors.up.isDown
      @game.time.events.remove(@jumpEvent)
      @endJump()

    if @game.cursors.up.isDown and @body.touching.down
      @jump()

  onPlatform: (platform) ->
    # Hyperlink
    if @game.cursors.down.isDown and @body.touching.down and platform.link?
      @game.state.start('LoadPage', true, false, platform.link)


module.exports = Player
