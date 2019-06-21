# Notepad sample

## AL Code
```
procedure EditTextInNotepad(var TextToEdit: Text);
var
    TempBlob: Record TempBlob;
begin
    TempBlob.WriteAsText(TextToEdit, TextEncoding::UTF8);
    ACCExecute.Init();
    ACCExecute.AddFile('demo.txt', TempBlob);
    ACCExecute.InvokeFunction(50000);
    ACCExecute.GetFileContent('demo.txt', TempBlob);
    TextToEdit := TempBlob.ReadAsTextWithCRLFLineSeparator();
end;
```

## LUA Script
```LUA
import('System.IO')
import('System','System.Diagnostics')
local filePath = Path.Combine(WorkspaceFolder, 'demo.txt')
local proc = Process.Start('notepad.exe', filePath)
proc:WaitForExit()
AddVariable('ExitCode', proc.ExitCode)
AddFile(filePath)
```