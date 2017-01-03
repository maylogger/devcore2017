import $ from "jquery"

export default class ShareButton
  constructor: (@el, @url, @text, @type) ->
    @window_features = "height=300,width=550,resizable=1"
    @url  = encodeURIComponent(@url)
    @text = encodeURIComponent(@text)

  bind_twitter: ->
    $(@el).on "click", (e) =>
      e.preventDefault()
      window.open """
        https://twitter.com/share?url=#{@url}&text=#{@text}&count=none/
      """
      , "twitter", @window_features

  bind_facebook: ->
    $(@el).on "click", (e) =>
      e.preventDefault()
      window.open "https://www.facebook.com/sharer.php?u=#{@url}"
      , "facebook", @window_features

  bind_line: ->
    $(@el).attr 'href',
    "http://line.me/R/msg/text/?#{@text}#{@url}"

  init: =>
    switch @type
      when 'twitter' then @bind_twitter()
      when 'facebook' then @bind_facebook()
      else @bind_line()

# Usage example

# buttons =
#   '.sp-btn-square-twitter.share': 'twitter'
#   '.sp-btn-square-line.share': 'line'

# for element, type of buttons
#   new ShareButton element
#                 , document.location.href
#                 , document.title
#                 , type
#                 .init()
