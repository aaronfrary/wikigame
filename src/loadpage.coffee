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
    succeed = (data) ->
      page = wikitext.parse(@title, data.query.pages[0].revisions[0].content)
      @state.start('DrawPage', true, false, page)

    fail = (error) ->
      @state.start('Menu', true, false, error)

    wikipedia.getPage(@title, succeed, fail, this)

module.exports = LoadPage

