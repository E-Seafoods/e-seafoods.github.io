var esf = esf || {};
esf.imageSlider = function() {
    esf.productImageSlider();
};

esf.productImageSlider = function(){
    var autoPlaySlider = $('#product-img-slider').lightSlider({
        item: 1,
        controls: true,
        speed: 2000,
        pause: 6000,
        auto: true,
        loop:true,
        enableDrag:false,
        responsive : [
            {
                breakpoint:800,
                settings: {
                    item:1,
                    enableDrag:true
                }
            },
            {
                breakpoint:480,
                settings: {
                    item:1,
                    enableDrag:true
                }
            }
        ]
    });
    $('#product-img-slider').on('mouseenter',function(){
        autoPlaySlider.pause();
    });
    $('#product-img-slider').on('mouseleave',function(){
        autoPlaySlider.play();
    });
};

$(function(){
    esf.imageSlider();
});