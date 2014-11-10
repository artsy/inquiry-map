arcs = require './arcs.json'
window.d3 = require "d3/d3.min.js"
window.topojson = require "topojson"
require "datamaps/dist/datamaps.world.min.js"

window.start = (max) ->
  document.getElementById("map").innerHTML = ''
  map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
  map.arc arcs[0..max]
start(7000)