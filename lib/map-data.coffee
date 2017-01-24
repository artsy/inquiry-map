#
# Maps data from the gravity_development mongo db into something the map can use.
#

fs = require 'fs'
async = require 'async'
mongojs = require "mongojs"

pg = require 'pg'

pgClient = new pg.Client('postgres://localhost/artsy-impulse-production');

db = mongojs "mongodb://localhost:27017/gravity_development", [
  "partner_locations"
  "partners"
  "users"
  "artworks"
]

# Writes the JSON from `all_data` to a JSON file

write_all_data =  () -> 
  json = JSON.stringify (for data in all_data when data?.origin?.latitude and data?.destination?.latitude
    origin: data.origin
    destination: data.destination
  )
  fs.writeFileSync __dirname + '/arcs.json', json

# We need to be cautious around node process memory limits
# so we move all data into this global
all_data = []
show_results = false

db.on 'error', (err) ->
  console.log('mongo error', err)

pgClient.connect (err) -> 
  console.error(err)  if err

  # add `LIMIT 10` to do dev
  sql = "SELECT to_id, to_type, from_id, from_type, created_at FROM conversations WHERE to_id != '' AND from_id != ''"

  pgClient.query sql, (err, results) ->
      async.eachLimit results.rows, 5, (inquiry, nextRow) ->
        # Dig down the relations and pull out user/partner coordinates
        async.parallel [
          (cb) ->
            from_id = mongojs.ObjectId(inquiry.from_id)
            if inquiry.from_type == "User"
              db.users.findOne { _id: from_id }, (err, user) ->
                return cb() unless user?.location?
                cb err, user.location.coordinates
            else if inquiry.from_type == "AnonymousSession"
              db.anaonymous_sessions.findOne { _id: from_id }, (err, session) ->
                  return cb() unless session?.location?
                  cb err, user.location.coordinates
            else
              cb()

          (cb) ->
            to_id = mongojs.ObjectId(inquiry.to_id)
            if inquiry.to_type == "Partner"
              db.partners.findOne { _id: to_id }, (err, partner) ->
                return cb err if err
                return cb() unless partner?._id?
                db.partner_locations.findOne { partner_id: partner._id }, (err, location) ->
                  cb err, location?.coordinates
            else
              cb()
        ], (err, res) ->
          # Insert a new coordinate
          unless res[0]? and res[1]?
            process.stdout.write(".") if show_results
            
          else
            data =
              origin:
                latitude: res[0][1]
                longitude: res[0][0]
              destination:
                latitude: res[1][1]
                longitude: res[1][0]
            all_data.push(data)
            process.stdout.write("X") if show_results

          nextRow()
      
      # The completion  block for the each
      , (err, result) -> 
        console.log("\n Shipped to libs/arcs.json")
        write_all_data()
        process.exit()
          
