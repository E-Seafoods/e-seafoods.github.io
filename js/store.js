$(document).ready(function(){
    videoPlayer = document.getElementById("video-sample");
    video_count = 0;

    var stickyMenu = function(){
        var nav = $('.navbar.navbar-fixed-top');
        nav.unstick();
        nav.sticky({topSpacing: 0});
    };

    stickyMenu();
    $("#category-nav-container").sticky({topSpacing:50});

    // Call pageScroll() and stickyMenu() when window is resized.
    $(window).smartresize(function(){
        pageScroll();
        stickyMenu();
    });

    /*-------------------------------------------------------------------*/
    /*  3. Page scrolling feature, requires jQuery Easing plugin.
     /*-------------------------------------------------------------------*/
    var pageScroll = function(){
        $('.page-scroll a').bind('click', function(e){
            e.preventDefault();

            var $anchor = $(this);
            var offset = $('body').attr('data-offset');

            $('html, body').stop().animate({
                scrollTop: $($anchor.attr('href')).offset().top - (offset - 1)
            }, 1500, 'easeInOutExpo');
        });
    };

    pageScroll();

    $("#search-bar").on("submit", function() {
        var $anchor = $("#products");
        var offset = $('body').attr('data-offset');

        $('html, body').stop().animate({
            scrollTop: $anchor.offset().top - (offset - 1)
        }, 1500, 'easeInOutExpo');
    });
});

function videoChange(){
    console.log('video done');
    var videoSources = [
        'http://d2434a0nr1d7t1.cloudfront.net/p/D42_7_073/D42_7_073_detail.mp4',
        'http://ak8.picdn.net/shutterstock/videos/6078290/preview/stock-footage-coron-philippines-february-unidentified-people-buying-and-selling-fresh-fish-and.mp4',
        'http://ak4.picdn.net/shutterstock/videos/6081911/preview/stock-footage-coron-philippines-february-unidentified-people-buying-and-selling-fresh-fish-on-the.mp4',
        'http://ak9.picdn.net/shutterstock/videos/5637488/preview/stock-footage-fresh-fishes-form-andaman-sea.mp4'
    ];
    if (video_count == videoSources.length)
        video_count = 0;

    videoPlayer.src = videoSources[video_count];
    videoPlayer.play();
    video_count++;
    console.log("video count: " + video_count);
    console.log("size: " + videoSources.size - 1);
}