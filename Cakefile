child_process = require 'child_process'
#uglify = require 'uglify-js'

#spawn = require('child_process').spawn
#util = require 'util'
#coffee_cmd = require 'coffee-script/lib/coffee-script/command'
#coffee2 = require 'coffee-script'
require 'sugar'
fs = require 'fs'
wrench = require 'wrench'
#less = require 'less'

coffeeSource = [
  'lib/Listing.coffee'
  'lib/SearchResult.coffee'
  'lib/User.coffee'
  'airbnb_proxy.coffee'
]

# some concepts from http://stackoverflow.com/questions/8591898/compiling-coffeescript-on-npm-install
echo = (child) ->
  child.stdout.on "data", (data) -> console.log data.toString()
  child.stderr.on "data", (data) -> console.log data.toString()
  child

buffer = (child) ->
  child.buffer = ''
  child.stdout.on "data", (data) -> child.buffer+= data.toString()
  child.stderr.on "data", (data) -> child.buffer+= data.toString()
  child

# from http://procbits.com/2011/11/15/synchronous-file-copy-in-node-js/
fs.copyFileSync = (srcFile, destFile) ->
  BUF_LENGTH = 64*1024
  buff = new Buffer(BUF_LENGTH)
  fdr = fs.openSync(srcFile, 'r')
  fdw = fs.openSync(destFile, 'w')
  bytesRead = 1
  pos = 0
  while bytesRead > 0
    bytesRead = fs.readSync(fdr, buff, 0, BUF_LENGTH, pos)
    fs.writeSync(fdw,buff,0,bytesRead)
    pos += bytesRead
  fs.closeSync(fdr)
  fs.closeSync(fdw)

compileServerCoffeeScript = (callback) ->
  if process.platform == 'win32'
    echo child = child_process.spawn "cmd.exe", ['/c', "coffee", '-c', 'airbnb_proxy.coffee', 'lib']
  else
    echo child = child_process.spawn "coffee", ['-c', 'airbnb_proxy.coffee', 'lib']
  child.on 'exit', (status) -> callback?() if status == 0


spawnNpmInstall = (callback) ->
  if process.platform == 'win32'
    echo child = child_process.spawn "cmd.exe", ['/c', 'cd target & npm install']
  else
    echo child = child_process.spawn "sh", ['-c', 'cd target; npm install']
  child.on 'exit', (status) -> callback?() if status == 0


task "compile", "compile application", (options) ->
  console.log 'Compiling Server-Side CoffeeScript...'
  compileServerCoffeeScript () ->
    console.log 'Done.'

task "install", "Generate a deployable version of airbnb proxy", (options) ->
  console.log 'Remove previous deployment...'
  wrench.rmdirSyncRecursive './target', true

  compileServerCoffeeScript () ->
    console.log 'Copy application to /target dir'
    fs.mkdirSync './target', parseInt('0775')
    fs.mkdirSync './target/lib', parseInt('0775')

    fs.copyFileSync './airbnb_proxy.js', './target/airbnb_proxy.js'
    fs.copyFileSync './lib/Listing.js', './target/lib/Listing.js'
    fs.copyFileSync './lib/SearchResult.js', './target/lib/SearchResult.js'
    fs.copyFileSync './lib/User.js', './target/lib/User.js'
    fs.copyFileSync './package.json', './target/package.json'
    fs.copyFileSync './config.json', './target/config.json'
    fs.copyFileSync './README.md', './target/README.me'


  #  console.log 'Installing target application...'
#  spawnNpmInstall () ->
  console.log 'Done.'

task "clean", "Purge build directories", (options) ->
  if process.platform == 'win32'
    buffer clean = child_process.spawn "cmd.exe", ['/c', "rmdir /s /q target dist"]
  else
    buffer clean = child_process.spawn "sh", ['-c', "rm -rf dist target"]
  clean.on 'exit', (status) ->
    if status != 0
      console.log 'Clean failed.'
      console.log "#{clean.buffer}"
