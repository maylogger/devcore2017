import $ from "jquery"

export default class ActiveToggle
  constructor: (query) ->
    $(document).on "click", query, (e) ->
      $this = $(e.currentTarget)
      target = $this.data("toggle")

      $this.toggleClass "active"
      $(target).toggleClass "active"
      $("body")
      .toggleClass "#{target.replace /^[#\.]/, ''}-activated"
