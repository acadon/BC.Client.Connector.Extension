var navControlContainer;
var navControl;
var editor;

$(document).ready(function () {
    CreateControl();
});

function CreateControl() {
    navControlContainer = $("#controlAddIn");
    navControlContainer.append('<textarea id="code" name="code" style="width:100%">AddFile()</textarea>');

    editor = CodeMirror.fromTextArea(document.getElementById("code"), {
        matchBrackets: true,
        lineNumbers: true,
        theme: "lesser-dark",
        extraKeys: {
            "Ctrl-S": function(instance) { SaveCode(); }
        }
      });

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlAddInReady", []);
};

function LoadCode(code) {
    editor.getDoc().setValue(code);
}

function SaveCode() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("StoreCode", [editor.getDoc().getValue()]);
}