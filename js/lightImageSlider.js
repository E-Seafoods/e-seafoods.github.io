var esf = esf || {};
esf.imageSlider = function() {
    esf.productImageSlider();
    esf.relatedProductSlider();
};

esf.productImageSlider = function(){
    //var $autoPlaySlider = esf.autoPlaySlider;
        $('#product-img-slider').lightSlider({
            gallery:true,
            item:1,
            loop:true,
            thumbItem:4,
            slideMargin:0,
            mode: 'fade',
            enableDrag: false,
            controls: false,
            speed: 1000,
            pause: 4000,
            auto: true,
            currentPagerPosition:'left',
            onSliderLoad: function(el) {
                el.lightGallery({
                    selector: '#product-img-slider .lslide'
                });
            }
        });

    };

esf.relatedProductSlider = function(){
    //var $relatedAutoPlaySlider = esf.autoPlaySlider;
    autoPlaySlider = $('#related-product-slider').lightSlider({
        item: 4,
        controls: true,
        speed: 2000,
        pause: 6000,
        auto: true,
        loop:true,
        enableDrag:false,
        responsive : [
            {
                breakpoint:1366,
                settings: {
                    item:3,
                    enableDrag:true
                }
            },
            {
                breakpoint:991,
                settings: {
                    enableDrag:true
                }
            },
            {
                breakpoint:800,
                settings: {
                    item:2,
                    enableDrag:true
                }
            },
            {
                breakpoint:767,
                settings: {
                    item:1,
                    enableDrag:true
                }
            }
        ]
    });
    //$('.product-img-slider').on('mouseenter',function(){
    //    autoPlaySlider.pause();
    //});
    //$('.product-img-slider').on('mouseleave',function(){
    //    autoPlaySlider.play();
    //});
};
//
//$(function(){
//    esf.imageSlider();
//});