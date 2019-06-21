page 50203 "ACA - ACCD Input Var ListFB"
{

    PageType = ListPart;
    SourceTable = "ACA - ACCD Input Var";
    Caption = 'Input Variables';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Name"; "Name")
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