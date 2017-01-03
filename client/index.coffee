import $ from "jquery"

# Require Stylesheets
import "stylesheets"

# Require Modernizr
# require "modernizr"

# Require entry modules
# EX:
# { HomeBanners, HomeCover } = require "./entry/home"

###*
 * Prepend SVG Sprite into body
###

sprites = require.context "icons", off
sprites.keys().forEach sprites

###*
 * Element which has data-toggle attribute can trigger active classes when clicked.
###

import ActiveToggle from "./modules/toggle"

new ActiveToggle "[data-toggle]"

###*
 * Smooth scroll for all anchor triggers and Buttons which has data-smooth attribute.
###

import smoothScroll from "smooth-scroll"

smoothScroll.init()

$(document).on "click", "[data-smooth]", (e) ->
  smoothScroll.animateScroll document.querySelector $(e.currentTarget).data("smooth")

###*
 * Custom SNS sharing button
###

import ShareButton from "./modules/sns"

sns_widgets =
  '#sns-facebook': 'facebook'
  '#sns-twitter': 'twitter'

for element, type of sns_widgets
  new ShareButton(element, document.location.href, document.title, type).init()

###*
 * Material Design style input elements
###

import Form from "./modules/form"

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
