path     = require 'path'
gulp     = require 'gulp'
replace  = require 'gulp-replace'
notify   = require 'gulp-error-notifier'
# responsive = require 'gulp-responsive'


# 取得 publicPath
{ publicPath } = require './package.json'

gulp.task 'resolve-url', ->
  sourcemap_pattern = /\/\*#\ssourceMappingURL.+\*\//ig
  
  gulp.src path.join(".webpack", "stylesheets/webpack_bundle.+(css|scss)")
      .pipe notify.handleError replace(sourcemap_pattern, "")
      .pipe gulp.dest path.join(".webpack", "stylesheets")
#
# Build Responsive Image
# START

# 產生 retina list
# retina = (width) -> [{
#   width: width
# },{
#   width: width * 2
#   rename: { prefix: "2x_" }
# }]

# gulp.task 'responsive', ->
#   gulp.src 'client/lorem/*.{png,jpg}'
#     .pipe responsive
#       'demo_*.jpg': retina(1920)
#     .pipe gulp.dest 'app/assets/images/lorem'
