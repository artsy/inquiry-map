#
# Maps data from the gravity_development mongo db into something the map can use.
#

fs = require 'fs'
async = require 'async'
mongojs = require "mongojs"
db = mongojs "mongodb://localhost:27017/gravity_development", [
  "artwork_inquiry_requests"
  "partner_locations"
  "partners"
  "users"
  "artworks"
]

# Drop the old collection and query inquiries
db.artwork_inquiry_requests.find().toArray (err, inquiries) ->

  queries = for inquiry in inquiries
    ((inquiry) -> (callback) ->

      # Dig down the relations and pull out user/partner coordinates
      async.parallel [
        (cb) ->
          db.users.findOne { _id: inquiry.user_id }, (err, user) ->
            return cb() unless user?.location?
            cb err, user.location.coordinates
        (cb) ->
          db.artworks.findOne { _id: inquiry.artwork_id }, (err, artwork) ->
            return cb err if err
            return cb() unless artwork?.partner_id?
            db.partners.findOne { _id: artwork.partner_id }, (err, partner) ->
              return cb err if err
              return cb() unless partner?._id?
              db.partner_locations.findOne { partner_id: partner._id }, (err, location) ->
                cb err, location?.coordinates
      ], (err, res) ->

        # Insert a new coordinate
        unless res[0]? and res[1]?
          console.log '.'
          return callback()
        data =
          origin:
            latitude: res[0][1]
            longitude: res[0][0]
          destination:
            latitude: res[1][1]
            longitude: res[1][0]
        console.log "Found! ", data
        callback null, data
    )(inquiry)
  async.parallel queries, (err, res) ->
    json = JSON.stringify (for data in res when data?.origin?.latitude and data?.destination?.latitude
      origin: data.origin
      destination: data.destination
    )
    fs.writeFileSync __dirname + '/arcs.json', json
    process.exit()

