---
---
angular.module 'eSeafoodsApp', ['ngCookies'], ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'
.controller 'ProductCtrl',
  ($scope, $http, $log, $cookies) ->

    SPLASH_COOKIE_NAME = '_splash'
    $scope.splashed = $cookies.get(SPLASH_COOKIE_NAME)
    $cookies.put(SPLASH_COOKIE_NAME, new Date().getTime())

    $http.get('api/products.json').success (data) ->
      $scope.products = data