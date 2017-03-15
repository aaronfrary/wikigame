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
    @anchor.setTo(0.5, 0.5)

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
        @scale.x = -1
      when @game.cursors.right.isDown
        @body.velocity.x += playerCfg.acceleration
        @scale.x = 1
      else
        @body.velocity.x = 0

    if @body.touching.down
      @canJump = true
        
    if @jumping and not @game.cursors.up.isDown
      @game.time.events.remove(@jumpEvent)
      @endJump()

    if @game.cursors.up.isDown and @canJump
      @jump()

    # Have we hit the bottom?
    if @body.blocked.down and not @body.touching.down
      @onKilled()

  onPlatform: (platform) ->
    # Hyperlink
    if @game.cursors.down.isDown and @body.touching.down and platform.link?
      @game.state.start('LoadPage', true, false, platform.link)

  onKilled: ->
    # Placeholder:
    @game.state.start('Menu', true, false, 'You died!')

module.exports = Player
