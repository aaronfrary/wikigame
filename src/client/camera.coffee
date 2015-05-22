Phaser = require "phaser"

###
# Allows game camera to follow an object (e.g. the player) slowly.
###

config = require './config.coffee'

class FollowCamera extends Phaser.Sprite

  constructor: (game, @target) ->
    super(game, @target.x, @target.y, null)
    @game.camera.bounds = null
    @game.camera.follow this
    @game.physics.arcade.enable this
    @body.allowGravity = false

  update: ->
    return unless @target?
    dx = @position.distance @target
    speed = (dx > config.camera.slack) and (dx**2 / config.camera.delay)
    @game.physics.arcade.moveToObject(this, @target, speed)

module.exports = FollowCamera
