$('#trigger-modal_gallery').click(function(){
    $('#screen_gallery, #modal_gallery').show();
});
$('#exit_modal_gallery').click(function(){
    $('#screen_gallery, #modal_gallery').hide();
});
$('#chooseFile_gallery').bind('change', function () {
    var filename = $("#chooseFile_gallery").val();
    if (/^\s*$/.test(filename)) {
        $("#file-upload_gallery").removeClass('actived');
        $("#noFile_gallery").text("НЕТ ВЫБРАННЫХ ФАЙЛОВ...");
    }
    else {
        $("#file-upload_gallery").addClass('actived');
        $("#noFile_gallery").text('ВЫБРАНО ' + document.getElementById('chooseFile_gallery').files.length + ' ФАЙЛОВ.');
    }
});
(function() {
    var bar = $('#modal_gallery .bar');
    var percent = $('#modal_gallery .percent');
    var status = $('#modal_gallery #status');
    $('#modal_gallery form').ajaxForm({
        beforeSend: function() {
            var percentVal;
            $('#modal_gallery .progress').show();
            $('#modal_gallery button.round_button').hide();
            $('#modal_gallery .edit_gallery').hide();
            status.empty();
            percentVal = '0%';
            bar.width(percentVal);
            percent.html(percentVal);
        },
        uploadProgress: function(event, position, total, percentComplete) {
            var percentVal = percentComplete + '%';
            bar.width(percentVal);
            percent.html(percentVal);
            if (percentVal === '100%') {
                $('#modal_gallery .modal_title').hide();
                $('#modal_gallery .progress').hide();
                $('#modal_gallery .loading').show();
            }
            //console.log(percentVal, position, total);
        },
        success: function() {
            var percentVal = '100%';
            bar.width(percentVal);
            percent.html(percentVal);
        },
        complete: function() {
            location.reload();
        }
    });
})();
$('#trigger-modal_background').click(function(){
    $('#screen_background, #modal_background').show();
});
$('#exit_modal_background').click(function(){
    $('#screen_background, #modal_background').hide();
});
$('#chooseFile_background').bind('change', function () {
    var filename = $("#chooseFile_background").val();
    if (/^\s*$/.test(filename)) {
        $("#file-upload_background").removeClass('actived');
        $("#noFile_background").text("НЕТ ВЫБРАННЫХ ФАЙЛОВ...");
    }
    else {
        $("#file-upload_background").addClass('actived');
        $("#noFile_background").text('ВЫБРАНО ' + document.getElementById('chooseFile_background').files.length + ' ФАЙЛОВ.');
    }
});
(function() {
    var bar = $('#modal_background .bar');
    var percent = $('#modal_background .percent');
    var status = $('#modal_background #status');
    $('#modal_background form').ajaxForm({
        beforeSend: function() {
            var percentVal;
            $('#modal_background .progress').show();
            $('#modal_background button.round_button').hide();
            $('#modal_background .edit_gallery').hide();
            status.empty();
            percentVal = '0%';
            bar.width(percentVal);
            percent.html(percentVal);
        },
        uploadProgress: function(event, position, total, percentComplete) {
            var percentVal = percentComplete + '%';
            bar.width(percentVal);
            percent.html(percentVal);
            if (percentVal === '100%') {
                $('#modal_background .modal_title').hide();
                $('#modal_background .progress').hide();
                $('#modal_background .loading').show();
            }
            //console.log(percentVal, position, total);
        },
        success: function() {
            var percentVal = '100%';
            bar.width(percentVal);
            percent.html(percentVal);
        },
        complete: function() {
            location.reload();
        }
    });
})();