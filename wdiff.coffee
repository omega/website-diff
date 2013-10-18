page = require('webpage').create()
system = require 'system'

page.viewportSize = width: 1024, height: 1500

address = system.args[1]
output = system.args[2]
id = system.args[3]

console.log "about to open #{address} and save to #{output}"
page.open address, (status) ->
  console.log "in open callback", status
  if status != "success"
    console.log "unable to load #{address}"
    phantom.exit 1
  else
    top = page.evaluate (id) ->
      console.log "in evaluate call", id
      window.scrollTo(0,1000)
      window.scrollTo(0,document.getElementById(id).offsetTop)
      return document.getElementById(id).offsetTop
    , id
    page.scrollPosition = top: top, left: 0
    window.setTimeout ->
      console.log "in timeout"
      page.render output
      console.log "rendered"
      phantom.exit 0
    , 5200


