Phaser = require "phaser"

###
# Class for player sprite. Handles user input.
#
# Features smooth acceleration with instant stopping, jump height controlled by
# length of button press, and allows a single air-jump after falling.
###

{playerCfg} = require './config.coffee'

class Player extends Phaser.Sprite

  constructor: (game, x, y) ->
    super(game, x, y, 'player')
    @game.physics.arcade.enable this
    @body.mass = playerCfg.mass
    @body.maxVelocity.x = playerCfg.maxSpeed
    @body.maxVelocity.y = playerCfg.maxFallSpeed
    @body.bounce.y = playerCfg.bounce
    @body.collideWorldBounds = true

    @platform = null
    @jumpEvent = null
    @jumping = false
    @canJump = false

  jump: ->
    @jumping = true
    @canJump = false
    @body.velocity.y = -1 * playerCfg.jumpSpeed
    @jumpEvent = @game.time.events.add(playerCfg.jumpTime, @endJump, this)

  endJump: ->
    @body.velocity.y = Math.max(@body.velocity.y / 2, @body.velocity.y)
    @jumping = false

  update: ->
    switch
      when @game.cursors.left.isDown
        @body.velocity.x -= playerCfg.acceleration
      when @game.cursors.right.isDown
        @body.velocity.x += playerCfg.acceleration
      else
        @body.velocity.x = 0

    if @body.touching.down
      @canJump = true
        
    if @jumping and not @game.cursors.up.isDown
      @game.time.events.remove(@jumpEvent)
      @endJump()

    if @game.cursors.up.isDown and @canJump
      @jump()

  onPlatform: (platform) ->
    # Hyperlink
    if @game.cursors.down.isDown and @body.touching.down and platform.link?
      @game.state.start('LoadPage', true, false, platform.link)


module.exports = Player
