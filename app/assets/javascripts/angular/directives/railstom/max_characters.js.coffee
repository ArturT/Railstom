# Add data-max-characters="250" to textarea field
angular.module('App.directives.railstom').directive 'maxCharacters', ->
  scope: {}

  characters_counter = (counterId, maxCharacters, inputValue) ->
    remaining = maxCharacters - inputValue.length

    if remaining >= 0
      $("##{counterId}").html(I18n.t('layouts.application.words.characters_remaining', {amount: remaining}))
    else
      $("##{counterId}").html("""<div class="text_error">#{I18n.t('layouts.application.words.too_long_text')}</div>""")

  link = (scope, element, attrs) ->
    counter_id = "remaning_characters_#{attrs.id}"
    element.parent().append """<span style="float:right;" id="#{counter_id}"></span>"""

    # set default after page load
    characters_counter(counter_id, attrs.maxCharacters, element.context.value)

    element.bind 'input', ->
      characters_counter(counter_id, attrs.maxCharacters, element.context.value)
