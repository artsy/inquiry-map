#
# Take a set of arcs, and pick a random 1 in 100
# yarn run coffee -- lib/one-in-100.coffee
#

arcs = require './jsons/deduped.json'
fs = require 'fs'

random = (min, max) -> Math.round(Math.random() * (max - min) + min)

luckyOnes = arcs.filter (arc) -> random(0, 100) == 23
console.log "There are #{luckyOnes.length} arcs from #{arcs.length} in /jsons/one-in-one-hundred.json"

fs.writeFileSync __dirname + '/jsons/one-in-one-hundred.json', JSON.stringify luckyOnes
