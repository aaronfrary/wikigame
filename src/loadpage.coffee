Phaser = require 'phaser'

###
# Request parsed (JSON) wiki page from server before starting main game state.
###

config = require './config.coffee'
wikipedia = require './wikipedia.coffee'
wikitext = require './wikitext.coffee'

class LoadPage extends Phaser.State
  constructor: -> super

  init: (@title) ->
    console.log @title
    return

  create: ->
    x = @game.camera.width / 2
    y = @game.camera.height / 2
    message = 'Loading...'
    fontSize = 32
    fill = '#000'
    text = @add.text(x, y, message, {fontSize, fill})
    text.anchor.setTo(0.5, 0.5)
    text.fixedToCamera = true

    succeed = (data) ->
      page = wikitext.parse(@title, data.query.pages[0].revisions[0].content)
      @state.start('DrawPage', true, false, page)

    fail = (error) ->
      @state.start('Menu', true, false, error)

    wikipedia.getPage(@title, succeed, fail, this)

module.exports = LoadPage

