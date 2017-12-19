function getBackgroundSize(elem) {
    var computedStyle = getComputedStyle(elem),
        image = new Image(),
        cssSize = computedStyle.backgroundSize,
        elemW = parseInt(computedStyle.width.replace('px', ''), 10),
        elemH = parseInt(computedStyle.height.replace('px', ''), 10),
        elemDim = [elemW, elemH],
        computedDim = [],
        ratio;
    image.src = computedStyle.backgroundImage.replace(/url\((['"])?(.*?)\1\)/gi, '$2');
    ratio = image.width > image.height ? image.width / image.height : image.height / image.width;
    cssSize = cssSize.split(' ');
    computedDim[0] = cssSize[0];
    computedDim[1] = cssSize.length > 1 ? cssSize[1] : 'auto';
    if(cssSize[0] === 'cover') {
        if(elemDim[0] > elemDim[1]) {
            if(elemDim[0] / elemDim[1] >= ratio) {
                computedDim[0] = elemDim[0];
                computedDim[1] = 'auto';
            } else {
                computedDim[0] = 'auto';
                computedDim[1] = elemDim[1];
            }
        } else {
            computedDim[0] = 'auto';
            computedDim[1] = elemDim[1];
        }
    } else if(cssSize[0] == 'contain') {
        if(elemDim[0] < elemDim[1]) {
            computedDim[0] = elemDim[0];
            computedDim[1] = 'auto';
        } else {
            if(elemDim[0] / elemDim[1] >= ratio) {
                computedDim[0] = 'auto';
                computedDim[1] = elemDim[1];
            } else {
                computedDim[1] = 'auto';
                computedDim[0] = elemDim[0];
            }
        }
    } else {
        for(var i = cssSize.length; i--;) {
            if (cssSize[i].indexOf('px') > -1) {
                computedDim[i] = cssSize[i].replace('px', '');
            } else if (cssSize[i].indexOf('%') > -1) {
                computedDim[i] = elemDim[i] * (cssSize[i].replace('%', '') / 100);
            }
        }
    }
    if (computedDim[0] === 'auto' && computedDim[1] === 'auto') {
        computedDim[0] = image.width;
        computedDim[1] = image.height;
    } else {
        ratio = computedDim[0] === 'auto' ? image.height / computedDim[1] : image.width / computedDim[0];
        computedDim[0] = computedDim[0] === 'auto' ? image.width / ratio : computedDim[0];
        computedDim[1] = computedDim[1] === 'auto' ? image.height / ratio : computedDim[1];
    }
    return {
        width: computedDim[0],
        height: computedDim[1]
    };
}

// Stuff for debugging
function updateData() {
    var background = getBackgroundSize(document.getElementsByTagName("body")[0]),
        book_width = 0.641*background.width,
        book_height = 0.545*background.height,
        standart_font_size = Math.round(2.5*0.00545*background.height);
    //to refactoring
    $('.order_about_book_cover').css('margin','0 auto '+Math.round(5*0.00545*background.height)+'px');
    $('.text_photobook').css({
        'font-size': Math.round(3*0.00545*background.height)+'px',
        'margin-bottom': Math.round(4*0.00545*background.height)+'px'
    });
    $('.order_about_book_about').css({'font-size': standart_font_size+'px'});
    $('h1').css({'font-size': Math.round(6*0.00545*background.height)+'px'});
    $('.order_form_box input, textarea').css({
        'font-size': standart_font_size+'px',
        'margin': Math.round(0.5*0.00545*background.height)+'px 0',
        'padding': Math.round(0.5*0.00545*background.height)+'px '+Math.round(0.00545*background.height)+'px'
    });
    $('.delivery label').css('font-size',Math.round(4*0.00545*background.height)+'px');
    $('.delivery p').css('font-size',standart_font_size+'px');
    $('.payname').css('font-size',Math.round(4*0.00545*background.height)+'px');
    $('.pay p').css({
        'font-size': standart_font_size+'px',
        'margin-bottom': Math.round(3*0.00545*background.height)+'px'
    });
    $('.pay a').css({'font-size': standart_font_size+'px'});
    $('#data').css({
        'width': Math.round(book_width)+'px',
        'height': Math.round(book_height)+'px',
        'visibility': 'visible'
    });
}
window.onresize = updateData;
window.onload = updateData;
window.ready = updateData;