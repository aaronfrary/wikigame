Phaser = require 'phaser'

###
# Request parsed (JSON) wiki page from server before starting main game state.
###

config = require './config.coffee'
wikipedia = require './wikipedia.coffee'

class LoadPage extends Phaser.State
  constructor: -> super

  init: (@pageTitle) ->
    return

  create: ->
    wikipedia.getPage(@pageTitle, (page) =>
      @state.start('DrawPage', true, false, page)
    )

module.exports = LoadPage

