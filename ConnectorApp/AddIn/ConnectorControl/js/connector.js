var navControlContainer;
var navControl;
var timer;
var alternativeDescription = '';

$(document).ready(function () {
    CreateControl();
});

function CreateControl() {
    navControlContainer = $("#controlAddIn");
    navControlContainer.append('<div class="control"><div id="operation"></div><div id="install"></div></div>');
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlAddInReady", []);
};

function InvokeFunctionAsync(request) {
    if (alternativeDescription) {
        $("#operation").text(alternativeDescription);
    } else {
        $("#operation").text(request.OperationName);
    }
    $.support.cors = true;

    GetSessionPortCheckSessionAndExecute(request);
}

function GetSessionPortCheckSessionAndExecute(request) {
    var cookieStoredPort = Cookies.get('acc_sessionPort');
    if (cookieStoredPort) {
        CheckSessionAndExecute(request, cookieStoredPort);
        return;
    }

    $.ajax({
        type: "POST",
        url: "http://localhost:5000", 
        data: "BROKER",
        success: function(response) {
            Cookies.set('acc_sessionPort', response.Port);
            CheckSessionAndExecute(request, response.Port);
        },
        dataType: 'json',
        timeout: 5000
    }).fail(function(response) {
        $("#install").show();
    });  
}

function CheckSessionAndExecute(request, port) {
    $.ajax({
        type: "POST",
        url: "http://localhost:" + port, 
        data: "PING", 
        success: function(response) {
            ExecuteScriptCall(request, port);
        },
        dataType: 'json',
        timeout: 5000
    }).fail(function(response) {
        $("#install").show();
    });
}

function ExecuteScriptCall(request, port) {
    timer = window.setInterval(function() { Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("KeepAlive", []); }, 60000);
    $.ajax({
        type: "POST",
        url: "http://localhost:" + port, 
        data: JSON.stringify(request), 
        success: function(response) {
            clearInterval(timer);
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnEndInvokeFunction", [response]);
        },
        dataType: 'json',
        timeout: 0
    }).fail(function(response) {
        clearInterval(timer);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnEndInvokeFunction", [JSON.parse('{ "ResponseType": "Error", "Message": "' + response.errorText + '" }')]);
    });
}

function SetInstallContent(content) {
    $("#install").html(content);
}

function SetAlternativeDescription(description) {
    alternativeDescription = description;
}