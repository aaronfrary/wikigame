###
# Fetch a Wikipedia page using JSONP.
#
# Should switch to something more elegant in the future. In particular there's
# no way to set user-agent headers using JSONP, and we don't want to make the
# Wikimedia people mad.
###

getJSONP = (url, succeed, fail, context) ->
  ud = '_' + +new Date
  script = document.createElement 'script'
  head = (document.getElementsByTagName 'head')[0] || document.documentElement

  finished = 'finished' + ud
  window[finished] = false
  window[ud] = (data) ->
    window[finished] = true
    head.removeChild script
    succeed && succeed.call(context, data)

  script.src = url + '&callback=' + ud
  head.appendChild script

  setTimeout((->
    fail.call(context, new Error('Network Error')) unless window[finished]),
    5000)

module.exports =

  getPage: (title, succeed, fail, context) ->
    url = "https://en.wikipedia.org/w/api.php?action=query" +
          "&titles=#{title}&prop=revisions&rvprop=content&continue=" +
          "&format=json&formatversion=2"
    getJSONP(url, succeed, fail, context)
