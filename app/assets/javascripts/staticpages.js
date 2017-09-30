//= require bxslider
var bxslider;
bxslider = function() {
    $('.bxslider').bxSlider({
        auto: true,
        touchEnabled: false,
        preloadImages: 'all'
    });
};
$(document).ready(bxslider);
$(document).on('page:load', bxslider);