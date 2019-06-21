controladdin Editor
{
    RequestedHeight = 500;
    RequestedWidth = 220;
    VerticalStretch = true;
    HorizontalStretch = true;

    Scripts =
        'AddIn/Editor/js/jquery-1.11.0.min.js',
        'AddIn/Editor/js/codemirror.js',
        'AddIn/Editor/js/matchbrackets.js',
        'AddIn/Editor/js/lua.js',
        'AddIn/Editor/js/editor.js';

    StyleSheets =
        'AddIn/Editor/css/codemirror.css',
        'AddIn/Editor/css/lesser-dark.css';

    event ControlAddInReady();
    event StoreCode(code: Text);
    procedure SaveCode();
    procedure LoadCode(code: Text);
}