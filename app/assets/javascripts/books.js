// resize&change cover name
var cover;
cover = function() {
    var div = document.getElementById('click');
    var selectfs = document.getElementById('fs');
    var selectsz = document.getElementById('size');

    $(".changeMe").focus(function(){
        div.style.display = 'inline-block';
        selectsz.style.display = 'inline-block';
        selectfs.style.display = 'inline-block';
    });
    $( "#fs" )
        .change(function () {
            $('.changeMe').css("font-family", $(this).val());
        })
        .change();
    $( "#size" )
        .change(function () {
            $('.changeMe').css("font-size", $(this).val() + "vh");
        })
        .change();
    $('#click').click(function () {
        div.style.display = 'none';
        selectsz.style.display = 'none';
        selectfs.style.display = 'none';
        var fontfamily = $( "#fs" ).val();
        var fontsize = $( "#size" ).val();
        var bookid = $('#click').attr("class");
        var covertext = document.getElementById('covertext').value;
        jQuery.ajax({
            url: '/books/' + bookid,
            type: 'put',
            data:{
                cover_params: {
                    family: fontfamily,
                    size: fontsize,
                    name: covertext
                }
            },
            dataType:'json',
            success:function(returned_value){
                if(returned_value)
                    alert('true');
            }
        });
    });
};

$(document).ready(cover);
$(document).on('page:load', cover);
$(document).on('page:change', cover);

var textarea;
textarea = function() {
    jQuery.each(jQuery('textarea[data-autoresize]'), function() {
        var offset = this.offsetHeight - this.clientHeight;

        var resizeTextarea = function(el) {
            jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
        };
        jQuery(this).on('keyup input', function() { resizeTextarea(this); }).removeAttr('data-autoresize');
    });
    $('#textarea').on( 'change keyup keydown paste cut', 'textarea', function (){
        $(this).height(0).height(this.scrollHeight);
    }).find( 'textarea' ).change();
};

$(document).ready(textarea);
$(document).on('page:load', textarea);
$(document).on('page:change', textarea);

var ready;
ready = function() {
    /*
    Photo Draggable & Droppable & Addable
     */
    $(document).ready(function() {
        var x;                            // To store cloned div
        $(".div_1").draggable({helper: 'clone', cursor: 'move', revert: true});
        $(".div_2").droppable({
            drop: function (event, ui) {
                var randomId = new Date().getTime();
                var url = $(this).css('background-image');
                var src = url.substring(5, url.length-2); // get src of previous image

                var urlstr = ui.draggable.find('img').attr('src');
                var arr_name = urlstr.split('thumb');
                var file_name = arr_name[arr_name.length - 1];
                var ineditor_file_name = 'ineditor' + file_name;
                var photo_id = ui.draggable.attr('id');
                var droppable_element = $(this);
                var params = $(this).attr('id'); //event.target.id;  // or $(this).attr("id"), or this.id
                var re = /\s*,\s*/;
                var paramslist = params.split(re);
                var divid = paramslist[1];
                x = ui.helper.clone();    // Store cloned div in x
                ui.helper.remove();       // Escape from revert the original div
                // x.appendTo('.div_2');     // To append the reverted image

                jQuery.ajax({
                    url: '/bookpages/' + paramslist[0],
                    type: 'put',
                    data: {
                        phgallery_params: {
                            div_id: divid,
                            photo_id: photo_id
                        }
                    },
                    dataType: 'json',
                    success: function () {
                        droppable_element.css({
                            'background-image': 'url(' + arr_name[0] + ineditor_file_name + '?random=' + randomId + ')',
                            'background-size': 'cover',
                            'background-repeat': 'no-repeat'
                        });
                        $('.bgmove').backgroundDraggable({
                            done: function () {
                                var elem = $(event.target);
                                bgposi = elem.css('background-position');
                                var params = elem.attr("id"); //event.target.id;  // or $(this).attr("id"), or this.id
                                var re = /\s*,\s*/;
                                var paramslist = params.split(re);
                                var divid = paramslist[1];
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
                                    url: "/bookpages/" + paramslist[0],
                                    type: "put",
                                    data: {
                                        dragimage_params: {
                                            div_id: divid,
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
                    }
                });

                // Add&Remove check element
                ui.draggable.append('<i class="fa fa-check-circle-o check_image"></i>');

                var imgs = document.getElementsByTagName('img');
                var index;
                for (index = 0; index < imgs.length; ++index) {
                    if (imgs[index].src === src) {
                        var elem = imgs[index].parentElement.getElementsByTagName('i')[0];
                        imgs[index].parentElement.removeChild( elem );
                    }
                }


            }
        });
        $(".div_3").droppable({
            drop: function (event, ui) {
                var randomId = new Date().getTime();
                var url = $(this).css('background-image');
                var src = url.substring(5, url.length-2); // get src of previous image

                var urlstr = ui.draggable.find('img').attr('src');
                var arr_name = urlstr.split('thumb');
                var file_name = arr_name[arr_name.length - 1];
                var ineditor_file_name = 'ineditor' + file_name;
                var photo_id = ui.draggable.attr('id');
                var params = $(this).attr('id'); //event.target.id;  // or $(this).attr("id"), or this.id
                var re = /\s*,\s*/;
                var paramslist = params.split(re);
                var droppable_element = '#page_background_' + paramslist[0];
                var div_id = paramslist[1];
                x = ui.helper.clone();    // Store cloned div in x
                ui.helper.remove();       // Escape from revert the original div
                // x.appendTo('.div_3');     // To append the reverted image

                $(this).css({
                    'background-image': 'url(' + urlstr + ')',
                    'background-position': 'center'
                });
                $(this).children("p").css({
                    'visibility': 'hidden'
                });

                jQuery.ajax({
                    url: '/bookpages/' + paramslist[0],
                    type: 'put',
                    data: {
                        background: true,
                        phgallery_params: {
                            div_id: div_id,
                            photo_id: photo_id
                        }
                    },
                    dataType: 'json',
                    success: function () {
                        $(droppable_element).css({
                            'background-image': 'url(' + arr_name[0] + ineditor_file_name + '?random=' + randomId + ')',
                            'background-position': 'center',
                            'background-size': 'cover',
                            'background-repeat': 'no-repeat'
                        });
                    }
                });

            }
        });
    });
};
$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:change', ready);