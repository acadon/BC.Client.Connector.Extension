table 50202 "ACA - ACCD Input File"
{
    Caption = 'acadon_client.connect Input File';

    fields
    {
        field(1; "Function ID"; Integer)
        {
            Caption = 'Function ID';
            TableRelation = "ACA - ACC Function".ID;
            NotBlank = true;
        }

        field(2; "Name"; Text[250])
        {
            Caption = 'Name';
        }

        field(10; "File Blob"; Blob)
        {
            Caption = 'File Blob';
        }
    }

    keys
    {
        key(PK; "Function ID", Name)
        {
            Clustered = true;
        }
    }
}