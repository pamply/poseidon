gulp       = require('gulp')
watchify   = require('watchify')
browserify = require('browserify')
source     = require('vinyl-source-stream')

SOURCE_FILE = './'
DEST        = './'


gulp.task 'run', ->
  opt = watchify.args

  opt.extensions = [".coffee"]
  opt.basedir = SOURCE_FILE
  opt.entries = './index.coffee'
  opt.debug = true

  bundler = watchify(browserify(opt))
  
  bundler.on 'update', -> update(bundler, DEST)

  update(bundler, DEST)

update = (bundler, dest) ->
  bundler.transform('coffeeify')
  bundler.bundle()
    .on('error', (args...) -> console.log("Error: #{args}"))
    .pipe(source('index.js'))
    .pipe(gulp.dest(dest))

  require('./server')