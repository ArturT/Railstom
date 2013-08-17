angular.module('App', ['ngResource', 'ng-rails-csrf'])

# Example:
# <a href="#" go-to-by-scroll="#huge-box" allowed-margin="0" up-limit="20">Jump</a>
# go-to-by-scroll takes selector
# allowed-margin and up-limit are optional
.directive 'goToByScroll', ->
  (scope, element, attrs) ->
    $(element).click (e) ->
      e.preventDefault()
      window.goToByScroll(attrs.goToByScroll, attrs.allowedMargin || 0, attrs.upLimit || 0)


# Add data-max-characters="250" to textarea field
.directive 'maxCharacters', ->
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


# Example:
#
# You can add class prevent-default to link with href="#"
#
# loadIcon="prepend" add icon prepend
# loadIcon="append" add icon append
# loadIcon="#id|.class" add the load icon to specify element
# loadIconMargin="left:5px|right:10px" [optional] add specify margin on the left or right side of the icon
# loadIconSize="icon-large" [optional] add class icon-large to the icon
.directive 'loadIcon', ->
  (scope, element, attrs) ->
    $(element).attr('data-no-turbolink', true)
    $(element).click (e) ->
      if $(this).hasClass('prevent-default')
        e.preventDefault()
      else
        $(this).addClass('prevent-default')

        if attrs.loadIconMargin?
          style = "margin-#{attrs.loadIconMargin};"
        else
          style = ""

        icon = """<i class="icon-spin icon-refresh #{attrs.loadIconSize}" style="#{style}"></i>"""

        switch attrs.loadIcon
          when 'prepend' then element.prepend(icon)
          when 'append' then element.append(icon)
          else $(attrs.loadIcon).html(icon)


# Test directive uses template from app/views/pages/templates/
.directive 'testAngularTemplate', ->
  restrict: 'E'
  templateUrl: '/templates/test'
