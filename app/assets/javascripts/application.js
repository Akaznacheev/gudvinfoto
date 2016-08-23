// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

var ready;
ready = function() {
    $(document).ready(function()
    {
        var x;                            // To store cloned div

        $(".div_1").draggable(
            {
                helper: "clone",
                cursor: "move",
                revert: true
            });

        $(".div_2").droppable(
            {
                drop: function(event, ui)
                {

                    var urlstr = ui.draggable.find("img").attr("src");
                    var photo_id = ui.draggable.attr("id");
                    var page_id = $(this).attr("id"); //event.target.id;  // or $(this).attr("id"), or this.id

                    x = ui.helper.clone();    // Store cloned div in x
                    ui.helper.remove();       // Escape from revert the original div
                    // x.appendTo('.div_2');     // To append the reverted image

                    $(this).css('background-image','url('+urlstr+')');

                    jQuery.ajax({
                        url: "/books/8/bookpages/"+page_id,
                        type: "put",
                        data:{bookpage_params:{
                            pagenum: '9'},
                            phgallery_params: {
                                photo_id: photo_id
                            }
                        },
                        dataType:'json',
                        success:function(returned_value){
                            if(returned_value)
                                alert('true');
                        }
                    });
                }
            });
    });
}
$(document).ready(ready);
$(document).on('page:load', ready)
