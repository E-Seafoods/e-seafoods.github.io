$(document).ready(function(){
    var searchInput = $("#search-input");
    var searchBar = $("#search-bar");

    function getSearchParameters() {
        var prmstr = window.location.search.substr(1);
        return prmstr != null && prmstr != "" ? transformToAssocArray(prmstr) : {};
    }

    function transformToAssocArray( prmstr ) {
        var params = {};
        var prmarr = prmstr.split("&");
        for ( var i = 0; i < prmarr.length; i++) {
            var tmparr = prmarr[i].split("=");
            params[tmparr[0]] = tmparr[1];
        }
        return params;
    }

    var params = getSearchParameters();

    if(params.search){
        searchInput.val(params.search);
        scrollToBody();
    }

    videoPlayer = document.getElementById("video-sample");
    video_count = 0;

    var stickyMenu = function(){
        var nav = $('.navbar.navbar-fixed-top');
        nav.unstick();
        nav.sticky({topSpacing: 0});
    };

    stickyMenu();
    $(".category-nav-container").sticky({topSpacing:51});

    // Call pageScroll() and stickyMenu() when window is resized.
    $(window).smartresize(function(){
        pageScroll();
        //stickyMenu();
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

    if(location.pathname == "/") {
        searchBar.on("submit", function(event) {
            event.preventDefault();
            scrollToBody();
        });

        searchInput.on("focus", function() {
            scrollToBody();
        });

        /*
         * For searching filter for mixItUt.
         */
        var inputText;
        var $matching = $();

        // Delay function
        var delay = (function(){
            var timer = 0;
            return function(callback, ms){
                clearTimeout (timer);
                timer = setTimeout(callback, ms);
            };
        })();

        searchInput.keyup(function(){
            // Delay function invoked to make sure user stopped typing
            delay(function(){
                inputText = searchInput.val().toLowerCase();

                // Check to see if input field is empty
                if ((inputText.length) > 0) {
                    $( '.mix').each(function() {
                        $this = $("this");

                        // add item to be filtered out if input text matches items inside the title
                        if($(this).find('.name').text().toLowerCase().match(inputText)) {
                            $matching = $matching.add(this);
                        }
                        else {
                            // removes any previously matched item
                            $matching = $matching.not(this);
                        }
                    });
                    $("#products").mixItUp('filter', $matching);
                }

                else {
                    // resets the filter to show all item if input is empty
                    $("#products").mixItUp('filter', 'all');
                }
            }, 200 );
        });
        /* end searching filter for mixItUp. */
    }

    function scrollToBody() {
        var $anchor = $("#products");
        var offset = $('body').attr('data-offset');

        $('html, body').stop().animate({
            scrollTop: $anchor.offset().top - (offset - 1)
        }, 1500, 'easeInOutExpo');
    }
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