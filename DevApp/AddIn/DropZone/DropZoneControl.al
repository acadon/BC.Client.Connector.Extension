controladdin AcadonDropZone
{
    Scripts =
        'AddIn/DropZone/js/jquery-1.11.0.min.js',
        'AddIn/DropZone/js/jquery-ui.min.js',
        'AddIn/DropZone/js/main.js';

    StyleSheets =
        'AddIn/DropZone/css/main.css';

    RequestedHeight = 125;
    RequestedWidth = 220;
    VerticalStretch = true;
    HorizontalStretch = true;

    event FileDropped(Data: JsonObject);
}