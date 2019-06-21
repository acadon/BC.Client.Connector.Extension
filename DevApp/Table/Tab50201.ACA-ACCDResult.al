table 50201 "ACA - ACCD Result"
{
    Caption = 'acadon_client.connect Result Variable';

    fields
    {
        field(1; "Function ID"; Integer)
        {
            Caption = 'Function ID';
            TableRelation = "ACA - ACC Function".ID;
            NotBlank = true;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(100; "Value"; Text[250])
        {
            Caption = 'Value';
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