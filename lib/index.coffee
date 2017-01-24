arcs = require './groupped-arcs.json'
# arcs = require './arcs.json'

# window.start = (max) ->
#   document.getElementById("map").innerHTML = ''
#   map = new Datamap
#     element: document.getElementById("map")
#     projection: "mercator"
#   map.arc arcs[0..max]
# start(arcs.length)

return

randColor = ->
  Math.round Math.random() * 255
for arc, i in arcs
  rgb = "rgb(#{randColor()}, #{randColor()}, #{randColor()})"
  $('.datamaps-arc').eq(i).css
    stroke: rgb
