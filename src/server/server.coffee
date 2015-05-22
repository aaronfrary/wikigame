http = require 'http'
url = require 'url'
fs = require 'fs'
request = require 'request'
nodeStatic = require 'node-static'

wikitext = require './wikitext.js'

port = 8585
webroot = './public'

###
# Basic server, good enough for testing.
###

file = new nodeStatic.Server(webroot, {cache: 600}) # Cache for 10 minutes

http.createServer( (clientRequest, clientResponse) ->
  query = url.parse(clientRequest.url, true).query.q
  if not query?
    file.serve(clientRequest, clientResponse)
  else
    # FIXME: unsafe
    title = query

    queryURL = "https://en.wikipedia.org/w/api.php?action=query" +
               "&titles=#{title}&prop=revisions&rvprop=content" +
               "&continue=&format=json&formatversion=2"

    request {url: queryURL, json: true}, (error, response, body) ->
      switch
        when error
          clientResponse.writeHead(500)
          clientResponse.end()
        when response.statusCode is not 200
          clientResponse.writeHead(statusCode)
          clientResponse.end()
        else
          content = wikitext.parse body.query.pages[0].revisions[0].content
          data = JSON.stringify content
          clientResponse.writeHead(200, 'Content-Type': 'application/json')
          clientResponse.write data
          clientResponse.end()

).listen port

console.log 'node-static running at localhost:' + port

