arcs = require './groupped-arcs.json'
window.d3 = require "d3/d3.min.js"
window.topojson = require "topojson"
require "datamaps/dist/datamaps.world.min.js"

window.start = (max) ->
  document.getElementById("map").innerHTML = ''
  map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
  map.arc arcs[0..max]
start(arcs.length)

return

randColor = ->
  Math.round Math.random() * 255
for arc, i in arcs
  rgb = "rgb(#{randColor()}, #{randColor()}, #{randColor()})"
  $('.datamaps-arc').eq(i).css
    stroke: rgb