//= require jquery.slick
var slick;
slick = function() {
    $('.homeslider').slick({
        dots: true,
        arrows: false,
        infinite: true,
        speed: 500,
        fade: true,
        cssEase: 'linear',
        autoplay: true,
        autoplaySpeed: 2000
    });
    $('.partnerslider').slick({
        infinite: true,
        slidesToShow: 5,
        slidesToScroll: 1,
        speed: 500,
        cssEase: 'linear',
        autoplay: true,
        autoplaySpeed: 8000
    });
};
$(document).ready(slick);
$(document).on('page:load', slick);