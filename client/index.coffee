import $ from "jquery"

# Require Stylesheets
import "stylesheets"

# Require Modernizr
# require "modernizr"

# Require Smooth Scroll
import smoothScroll from "smooth-scroll"

# Require Custom Modules
# EX:
import ActiveToggle from "./modules/toggle"
import ShareButton  from "./modules/sns"
import Form         from "./modules/form"

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

sns_widgets =
  '#sns-facebook': 'facebook'
  '#sns-twitter': 'twitter'

for element, type of sns_widgets
  new ShareButton(element, document.location.href, document.title, type).init()

form_inputs = '
  input[type=text],
  input[type=password],
  input[type=email],
  input[type=url],
  input[type=tel],
  input[type=number],
  input[type=search],
  textarea
'

new Form form_inputs
