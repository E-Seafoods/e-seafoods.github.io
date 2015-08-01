---
---
angular.module 'eSeafoodsApp', [], ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'
.controller 'ProductCtrl',
  ($scope, $http, $log) ->
    $http.get('api/products.json').success (data) ->
      $scope.products = data