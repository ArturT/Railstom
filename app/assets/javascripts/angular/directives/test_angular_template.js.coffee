# Test directive uses template from app/views/pages/templates/
angular.module('App').directive 'testAngularTemplate', ->
  restrict: 'E'
  templateUrl: '/templates/test'

