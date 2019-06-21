table 50100 "ACA - ACC Function"
{
    Caption = 'acadon_client.connect Function';
    DataPerCompany = false;

    fields
    {
        field(1; "ID"; Integer)
        {
            Caption = 'ID';
            NotBlank = true;
        }

        field(10; "Description"; Text[100])
        {
            Caption = 'Description';
        }

        field(20; "Script"; Blob)
        {
            Caption = 'Script';
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }

    procedure InsertFunction(Id: integer; Description: Text[100]; Script: Record TempBlob)
    var
        ACCFunction: Record "ACA - ACC Function";
    begin
        if ACCFunction.Get(Id) then
            ACCFunction.Delete();

        ACCFunction.Init();
        ACCFunction.Validate(ID, Id);
        ACCFunction.Validate(Description, Description);
        ACCFunction.Script := Script.Blob;
        ACCFunction.Insert();
    end;

    procedure GetScript(): Text
    var
        TempBlob: Record TempBlob;
    begin
        CalcFields(Script);
        TempBlob.Blob := Script;
        exit(TempBlob.ReadAsTextWithCRLFLineSeparator());
    end;
}