pageextension 50250 "ACA - SA Customer Card" extends "Customer Card"
{
    actions
    {
        addafter(Comment)
        {
            action("Comment Editor")
            {
                Caption = 'Comment Editor';
                Image = ViewComments;
                trigger OnAction()
                var
                    EditCommentMeth: Codeunit "ACA - SA Edit Comment Meth";
                    RecVariant: Variant;
                begin
                    RecVariant := Rec;
                    EditCommentMeth.EditComment(RecVariant);
                    Rec := RecVariant;
                end;
            }
        }
    }
}