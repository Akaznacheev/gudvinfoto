// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var bgmove;
bgmove = function() {
    $('.bgmove').backgroundDraggable({
        done: function () {
            var elem = $(event.target);
            bgposi = elem.css('background-position');
            var params = elem.attr("id"); //event.target.id;  // or $(this).attr("id"), or this.id
            var re = /\s*,\s*/;
            var paramslist = params.split(re);
            var bgImage = new Image();
            bgImage.src = elem.css('background-image').replace(/"/g, "").replace(/url\(|\)$/ig, "");
            bgImage.width // The actual image width
            bgImage.height // The actual image height
            test = (elem.css('width').split("px")[0] / bgImage.width * bgImage.height);
            test2 = -parseInt(bgposi.split("px")[1]) + parseInt(elem.css('height').split("px")[0] * (-parseInt(bgposi.split("px")[1])) / (test - parseInt(elem.css('height').split("px")[0])));
            test3 = (elem.css('height').split("px")[0] / bgImage.height * bgImage.width);
            test4 = -parseInt(bgposi.split("px")[0]) + parseInt(elem.css('width').split("px")[0] * (-parseInt(bgposi.split("px")[0])) / (test3 - parseInt(elem.css('width').split("px")[0])));
            positions = ((test4 / test3 * 100) + "% "
                + (test2 / test * 100) + "%" );
            $('.bgmove').text();
            jQuery.ajax({
                url: "/holsts/" + paramslist[0],
                type: "put",
                data: {
                    dragged_image_params: {
                        positions: positions
                    }
                },
                dataType: 'json',
                success: function (returned_value) {
                    if (returned_value)
                        alert('true');
                }
            })
        }
    });
};

$(document).ready(bgmove);
$(document).on('page:load', bgmove);
$(document).on('page:change', bgmove);