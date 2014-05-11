# Railstom modules
angular.module('App.directives.railstom', [])

# Your custom modules
angular.module('App.controllers', [])
angular.module('App.directives', [])
angular.module('App.factories', [])
angular.module('App.filters', [])
angular.module('App.services', [])

# Setup App module
angular.module('App', [
  # Railstom dependencies
  'App.directives.railstom',

  # Your dependencies
  'App.controllers',
  'App.directives',
  'App.factories',
  'App.filters',
  'App.services',

  # Additional dependencies
  'ngResource',
  'ng-rails-csrf'
])
