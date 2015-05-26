Phaser = require 'phaser'

###
# Patch together game states and start phaser in Boot state.
###

config = require './config.coffee'
Boot = require './boot.coffee'
Preload = require './preload.coffee'
Menu = require './menu.coffee'
LoadPage = require './loadpage.coffee'
Game = require './game.coffee'

if config.debug
  for state in [Menu, Game]
    state::render = ->
      @game.debug.text(@time.fps or '--', 2, 14, '#00FF00')

game = new Phaser.Game(config.width, config.height, Phaser.AUTO, config.id)
game.state.add('Boot', Boot)
game.state.add('Preload', Preload)
game.state.add('Menu', Menu)
game.state.add('LoadPage', LoadPage)
game.state.add('Game', Game)
game.state.start 'Boot'
