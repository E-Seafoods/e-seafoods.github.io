---
---
angular.module 'eSeafoodsApp', ['ngCookies', 'ngCart', 'mgcrea.ngStrap', 'ngSanitize'], ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'
.filter 'joinBy', ->
  (input, delimiter) ->
    (input or []).join delimiter or ','

.filter 'capitalize', ->
  (input) ->
    input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()

.directive 'mixItUpAfterRender', ($log) ->
  (scope, element, attrs) ->
    scope.$watch '$last', (v) ->
      if v
        console.log(v)
        $("#products").mixItUp
          callbacks:
            onMixLoad: ->
              $log.debug "MixItUp ready!"
            onMixFail: ->
              $log.debug "No elements found matching"

          load:
            filter: "all"

.directive 'imageSliderAfterRender', ($log) ->
  (scope, element, attrs) ->
    scope.$watch '$last', (v) ->
      if v
        $log.debug "Initializing image slider"
        esf.imageSlider()

.directive 'ngConfirmClick', [ ->
  { link: (scope, element, attr) ->
    msg = attr.ngConfirmClick or 'Are you sure?'
    clickAction = attr.confirmedClick
    element.bind 'click', (event) ->
      if window.confirm(msg)
        scope.$apply clickAction
  }
]

.controller 'StoreCtrl',
  ($scope, $http, $log, $cookies) ->

    SPLASH_COOKIE_NAME = '_splash'
    $scope.splashed = $cookies.get(SPLASH_COOKIE_NAME)
    $cookies.put(SPLASH_COOKIE_NAME, new Date().getTime())

    $http.get('/api/products.json').success (data) ->
      $scope.products = data
      for product in $scope.products
        product.lowestPrice = _.min(_.map(product.types, (type) ->
          _.min _.map(type.sizes, (size) ->
            size.price
          )
        ))
#        $log.debug product
      $ ->
#        success here

.controller 'PickOptionsCtrl',
  ($scope, $log) ->
    $scope.product = []

    $scope.setProduct = (data) ->
      $log.debug 'Initializing product data'
      $scope.product = data

    $scope.setSelectedType = (type) ->
      $log.debug 'Initializing selected type'
      $scope.product.selectedType = type

    $scope.setSelectedSize = (size) ->
      $log.debug 'Initializing selected size'
      $scope.product.selectedSize = size

    $scope.calculateTotal = ->
      $total = 0
      if(!angular.isUndefined($scope.product.selectedSize))
        $total = $scope.product.selectedSize.price * $scope.product.kg

      return $total

    $scope.$watchCollection '[product.selectedType, product.selectedSize]', (newValue, oldValue) ->
      $scope.cartData = angular.copy($scope.product)

.controller 'AddressCtrl',
  ($scope, $log) ->
    $scope.shipping = angular.fromJson(localStorage.getItem("shippingAddress"))

    $scope.saveShippingAddress = (shipping) ->
      $log.debug 'Successfully saved to localstorage'
      localStorage.setItem("shippingAddress", angular.toJson(shipping));
      window.location.href = '/checkout/order'

.controller 'DeliveryDateCtrl',
  ($scope, $log) ->
    $scope.deliveryDate = new Date()
    $scope.deliveryDate.setDate($scope.deliveryDate.getDate() + 1)