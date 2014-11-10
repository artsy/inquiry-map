# inquiry-map

Generates a map visualization of Artsy inquiry location to gallery location. Used internally at Artsy and not useful to general public—but open source by default!

## Setup

1. Copy the following collections from Artsy database to your local `gravity_development` mongo.

* artwork_inquiry_requests
* partner_locations
* partners
* users
* artworks

2. Install node modules

`npm install`

3. Generate the geo points data and output the bundle

`npm run d && npm run c`

4. Open public/index.html