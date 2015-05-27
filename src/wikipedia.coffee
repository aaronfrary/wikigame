wikitext = require "./wikitext.coffee"

###
# Fetch a Wikipedia page using JSONP.
#
# Should switch to something more elegant in the future. In particular there's
# no way to set user-agent headers using JSONP, and we don't want to make the
# Wikimedia people mad.
###

getJSONP = (url, callback) ->
  ud = '_' + +new Date
  script = document.createElement 'script'
  head = (document.getElementsByTagName 'head')[0] || document.documentElement

  window[ud] = (data) ->
    head.removeChild script
    callback && (callback data)

  script.src = url + '&callback=' + ud
  head.appendChild script

module.exports =

  getPage: (title, callback) ->
    url = "https://en.wikipedia.org/w/api.php?action=query" +
          "&titles=#{title}&prop=revisions&rvprop=content&continue=" +
          "&format=json&formatversion=2"
    onload = (data) ->
      content = wikitext.parse(title, data.query.pages[0].revisions[0].content)
      callback content
    getJSONP(url, onload)

