var esfProduct = esfProduct || {};
esfProduct.init = function () {
    esfProduct.sizeDropDown();
    esfProduct.quantityOption();
};

esfProduct.sizeDropDown = function () {
    //$(".dropdown-menu").on('click', 'li a', function () {
    //    $(".btn:first-child").html($(this).text() + ' <span class="glyphicon glyphicon-triangle-bottom"></span>');
    //    $('#option-size').val($(this).text());
    //});
};

esfProduct.quantityOption = function () {
    var quantityOptionSpinner = $('#option-quantity-value');
    var min = quantityOptionSpinner.attr('min');
    var max = quantityOptionSpinner.attr('max') || 100;
    quantityOptionSpinner.change(function () {
        if ($(this).val() > max) {
            $(this).val(max);
        }
        else if ($(this).val() < min) {
            $(this).val(min);
        }
    });

    var quantityPlusButton = $('#option-quantity-plus');
    var quantityMinusButton = $('#option-quantity-minus');

    $(quantityPlusButton).on('click', 'span', function(){
        if(quantityOptionSpinner.val() < max){
            quantityOptionSpinner.val(parseInt(quantityOptionSpinner.val(), 10) + 1);
            quantityOptionSpinner.trigger('input');
        }
    });

    $(quantityMinusButton).on('click', 'span', function(){
        if(quantityOptionSpinner.val() > min)
            quantityOptionSpinner.val(parseInt(quantityOptionSpinner.val(), 10) - 1);
            quantityOptionSpinner.trigger('input');
    });

};

$(function () {
    esfProduct.init();
});