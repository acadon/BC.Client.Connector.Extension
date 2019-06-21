codeunit 50201 "ACA - ACCD Start Function"
{
    TableNo = "ACA - ACC Function";

    var
        AccExecute: Codeunit "ACA - ACC Execute";

    trigger OnRun()
    begin
        TestField(Capture, false);
        AccExecute.Init();
        AppendParameters(ID);
        AppendFiles(ID);
        AccExecute.InvokeFunction(ID);
        SaveResult(ID);
        SaveFiles(ID);
    end;

    local procedure SaveResult(Id: Integer)
    var
        ACCDResult: Record "ACA - ACCD Result";
        OutputVariables: JsonArray;
        OutputVariable: JsonObject;
        Item: JsonToken;
        JToken: JsonToken;
        VariableType: Text;
        VariableName: Text;
        VariableValue: Text;
    begin
        OutputVariables := AccExecute.GetOutputVariables();

        ACCDResult.SetRange("Function ID", Id);
        ACCDResult.DeleteAll();

        foreach Item in OutputVariables do begin
            OutputVariable := Item.AsObject();
            OutputVariable.Get('Name', JToken);
            VariableName := JToken.AsValue().AsText();

            OutputVariable.Get('Type', JToken);
            VariableType := JToken.AsValue().AsText().ToLower();

            OutputVariable.Get('Value', JToken);
            VariableValue := JToken.AsValue().AsText();

            ACCDResult.Init();
            ACCDResult."Function ID" := Id;
            ACCDResult.Name := CopyStr(VariableName, 1, 100);
            ACCDResult.Value := CopyStr(VariableValue, 1, 250);
            ACCDResult.Insert();
        end;
    end;

    local procedure SaveFiles(Id: Integer)
    var
        OutputFile: Record "ACA - ACCD Output File";
        TempBlob: Record TempBlob;
        i: Integer;
    begin
        OutputFile.SetRange("Function ID", Id);
        OutputFile.DeleteAll();

        for i := 1 to AccExecute.FilesCount() do begin
            OutputFile.Init();
            OutputFile."Function ID" := Id;
            OutputFile.Validate(Name, CopyStr(AccExecute.GetFileName(i), 1, 250));
            AccExecute.GetFileContent(i, TempBlob);
            OutputFile."File Blob" := TempBlob.Blob;
            OutputFile.Insert();
        end;
    end;

    local procedure AppendParameters(Id: Integer)
    var
        InputVar: Record "ACA - ACCD Input Var";
    begin
        InputVar.SetRange("Function ID", ID);
        if not InputVar.FindSet() then
            exit;

        repeat
            case InputVar.Type of
                InputVar.Type::String:
                    AccExecute.AddParameter(InputVar.Name, InputVar."String Value");
                InputVar.Type::Integer:
                    AccExecute.AddParameter(InputVar.Name, InputVar."Integer Value");
                InputVar.Type::Number:
                    AccExecute.AddParameter(InputVar.Name, InputVar."Number Value");
                InputVar.Type::Boolean:
                    AccExecute.AddParameter(InputVar.Name, InputVar."Boolean Value");
            end;
        until InputVar.Next() = 0;
    end;

    local procedure AppendFiles(Id: Integer)
    var
        InputFile: Record "ACA - ACCD Input File";
        TempBlob: Record TempBlob;
    begin
        InputFile.SetRange("Function ID", ID);
        if not InputFile.FindSet() then
            exit;

        repeat
            InputFile.CalcFields("File Blob");
            TempBlob.Blob := InputFile."File Blob";
            AccExecute.AddFile(InputFile.Name, TempBlob);
        until InputFile.Next() = 0;
    end;
}