page 50200 "ACA - ACC Function List"
{

    PageType = List;
    SourceTable = "ACA - ACC Function";
    Caption = 'Function List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "ACA - ACC Function Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("ID"; "ID")
                {
                    ApplicationArea = All;
                }
                field("Description"; "Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
