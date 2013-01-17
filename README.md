airbnb_proxy
============

This project contains a [Node.js](http://nodejs.org/) application (using the [express](http://expressjs.com/) framework) that hosts a RESTful Airbnb proxy server.
The application is written in [CoffeeScript] (http://coffeescript.org/), the code is trans-compiled to JavaScript during installation.

quick start
-----------
If you already have Node.js and CoffeeScript installed, run:

```
git clone https://github.com/aikalima/airbnb_proxy.git
cd airbnb_proxy
npm install
npm start &
curl localhost:4000/search/los-angeles
```

installing Node.js & CoffeeScript
--------------------------------
For Windows & Mac users, it's easy, just go to http://nodejs.org/#download and download & run your installer.

For Linux, you seem to have to build it (Ubuntu has a package for node, but it's the older 0.4.x version, which isn't compatible).
Here are the steps that worked for me:

    wget http://nodejs.org/dist/v0.8.1/node-v0.8.1.tar.gz
    tar -zxf node-v0.8.1.tar.gz
    cd node-v0.8.1
    ./configure
    make
    sudo make install

You can then run:

    node -v

and

    npm -v

to ensure you have Node v0.8.x and NPM v1.1.x installed.

Finally, run:

    npm install -g coffee-script

to install coffee script compiler and cake.


installing server
-----------------
From root of project, run:

    npm install

This does all of the following:

 * downloads all Node.js module dependencies (e.g., express)
 * compiles all CoffeeScript to JavaScript
 * creates a "target" folder containing a "production ready" version of the application which can be tarballed and deployed


running server
--------------
To run the Node.js proxy server, run the following from the project's root folder:

    npm start

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

configuration
-------------

  * proxy:port - the port the proxy server will listen on (defaults to 4000)

The defaults are stored in config.json, which should not be modified (unless the defaults change of course).


development
-----------

When you plan to make changes to the CoffeeScript source files, you can run:

    coffee -cw <root folder>

in the background to have it continuously watch for changes and recompile as needed.


project structure
-----------------



