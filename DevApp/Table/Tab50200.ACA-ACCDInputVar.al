table 50200 "ACA - ACCD Input Var"
{
    Caption = 'acadon_client.connect Input Variable';

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

        field(10; "Type"; Option)
        {
            OptionMembers = String,Number,Integer,Boolean,Null;
        }
        field(20; "String Value"; Text[250])
        {

        }
        field(21; "Integer Value"; Integer)
        {

        }
        field(22; "Number Value"; Decimal)
        {

        }
        field(23; "Boolean Value"; Boolean)
        {

        }
        field(100; "Value"; Text[250])
        {
            Caption = 'Value';
            trigger OnValidate()
            begin
                clear("String Value");
                clear("Integer Value");
                Clear("Number Value");
                Clear("Boolean Value");

                if Value = '' then
                    exit;

                case Type of
                    Type::String:
                        Evaluate("String Value", Value);
                    Type::Integer:
                        Evaluate("Integer Value", Value);
                    Type::Number:
                        Evaluate("Number Value", Value);
                    Type::Boolean:
                        Evaluate("Boolean Value", Value);
                end;
            end;
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