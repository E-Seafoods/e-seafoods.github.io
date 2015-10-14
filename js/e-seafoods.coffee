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
          load:
            filter: ".best-seller"
          callbacks:
            onMixLoad: ->
              $log.debug "MixItUp ready!"
#              $('#search-input').keyup()
            onMixFail: ->
              $log.debug "No elements found matching"


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
        $total = $scope.product.selectedSize.price * $scope.product.quantity

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

.controller 'CheckoutCtrl',
  ($scope, $controller, $log) ->
    angular.extend this, $controller('AddressCtrl', $scope: $scope)
    $scope.checkout = (cart, shippingPrice) ->
      $log.debug cart
      $log.debug $scope.shipping
      $log.debug $scope.shipping.emailAddress

      data =
        cmd: '_cart'
#        business: 'sales@e-seafoods.com'
        business: 'raaballe-facilitator@yahoo.com'
        upload: '1'
        rm: '2'
        charset: 'utf-8'
        currency_code: 'PHP'
        return: 'http://localhost:4000/'
        cancel_return: 'http://localhost:4000/cancel'
#        address_override: 1
        email: $scope.shipping.emailAddress
        first_name: $scope.shipping.firstName
        last_name: $scope.shipping.lastName
        address1: $scope.shipping.address
        city: $scope.shipping.city
        state: $scope.shipping.province
        zip: $scope.shipping.postal
        country: "PH"
        no_note: 0

      $log.debug data

      # item data
      i = 0
      while i < cart.length
        item = cart[i]
        ctr = i + 1
        data['item_number_' + ctr] = item._id
        data['item_name_' + ctr] = item._name + " / " + item._data.selectedType.name
        data['on0_' + ctr] = "Size"
        data['os0_' + ctr] = item._data.selectedSize.size
        data['quantity_' + ctr] = item._quantity
        data['amount_' + ctr] = item._price.toFixed(2)
        data['shipping_' + ctr] = shippingPrice / cart.length
        i++

      # build form
      form = $('<form/></form>')
      form.attr 'action', 'https://www.sandbox.paypal.com/cgi-bin/webscr'
      form.attr 'method', 'POST'
      form.attr 'style', 'display:none;'
      $scope.addFormFields form, data
      $('body').append form

      # submit form
      form.submit()
      form.remove()
      return

    $scope.addFormFields = (form, data) ->
      if data != null
        $.each data, (name, value) ->
          if value != null
            input = $('<input></input>').attr('type', 'hidden').attr('name', name).val(value)
            form.append input
          return
    return

