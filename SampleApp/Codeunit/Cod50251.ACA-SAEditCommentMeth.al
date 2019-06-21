codeunit 50251 "ACA - SA Edit Comment Meth"
{
    procedure EditComment(var Rec: Variant);
    var
        Handled: Boolean;
    begin
        OnBeforeEditComment(Rec, Handled);
        DoEditComment(Rec, Handled);
        OnAfterEditComment(Rec);
    end;

    local procedure DoEditComment(var Rec: Variant; var Handled: Boolean);
    var
        TempBlob: Record TempBlob;
        CommentLine: Record "Comment Line";
        Content: List of [Text];
        NewContent: List of [Text];
    begin
        if Handled then
            exit;

        FilterCommentLine(Rec, CommentLine);
        ExtractCommentContent(CommentLine, Content);
        StoreContentInTempBlob(Content, TempBlob);
        OpenContentInEditor(TempBlob);
        SplitContent(TempBlob, NewContent, MaxStrLen(CommentLine.Comment));
        SaveContent(NewContent, CommentLine);
    end;

    local procedure FilterCommentLine(var Rec: Variant; var CommentLine: Record "Comment Line");
    var
        RecRef: RecordRef;
        NotSupportedTableErr: Label 'Table %1 is not supported.';
    begin
        RecRef.GetTable(Rec);
        if not Evaluate(CommentLine."Table Name", RecRef.Name()) then
            Error(NotSupportedTableErr, RecRef.Name());

        CommentLine.SetRange("Table Name", CommentLine."Table Name");
        CommentLine.SetRange("No.", RecRef.KeyIndex(1).FieldIndex(1).Value());
    end;


    local procedure ExtractCommentContent(var CommentLine: Record "Comment Line"; var Content: List of [Text]);
    begin
        Clear(Content);
        if not CommentLine.FindSet() then
            exit;

        repeat
            Content.Add(CommentLine.Comment);
        until CommentLine.Next() = 0;
    end;

    local procedure StoreContentInTempBlob(var Content: List of [Text]; var TempBlob: Record TempBlob)
    var
        Line: Text;
        CRLF: Text;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        Clear(TempBlob.Blob);

        foreach Line in Content do
            TempBlob.WriteTextLine(Line + CRLF);
    end;

    local procedure OpenContentInEditor(var Content: Record TempBlob);
    var
        ACCExecute: Codeunit "ACA - ACC Execute";
        FileNameTok: Label 'comment.txt', MaxLength = 250;
    begin
        ACCExecute.Init();
        ACCExecute.AddFile(FileNameTok, Content);
        ACCExecute.AddParameter('FileName', FileNameTok);
        ACCExecute.InvokeFunction(50250);
        ACCExecute.GetFileContent(FileNameTok, Content);
    end;

    local procedure SplitContent(var Content: Record TempBlob; var SplittedContent: List of [Text]; MaxLength: Integer);
    var
        Line: Text;
        SubString: Text;
        ResultString: Text;
        SpaceIndex: Integer;
    begin
        while Content.MoreTextLines() do begin
            Line := Content.ReadTextLine();
            while StrLen(line) > MaxLength do begin
                SubString := CopyStr(Line, 1, MaxLength);
                SpaceIndex := SubString.LastIndexOf(' ');

                if SpaceIndex = -1 then
                    SpaceIndex := MaxLength;

                if SpaceIndex = 0 then
                    SpaceIndex := MaxLength;

                if SpaceIndex < StrLen(SubString) then
                    ResultString := SubString.Substring(1, SpaceIndex)
                else
                    ResultString := SubString;

                SplittedContent.Add(ResultString);
                Line := Line.Remove(1, StrLen(ResultString));
            end;

            SplittedContent.Add(Line);
        end;
    end;

    local procedure SaveContent(var Content: List of [Text]; var CommentLine: Record "Comment Line");
    var
        CurrLineNo: Integer;
        Line: Text;
    begin
        if not CommentLine.IsEmpty() then
            CommentLine.DeleteAll();

        CurrLineNo := 10000;
        foreach Line in Content do begin
            CommentLine.Init();
            Evaluate(CommentLine."Table Name", CommentLine.GetFilter("Table Name"));
            CommentLine."No." := CopyStr(CommentLine.GetFilter("No."), 1, 20);
            CommentLine."Line No." := CurrLineNo;
            CommentLine.Comment := CopyStr(Line, 1, 100);
            CommentLine.Insert(true);
            CurrLineNo += 10000;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEditComment(var Rec: Variant; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterEditComment(var Rec: Variant);
    begin
    end;
}