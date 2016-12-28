$ = require 'jquery'

class ActiveToggle
  constructor: (query) ->
    $(document).on "click", query, (e) ->
      $this = $(e.currentTarget)
      target = $this.data("toggle")

      $this.toggleClass "active"
      $(target).toggleClass "active"
      $('body')
      .toggleClass "#{target.replace /^[#\.]/, ''}-activated"

module.exports = ActiveToggle
