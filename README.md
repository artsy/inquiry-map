# inquiry-map

Generates a map visualization of Artsy inquiry location to gallery location. Used internally at Artsy and not useful to general public—but open source by default!

## Setup

Copy the following collections from Artsy database to your local `gravity_development` mongo.

* `partner_locations`
* `partners`
* `users`

Get a backup of the impulse production database from heroku, and move it into a local postgres setup in `artsy-impulse-production`

Install node modules

`yarn install`

Generate the geo points data and output the bundle

`yarn run debug && yarn run cofee`

Open public/index.html
