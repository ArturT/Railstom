angular.module('App').run ($compile, $rootScope, $document) ->
  $document.on 'page:load', ->
    body = angular.element('body')
    compiled = $compile(body.html())($rootScope)
    body.html(compiled);
