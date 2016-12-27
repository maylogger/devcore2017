$ = require "jquery"

# Require Stylesheets
require "stylesheets"

# Require Modernizr
# require "modernizr"

# Require Smooth Scroll
smoothScroll = require "smooth-scroll"

# Require Custom Modules
# EX:
ActiveToggle = require "./modules/toggle"

# Require entry modules
# EX:
# { HomeBanners, HomeCover } = require "./entry/home"

# Inject SVG Sprite
sprites = require.context "icons", off
sprites.keys().forEach sprites

# Running after DOM ready
new ActiveToggle "[data-toggle]"

smoothScroll.init()

$(document).on "click", "[data-smooth]", (e) ->
  smoothScroll.animateScroll document.querySelector $(e.currentTarget).data("smooth")
