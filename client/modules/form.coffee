import $ from "jquery"

export default class Form
  constructor: (@input_selector) ->
    @check_text_fields()
    @track_input_focus()
    @track_input_blur()
    @track_auto_complete()

  ###*
   * Add active when element has focus
  ###

  track_input_focus: () ->
    $(document).on 'focus', @input_selector, () ->
      $(this).siblings('label').addClass('active')

  ###*
   * Remove active when element has blur
  ###

  track_input_blur: () ->
    $(document).on 'blur', @input_selector, () ->
      $this = $(this)

      if $this.val().length is 0 and this.validity.badInput isnt on and !$this.attr('placeholder')?
        $this.siblings('label').removeClass('active')

  ###*
   * Add active if form auto complete
  ###

  track_auto_complete: () ->
    $(document).on 'change', @input_selector, () ->
      $this = $(this)

      if $this.val().length > 0 or $this.attr('placeholder')?
        $this.siblings('label').addClass('active')

  ###*
   * Initially update labels of text fields
  ###

  check_text_fields: () ->
    $(@input_selector).each (index, element) ->
      $this = $(@)

      if $(element).val().length > 0 or element.autofocus or $this.attr('placeholder')?
        $this.siblings('label').addClass('active')
      else if element.validity
        $this.siblings('label').toggleClass('active', element.validity.badInput is on)
      else
        $this.siblings('label').removeClass('active')
