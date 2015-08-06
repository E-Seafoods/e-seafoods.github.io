var esfProduct = esfProduct || {};
esfProduct.init = function() {
    esfProduct.sizeDropDown();
};

esfProduct.sizeDropDown = function(){
    $(".dropdown-menu").on('click', 'li a', function(){
        $(".btn:first-child").html($(this).text()+' <span class="glyphicon glyphicon-triangle-bottom"></span>');
        $('#option-size').val($(this).text());
    });
};

$(function(){
    esfProduct.init();
});