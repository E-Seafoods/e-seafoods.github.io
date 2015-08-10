---
---
angular.module 'eSeafoodsApp', ['ngCookies', 'ngCart', 'mgcrea.ngStrap', 'ngSanitize'], ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'
.filter 'joinBy', ->
  (input, delimiter) ->
    (input or []).join delimiter or ','
.directive 'postRender', [
  '$timeout'
  ($timeout) ->
    {
      restrict: 'A'
      link: (scope, element, attrs) ->
        $timeout scope.refreshMixItUp, 0
        #Calling a scoped method
        return
    }
]
.controller 'StoreCtrl',
  ($scope, $http, $log, $cookies) ->

    SPLASH_COOKIE_NAME = '_splash'
    $scope.splashed = $cookies.get(SPLASH_COOKIE_NAME)
    $cookies.put(SPLASH_COOKIE_NAME, new Date().getTime())

    $scope.refreshMixItUp = ->
      $('#products').mixItUp('filter', 'all')

    $http.get('api/products.json').success (data) ->
      $scope.products = data
      for product in $scope.products
        product.lowestPrice = _.min(_.map(product.types, (type) ->
          _.min _.map(type.sizes, (size) ->
            size.price
          )
        ))
#        $log.debug product
      $ ->
#        $log.debug "INIT MIXITUP"
        $('#products').mixItUp
          load: filter: 'all'
