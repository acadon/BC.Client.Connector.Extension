codeunit 50202 "ACA - ACCD Export Function"
{
    TableNo = "ACA - ACC Function";

    trigger OnRun()
    var
        TempBlobScript: Record TempBlob;
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        CRLF: Text;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        CalcFields(Script);
        TempBlobScript.Blob := Script;

        TempBlob.WriteTextLine('codeunit 50000 "Function Installer"' + CRLF);
        TempBlob.WriteTextLine('{' + CRLF);
        TempBlob.WriteTextLine('    Subtype = Install;' + CRLF);
        TempBlob.WriteTextLine('' + CRLF);
        TempBlob.WriteTextLine('    trigger OnInstallAppPerDatabase()' + CRLF);
        TempBlob.WriteTextLine('    var' + CRLF);
        TempBlob.WriteTextLine('        ACCFunction: Record "ACA - ACC Function";' + CRLF);
        TempBlob.WriteTextLine('        TempBlob: Record TempBlob temporary;' + CRLF);
        TempBlob.WriteTextLine('        CRLF: Text;' + CRLF);
        TempBlob.WriteTextLine('    begin' + CRLF);
        TempBlob.WriteTextLine('        CRLF[1] := 13;' + CRLF);
        TempBlob.WriteTextLine('        CRLF[2] := 10;' + CRLF);
        TempBlob.WriteTextLine('' + CRLF);

        while TempBlobScript.MoreTextLines() do
            TempBlob.WriteTextLine('        TempBlob.WriteTextLine(''' + TempBlobScript.ReadTextLine().Replace('''', '''''') + ''' + CRLF);' + CRLF);

        TempBlob.WriteTextLine('        ACCFunction.InsertFunction(' + Format(ID) + ', ''' + Description + ''', TempBlob);' + CRLF);
        TempBlob.WriteTextLine('    end;' + CRLF);
        TempBlob.WriteTextLine('}');

        FileMgt.BLOBExport(TempBlob, 'Cod50000.FunctionInstaller.al', true);
    end;
}