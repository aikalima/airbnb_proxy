airbnb_proxy
============

Brian Chesky, when is the airbnb api coming out? ["Right now it's not something in the near term"] (http://www.youtube.com/watch?v=6yPfxcqEXhE&t=2h12m12s).

OK, this project contains a [Node.js](http://nodejs.org/) application (using the [express](http://expressjs.com/) framework) that hosts a RESTful Airbnb api proxy server.
The application is written in [CoffeeScript] (http://coffeescript.org/).

quick start
-----------
To install Node, go to http://nodejs.org/#download and download & run your installer.

You can then run:

    node -v

and

    npm -v

to ensure you have Node v0.8.x and NPM v1.1.x installed.

To install and run the proxy server, simply run:

```
git clone https://github.com/aikalima/airbnb_proxy.git
npm install &
```
The install command does all of the following:

 * downloads all Node.js module dependencies (e.g., express)
 * compiles all CoffeeScript to JavaScript
 * creates a "target" folder containing a "production ready" version of the application which can be tarballed and deployed
 * starts up proxy server from project root dir

If everything works properly, you should see a message saying:

   Airbnb proxy server version 0.8 listening at http://localhost:4000
   Airbnb: www.airbnb.com port:443

usage
-----

Search for listings by location:
```
curl localhost:4000/search/los-angeles
```
Search for listings by location and check-in date (assumes one night stay). Dates are given in 'MMddyyyy' format:
```
curl localhost:4000/search/berlin-germany/02152013
```
Search for listings by location and time period:
```
curl localhost:4000/search/london/02152013/02192013
```
To specify number of search results, append query string 'searchResults' and number of desired results, for example:
```
curl localhost:4000/search/los-angeles?searchResults=100
```
To specify number guests, append query string 'guests' and number of desired guests, for example:
```
curl localhost:4000/search/los-angeles?guests=2
```
Get listing details by listing id (returned by search as 'hostingId'):
```
curl localhost:4000/listing/325478
```

Get user details (returned by search as 'user'):
```
curl localhost:4000/user/3
```

sample results
--------------

All API calls return fully qualified JSON. Here is a sample search result ('array of' ,in coffee script notation):
```
  address: "Berlin"
  neighborhood:
    id: 1163
    name: "Friedrichshain"

  has_video: false
  id: 561126
  lat: 52.516285
  lng: 13.436376
  name: "STAY WITH US IN OUR FAB PENTHOUSE!"
  other_review_count: 163
  picture_ids: [11931673, 8869149, 8868960, 8868954, 8869102, 8869125, 8869172, 8869194, 8869205, 8869240, 8869261, 8869291, 8869328, 8869345, 8869364, 8869391, 8869419, 8869454, 8869474, 8869490, 8869493, 8869496, 8869505, 8869521, 7313926]
  price: 69
  review_count: 32
  room_type: "Private room"
  thumbnail_url: "https://a0.muscache.com/pictures/11931673/x_small.jpg"
  user:
    id: 1661133
    is_superhost: true
    name: "Paul &amp; Patrik"
    thumbnail_url: "https://a1.muscache.com/users/1661133/profile_pic/1345988392/tiny.jpg"

  instant_book: true
  recommendation_count: 0
```

user:
```
name: "Brian"
description: "I am originally from NY, and have been living in San Francisco since October, 2007. In June, 2010,  I moved out of my apartment, and have been living on Airbnb in San Francisco off and on since then. "
image: "https://a1.muscache.com/users/3/profile_pic/1347776535/square_225.jpg"
```

listing detail:
```
  hostingId: "325478"
  user: "3254563"
  displayAddress: "Guerrero St, San Francisco, CA 94110, United States"
  nightlyPrice: "265"
  weeklyPrice: "265"
  monthlyPrice: "265"
  title: "Luxury 2br flat near Dolores Park in San Francisco"
  description: "My modern, sunny flat is in the heart of the trendy Mission Dolores District and walking distance to some of the best restaurants, bars and cafes i..."
  image: "https://a1.muscache.com/pictures/3598659/large.jpg"
  zip: "94110"
  locality: "San Francisco"
  region: "CA"
  country: "United States"
  city: "San Francisco"
  rating: "5.0"
  latitude: "37.76015417055848"
  longitude: "-122.42391436603498"
  fbId: "138566025676"
  roomType: "Entire home/apt"
  bedType: "Real Bed"
  sleeps: "4"
  bedrooms: "2"
  bathrooms: "1"
  searchQuery: "/s/United-States"
```

configuration
-------------

  * proxy:port - the port the proxy server will listen on (defaults to 4000)

The defaults are stored in config.json, which should not be modified (unless the defaults change of course).

