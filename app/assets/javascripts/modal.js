$('#trigger-modal_phgallery').click(function(){
    $('#screen_phgallery, #modal_phgallery').show();
});
$('#exit_modal_phgallery').click(function(){
    $('#screen_phgallery, #modal_phgallery').hide();
});
$('#chooseFile_phgallery').bind('change', function () {
    var filename = $("#chooseFile_phgallery").val();
    if (/^\s*$/.test(filename)) {
        $("#file-upload_phgallery").removeClass('actived');
        $("#noFile_phgallery").text("НЕТ ВЫБРАННЫХ ФАЙЛОВ...");
    }
    else {
        $("#file-upload_phgallery").addClass('actived');
        $("#noFile_phgallery").text('ВЫБРАНО ' + document.getElementById('chooseFile_phgallery').files.length + ' ФАЙЛОВ.');
    }
});
(function() {
    var bar = $('#modal_phgallery .bar');
    var percent = $('#modal_phgallery .percent');
    var status = $('#modal_phgallery #status');
    $('#modal_phgallery form').ajaxForm({
        beforeSend: function() {
            var percentVal;
            $('#modal_phgallery .progress').show();
            $('#modal_phgallery button.round_button').hide();
            $('#modal_phgallery .edit_phgallery').hide();
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
                $('#modal_phgallery .modal_title').hide();
                $('#modal_phgallery .progress').hide();
                $('#modal_phgallery .loading').show();
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
            $('#modal_background .edit_phgallery').hide();
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