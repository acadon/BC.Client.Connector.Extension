page 50204 "ACA - ACCD Result ListFB"
{
    PageType = ListPart;
    SourceTable = "ACA - ACCD Result";
    Caption = 'Result';

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