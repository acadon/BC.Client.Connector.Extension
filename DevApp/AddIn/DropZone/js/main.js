var navControlContainer;
var navControl;

$(document).ready(function () {
    CreateControl();
});

function CreateControl() {
    navControlContainer = $("#controlAddIn");
    navControlContainer.append('<div class="wrapper"><div id="drop-files" ondragover="return false"><div id="drop-text">Drop Zone</div></div></div>');
    navControl = $("#drop-files");

    jQuery.event.props.push('dataTransfer');

    navControl.bind('drop', function (e) {
        var files = e.dataTransfer.files;
        $.each(files, function (index, file) {
            var fileName = file.name;
            var fileReader = new FileReader();
            fileReader.onload = (function (file) {
                var arrayBuffer = fileReader.result;
                var droppedFile = { FileName: fileName, Data: arrayBuffer };
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("FileDropped", [droppedFile]);
            });

            fileReader.readAsDataURL(file);
        });
    });

    navControl.bind('dragenter', function (e) {
        e.dataTransfer.dragEffect = "copy";
        $(this).css({ 'background-color': 'lightgreen' });
        return false;
    });
    navControl.bind('drop', function () {
        $(this).css({ 'background-color': 'gainsboro' });
        return false;
    });
    navControl.bind('dragleave', function () {
        $(this).css({ 'background-color': 'gainsboro' });
        return false;
    });
};