page 50206 "ACA - ACCD Output File ListFB"
{

    PageType = ListPart;
    SourceTable = "ACA - ACCD Output File";
    Caption = 'Result Files';

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
