page 50205 "ACA - ACCD Input File ListFB"
{

    PageType = ListPart;
    SourceTable = "ACA - ACCD Input File";
    Caption = 'Input Files';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Name"; "Name")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        OpenFile();
                    end;
                }
            }

            usercontrol("DropZone"; AcadonDropZone)
            {
                ApplicationArea = All;

                trigger FileDropped(Data: JsonObject);
                var
                    TempBlob: Record TempBlob;
                    JToken: JsonToken;
                    Content: Text;
                    FileName: Text;
                begin
                    Data.Get('FileName', JToken);
                    FileName := JToken.AsValue().AsText();
                    Data.Get('Data', JToken);
                    Content := JToken.AsValue().AsText();
                    Content := Content.Substring(Content.IndexOf(',') + 1);
                    TempBlob.FromBase64String(Content);
                    Init();
                    Name := CopyStr(FileName, 1, 250);
                    "File Blob" := TempBlob.Blob;
                    Insert();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure OpenFile()
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
    begin
        CalcFields("File Blob");
        TempBlob.Blob := "File Blob";
        FileMgt.BLOBExport(TempBlob, Name, true);
    end;
}
