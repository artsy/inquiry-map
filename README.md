# inquiry-map

Generates a map visualization of Artsy inquiry location to gallery location. Used internally at Artsy and not useful to general public—but open source by default!

## Setup

Copy the following collections from Artsy database to your local `gravity_development` mongo.

* artwork_inquiry_requests
* partner_locations
* partners
* users
* artworks

Install node modules

`npm install`

Generate the geo points data and output the bundle

`npm run d && npm run c`

Open public/index.html