#
# Uses arcs.json to calculate the average distance of an inquiry
#

arcs = require './arcs.json'
Distance = require('geo-distance')

distances = for arc in arcs
  d = Distance.between(
    { lat: arc.destination.latitude, lon: arc.destination.longitude }
    { lat: arc.origin.latitude, lon: arc.origin.longitude }
  )
  Number d.human_readable().distance
total = 0
total += d for d in distances
console.log "The average distance between inquirer and partner is: " +
  "#{km = Math.round total / distances.length}km or #{Math.round km * 0.621371} miles"