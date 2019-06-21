codeunit 50203 "ACA - ACCD Capture Function"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ACA - ACC Execute", 'OnBeforeInvokeFunction', '', true, true)]
    local procedure OnBeforeInvokeFunction(sender: Codeunit "ACA - ACC Execute"; Id: Integer; InputFileContents: List of [Text]; InputFileNames: List of [Text]; InputVariables: JsonArray)
    var
        ACCFunction: Record "ACA - ACC Function";
    begin
        if not ACCFunction.Get(Id) then
            exit;

        if not ACCFunction.Capture then
            exit;

        CopyInputVariables(Id, InputVariables);
        CopyInputFiles(Id, InputFileContents, InputFileNames);
        Commit();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ACA - ACC Execute", 'OnAfterInvokeFunction', '', true, true)]
    local procedure OnAfterInvokeFunction(sender: Codeunit "ACA - ACC Execute"; Id: Integer; OutputFileContents: List of [Text]; OutputFileNames: List of [Text]; OutputVariables: JsonArray)
    var
        ACCFunction: Record "ACA - ACC Function";
    begin
        if not ACCFunction.Get(Id) then
            exit;

        if not ACCFunction.Capture then
            exit;

        CopyOutputVariables(Id, OutputVariables);
        CopyOutputFiles(Id, OutputFileContents, OutputFileNames);
        Commit();
    end;

    local procedure CopyInputFiles(Id: Integer; InputFileContents: List of [Text]; InputFileNames: List of [Text])
    var
        TempBlob: Record TempBlob;
        InputFile: Record "ACA - ACCD Input File";
        i: Integer;
    begin
        InputFile.SetRange("Function ID", Id);
        InputFile.DeleteAll();

        for i := 1 to InputFileNames.Count() do begin
            InputFile.Init();
            InputFile."Function ID" := Id;
            InputFile.Name := CopyStr(InputFileNames.Get(i), 1, 250);
            TempBlob.FromBase64String(InputFileContents.Get(i));
            InputFile."File Blob" := TempBlob.Blob;
            InputFile.Insert();
        end;
    end;

    local procedure CopyInputVariables(Id: Integer; var InputVariables: JsonArray)
    var
        InputVar: Record "ACA - ACCD Input Var";
        Item: JsonToken;
        InputVariable: JsonObject;
        JToken: JsonToken;
        VariableType: Text;
        VariableName: Text;
        VariableValue: JsonValue;
    begin
        InputVar.SetRange("Function ID", Id);
        InputVar.DeleteAll();


        foreach Item in InputVariables do begin
            InputVariable := Item.AsObject();
            InputVariable.Get('Name', JToken);
            VariableName := JToken.AsValue().AsText();

            InputVariable.Get('Type', JToken);
            VariableType := JToken.AsValue().AsText().ToLower();

            InputVariable.Get('Value', JToken);
            VariableValue := JToken.AsValue();


            InputVar.Init();
            InputVar."Function ID" := Id;
            InputVar.Name := CopyStr(VariableName, 1, 100);

            case VariableType of
                'string':
                    begin
                        InputVar.Validate(Type, InputVar.Type::String);
                        InputVar.Validate("String Value", CopyStr(VariableValue.AsText(), 1, 250));
                    end;
                'integer':
                    begin
                        InputVar.Validate(Type, InputVar.Type::Integer);
                        InputVar.Validate("Integer Value", VariableValue.AsInteger());
                    end;
                'number':
                    begin
                        InputVar.Validate(Type, InputVar.Type::Number);
                        InputVar.Validate("Number Value", VariableValue.AsDecimal());
                    end;
                'boolean':
                    begin
                        InputVar.Validate(Type, InputVar.Type::Boolean);
                        InputVar.Validate("Boolean Value", VariableValue.AsBoolean());
                    end;
            end;

            InputVar.Value := CopyStr(VariableValue.AsText(), 1, 250);
            InputVar.Insert();
        end;
    end;

    local procedure CopyOutputFiles(Id: Integer; OutputFileContents: List of [Text]; OutputFileNames: List of [Text])
    var
        TempBlob: Record TempBlob;
        OutputFile: Record "ACA - ACCD Output File";
        i: Integer;
    begin
        OutputFile.SetRange("Function ID", Id);
        OutputFile.DeleteAll();

        for i := 1 to OutputFileNames.Count() do begin
            OutputFile.Init();
            OutputFile."Function ID" := Id;
            OutputFile.Name := CopyStr(OutputFileNames.Get(i), 1, 250);
            TempBlob.FromBase64String(OutputFileContents.Get(i));
            OutputFile."File Blob" := TempBlob.Blob;
            OutputFile.Insert();
        end;
    end;

    local procedure CopyOutputVariables(Id: Integer; var OutputVariables: JsonArray)
    var
        Result: Record "ACA - ACCD Result";
        Item: JsonToken;
        OutputVariable: JsonObject;
        JToken: JsonToken;
        VariableType: Text;
        VariableName: Text;
        VariableValue: Text;
    begin
        Result.SetRange("Function ID", Id);
        Result.DeleteAll();

        foreach Item in OutputVariables do begin
            OutputVariable := Item.AsObject();
            OutputVariable.Get('Name', JToken);
            VariableName := JToken.AsValue().AsText();

            OutputVariable.Get('Type', JToken);
            VariableType := JToken.AsValue().AsText().ToLower();

            OutputVariable.Get('Value', JToken);
            VariableValue := JToken.AsValue().AsText();

            Result.Init();
            Result."Function ID" := Id;
            Result.Name := CopyStr(VariableName, 1, 100);
            Result.Value := CopyStr(VariableValue, 1, 250);
            Result.Insert();
        end;
    end;
}