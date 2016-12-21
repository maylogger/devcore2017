# Require Stylesheets
require "stylesheets"

# Require Modernizr
require "modernizr"

# Require Custom Modules
# EX:
# { MainMenu } = require "./modules/sidebar"

# Require entry modules
# EX:
# { HomeBanners, HomeCover } = require "./entry/home"

# Inject SVG Sprite
sprites = require.context "icons", off
sprites.keys().forEach sprites
