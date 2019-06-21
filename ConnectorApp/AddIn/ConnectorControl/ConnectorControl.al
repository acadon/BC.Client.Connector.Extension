controladdin ConnectorControl
{
    RequestedHeight = 800;
    RequestedWidth = 220;
    VerticalStretch = true;
    HorizontalStretch = true;

    Scripts =
        'AddIn/ConnectorControl/js/jquery-1.11.0.min.js',
        'AddIn/ConnectorControl/js/js.cookie.js',
        'AddIn/ConnectorControl/js/connector.js';

    StyleSheets =
        'AddIn/ConnectorControl/css/control.css';

    Images =
        'AddIn/ConnectorControl/img/loading.gif';

    event ControlAddInReady();
    event KeepAlive();
    event OnEndInvokeFunction(response: JsonObject);
    procedure SetInstallContent(content: Text);
    procedure SetAlternativeDescription(content: Text);
    procedure InvokeFunctionAsync(request: JsonObject);
}