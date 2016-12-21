path = require 'path'

root = path.resolve __dirname, "../"
sass = path.resolve root, "stylesheets"
assets = path.resolve __dirname, "../../.webpack"

module.exports =
  root:   root
  sass:   sass
  assets: assets
  icons:  path.resolve root, "icons"
  images: path.resolve root, "images"
  package: path.resolve root, "../package.json"
  templates: path.resolve root, "templates"
