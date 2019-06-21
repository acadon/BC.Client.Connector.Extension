codeunit 50250 "ACA - SampleApp Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    var
        ACCFunction: Record "ACA - ACC Function";
        TempBlob: Record TempBlob temporary;
        CRLF: Text;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;

        TempBlob.WriteTextLine('import(''System.IO'')' + CRLF);
        TempBlob.WriteTextLine('import(''System'',''System.Diagnostics'')' + CRLF);
        TempBlob.WriteTextLine('local filePath = Path.Combine(WorkspaceFolder, FileName)' + CRLF);
        TempBlob.WriteTextLine('local proc = Process.Start(''notepad.exe'', filePath)' + CRLF);
        TempBlob.WriteTextLine('proc:WaitForExit()' + CRLF);
        TempBlob.WriteTextLine('AddVariable(''ExitCode'', proc.ExitCode)' + CRLF);
        TempBlob.WriteTextLine('AddFile(filePath)' + CRLF);
        ACCFunction.InsertFunction(50250, 'Comment Editor', TempBlob);
    end;
}