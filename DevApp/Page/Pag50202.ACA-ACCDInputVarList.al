page 50202 "ACA - ACCD Input Var List"
{

    PageType = ListPart;
    SourceTable = "ACA - ACCD Input Var";
    Caption = 'Input Variables';
    Editable = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Function ID"; "Function ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Name"; "Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Value"; "Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}