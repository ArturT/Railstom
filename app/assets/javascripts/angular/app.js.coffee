angular.module('App', [])

# Example:
# <a href="#" go-to-by-scroll="#huge-box" allowed-margin="0" up-limit="20">Jump</a>
# go-to-by-scroll takes selector
# allowed-margin and up-limit are optional
.directive 'goToByScroll', ->
  (scope, element, attrs) ->
    $(element).click (e) ->
      e.preventDefault()
      window.go_to_by_scroll(attrs.goToByScroll, attrs.allowedMargin || 0, attrs.upLimit || 0)


# Add data-max-characters="250" to textarea field
.directive 'maxCharacters', ->
  scope: {}

  characters_counter = (counterId, maxCharacters, inputValue) ->
    remaining = maxCharacters - inputValue.length

    if remaining >= 0
      $("##{counterId}").html("#{remaining} #{I18n.t('layouts.application.words.characters_remaining')}")
    else
      $("##{counterId}").html("""<div class="text_error">#{I18n.t('layouts.application.words.too_long_text')}</div>""")

  link = (scope, element, attrs) ->
    counter_id = "remaning_characters_#{attrs.id}"
    element.parent().append """<span style="float:right;" id="#{counter_id}"></span>"""

    # set default after page load
    characters_counter(counter_id, attrs.maxCharacters, element.context.value)

    element.bind 'input', ->
      characters_counter(counter_id, attrs.maxCharacters, element.context.value)
