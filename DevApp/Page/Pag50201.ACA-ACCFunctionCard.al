page 50201 "ACA - ACC Function Card"
{

    PageType = Card;
    SourceTable = "ACA - ACC Function";
    Caption = 'Function Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID"; "ID")
                {
                    ApplicationArea = All;
                }
                field("Description"; "Description")
                {
                    ApplicationArea = All;
                }
                field("Capture"; Capture)
                {
                    ApplicationArea = All;
                }
            }

            group(Code)
            {
                usercontrol(Editor; Editor)
                {
                    trigger ControlAddInReady()
                    begin
                        CurrPage.Editor.LoadCode(GetScript());
                    end;

                    trigger StoreCode(code: Text)
                    var
                        TempBlob: Record TempBlob;
                    begin
                        TempBlob.WriteAsText(code, TextEncoding::UTF8);
                        Script := TempBlob.Blob;
                        Modify();
                        Message(SaveMsg);
                    end;
                }
            }
        }
        area(factboxes)
        {
            part("Input Variables"; "ACA - ACCD Input Var ListFB")
            {
                SubPageLink = "Function ID" = field (ID);
                Editable = false;
            }
            part("Result Variables"; "ACA - ACCD Result ListFB")
            {
                SubPageLink = "Function ID" = field (ID);
                Editable = false;
            }
            part("Input Files"; "ACA - ACCD Input File ListFB")
            {
                SubPageLink = "Function ID" = field (ID);
                Editable = false;
            }
            part("Output Files"; "ACA - ACCD Output File ListFB")
            {
                SubPageLink = "Function ID" = field (ID);
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                PromotedIsBig = true;
                Promoted = true;
                ApplicationArea = All;
                Image = Save;

                trigger OnAction()
                begin
                    CurrPage.Editor.SaveCode();
                end;
            }
            action(Run)
            {
                PromotedIsBig = true;
                Promoted = true;
                ApplicationArea = All;
                Image = Start;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"ACA - ACCD Start Function", Rec);
                end;
            }
            action(Variables)
            {
                PromotedIsBig = true;
                Promoted = true;
                ApplicationArea = All;
                Image = BreakRulesList;

                trigger OnAction()
                var
                    InputVar: Record "ACA - ACCD Input Var";
                begin
                    InputVar.SetRange("Function ID", ID);
                    Page.Run(Page::"ACA - ACCD Input Var List", InputVar);
                end;
            }
            action(Export)
            {
                PromotedIsBig = true;
                Promoted = true;
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"ACA - ACCD Export Function", Rec);
                end;
            }
        }
    }

    var
        SaveMsg: Label 'Script saved.';
}
