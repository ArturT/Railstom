# Example:
# <a href="#" go-to-by-scroll="#huge-box" allowed-margin="0" up-limit="20">Jump</a>
# go-to-by-scroll takes selector
# allowed-margin and up-limit are optional
angular.module('App.directives.railstom').directive 'goToByScroll', ->
  (scope, element, attrs) ->
    $(element).click (e) ->
      e.preventDefault()
      window.goToByScroll(attrs.goToByScroll, attrs.allowedMargin || 0, attrs.upLimit || 0)
