codeunit 50101 "ACA - ACC Execute"
{
    var
        OutputVariables: JsonArray;
        InputVariables: JsonArray;
        InputFileNames: List of [Text];
        InputFileContents: List of [Text];
        OutputFileNames: List of [Text];
        OutputFileContents: List of [Text];
        AlternativeDescription: Text;

    procedure Init()
    begin
        Clear(InputVariables);
        Clear(OutputVariables);
        Clear(AlternativeDescription);
    end;

    procedure AddParameter(Name: Text[100]; Value: Text)
    var
        InputVariable: JsonObject;
    begin
        InputVariable.Add('Name', Name);
        InputVariable.Add('Value', Value);
        InputVariable.Add('Type', 'String');
        InputVariables.Add(InputVariable);
    end;

    procedure AddParameter(Name: Text[100]; Value: Boolean)
    var
        InputVariable: JsonObject;
    begin
        InputVariable.Add('Name', Name);
        InputVariable.Add('Value', Value);
        InputVariable.Add('Type', 'Boolean');
        InputVariables.Add(InputVariable);
    end;

    procedure AddParameter(Name: Text[100]; Value: Integer)
    var
        InputVariable: JsonObject;
    begin
        InputVariable.Add('Name', Name);
        InputVariable.Add('Value', Value);
        InputVariable.Add('Type', 'Integer');
        InputVariables.Add(InputVariable);
    end;

    procedure AddParameter(Name: Text[100]; Value: Decimal)
    var
        InputVariable: JsonObject;
    begin
        InputVariable.Add('Name', Name);
        InputVariable.Add('Value', Value);
        InputVariable.Add('Type', 'Number');
        InputVariables.Add(InputVariable);
    end;

    procedure AddFile(Name: Text[250]; FileBlob: Record TempBlob)
    begin
        InputFileNames.Add(Name);
        InputFileContents.Add(FileBlob.ToBase64String());
    end;

    procedure SetAlternativeDescription(Description: Text)
    begin
        AlternativeDescription := Description;
    end;

    procedure InvokeFunction(Id: Integer)
    var
        ConnectorPage: Page "ACA - ACC Connector";
    begin
        OnBeforeInvokeFunction(Id);
        ConnectorPage.SetRequest(CreateRequest(Id));
        ConnectorPage.SetAlternativeDescription(AlternativeDescription);
        ConnectorPage.RunModal();

        if not ConnectorPage.HasResponseReceived() then
            Error('');

        ParseResponse(ConnectorPage.GetResponse());
        OnAfterInvokeFunction(Id);
    end;

    procedure GetOutputVariables(): JsonArray
    begin
        exit(OutputVariables);
    end;

    procedure GetTextVariable(Name: Text): Text
    var
        JValue: JsonValue;
    begin
        if not GetOutputValue(Name, JValue) then
            exit('');

        exit(JValue.AsText());
    end;

    procedure GetIntegerVariable(Name: Text): Integer
    var
        JValue: JsonValue;
    begin
        if not GetOutputValue(Name, JValue) then
            exit(0);

        exit(JValue.AsInteger());
    end;

    procedure GetDecimalVariable(Name: Text): Decimal
    var
        JValue: JsonValue;
    begin
        if not GetOutputValue(Name, JValue) then
            exit(0);

        exit(JValue.AsDecimal());
    end;

    procedure GetBooleanVariable(Name: Text): Boolean
    var
        JValue: JsonValue;
    begin
        if not GetOutputValue(Name, JValue) then
            exit(false);

        exit(JValue.AsBoolean());
    end;

    procedure FilesCount(): Integer
    begin
        exit(OutputFileNames.Count());
    end;

    procedure GetFileName(Index: Integer): Text
    begin
        exit(OutputFileNames.Get(Index));
    end;

    procedure GetFileContent(Index: Integer; var TempBlob: Record TempBlob)
    begin
        TempBlob.init();
        TempBlob.FromBase64String(OutputFileContents.Get(Index));
    end;

    procedure GetFileContent(FileName: Text; var TempBlob: Record TempBlob)
    var
        Index: Integer;
    begin
        TempBlob.init();
        if not OutputFileNames.Contains(FileName) then
            exit;

        Index := OutputFileNames.IndexOf(FileName);
        TempBlob.FromBase64String(OutputFileContents.Get(Index));
    end;

    local procedure GetOutputValue(Name: Text; var JValue: JsonValue): Boolean
    var
        Token: JsonToken;
        JPath: Text;
    begin
        JPath := StrSubstNo('$.[?(@.Name==''%1'')].Value', Name);
        OutputVariables.SelectToken(JPath, Token);
        if not Token.IsValue() and (Token.AsValue().IsUndefined() or Token.AsValue().IsNull()) then
            exit(false);

        JValue := Token.AsValue();
        exit(true);
    end;

    local procedure ParseResponse(Response: JsonObject)
    var
        ResponseType: JsonToken;
    begin
        if not Response.Get('ResponseType', ResponseType) then
            Error('%1', Response);

        case UpperCase(ResponseType.AsValue().AsText()) of
            'OK':
                ProcessResponse(Response);
            else
                ProcessError(Response);
        end;
    end;

    local procedure ProcessResponse(Response: JsonObject)
    var
        VariablesToken: JsonToken;
        FilesToken: JsonToken;
    begin
        if Response.Get('Variables', VariablesToken) then
            ProcessVariables(VariablesToken);

        if Response.Get('Files', FilesToken) then
            ProcessFiles(FilesToken);
    end;

    local procedure ProcessVariables(Token: JsonToken)
    begin
        if not token.IsArray() then
            exit;

        OutputVariables := Token.AsArray();
    end;

    local procedure ProcessFiles(Token: JsonToken)
    var
        Files: JsonArray;
        FileToken: JsonToken;
    begin
        if not token.IsArray() then
            exit;

        Files := Token.AsArray();
        foreach FileToken in Files do
            ProcessFile(FileToken);
    end;

    local procedure ProcessFile(Token: JsonToken)
    var
        NameToken: JsonToken;
        ValueToken: JsonToken;
        Variable: JsonObject;
    begin
        if not token.IsObject() then
            exit;

        Variable := Token.AsObject();
        Variable.Get('Name', NameToken);
        Variable.Get('Value', ValueToken);

        OutputFileNames.Add(NameToken.AsValue().AsText());
        OutputFileContents.Add(ValueToken.AsValue().AsText());
    end;

    local procedure ProcessError(Response: JsonObject)
    var
        ErrorMessage: JsonToken;
    begin
        if not Response.Get('Message', ErrorMessage) then
            Error('%1', Response)
        else
            Error(ErrorMessage.AsValue().AsText());
    end;

    local procedure CreateRequest(Id: Integer): JsonObject
    var
        ACCFunction: Record "ACA - ACC Function";
        Request: JsonObject;
    begin
        ACCFunction.Get(Id);
        Request.Add('OperationName', ACCFunction.Description);
        Request.Add('CompanyName', CompanyName());
        Request.Add('SerialNo', SerialNumber());
        Request.Add('ApiVersion', '1.0');
        Request.Add('Script', ACCFunction.GetScript());
        AppendParameters(Request);
        AppendFiles(Request);
        exit(Request);
    end;

    local procedure AppendFiles(var request: JsonObject)
    var
        Files: JsonArray;
        i: Integer;
    begin
        for i := 1 to InputFileNames.Count() do
            Files.Add(CreateFile(InputFileNames.Get(i), InputFileContents.Get(i)));

        request.Add('Files', Files);
    end;

    local procedure AppendParameters(var request: JsonObject)
    begin
        request.Add('Parameters', InputVariables);
    end;

    local procedure CreateFile(Name: Text; Content: Text): JsonObject
    var
        FileObject: JsonObject;
    begin
        FileObject.Add('Name', Name);
        FileObject.Add('Value', Content);
        exit(FileObject);
    end;

    [IntegrationEvent(true, true)]
    local procedure OnBeforeInvokeFunction(Id: Integer)
    begin
    end;

    [IntegrationEvent(true, true)]
    local procedure OnAfterInvokeFunction(Id: Integer)
    begin
    end;
}