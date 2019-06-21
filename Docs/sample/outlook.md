# Outlook sample

## AL Code
```
 procedure SendMail(Recipient: Text; RecipientCC: Text; RecipientBCC: Text; Subject: Text; MailBody: Text);
var
    ACCExecute: Codeunit "ACA - ACC Execute";
begin
    ACCExecute.Init();
    ACCExecute.AddParameter('MailTo', Recipient);
    ACCExecute.AddParameter('MailCC', RecipientCC);
    ACCExecute.AddParameter('MailBCC', RecipientBCC);
    ACCExecute.AddParameter('MailSubject', Subject);
    ACCExecute.AddParameter('MailBody', BodyText);
    ACCExecute.AddParameter('MailRunModal', false);
    ACCExecute.InvokeFunction(50010);
end;
```

## LUA Script
```LUA
import('System')
import('System.IO')
import('System.Reflection')

local args = Array.CreateInstance(Type.GetType("System.Object"), 1)

args:SetValue(0, 0)
local t = Type.GetTypeFromProgID('Outlook.Application')

local oOApp = Activator.CreateInstance(t)
local m = t:InvokeMember("CreateItem", BindingFlags.InvokeMethod, nil, oOApp, args)

args:SetValue(MailTo, 0)
m:GetType():InvokeMember("To", BindingFlags.SetProperty, Type.DefaultBinder, m, args)

args:SetValue(MailCC, 0)
m:GetType():InvokeMember("CC", BindingFlags.SetProperty, Type.DefaultBinder, m, args)

args:SetValue(MailBCC, 0)
m:GetType():InvokeMember("BCC", BindingFlags.SetProperty, Type.DefaultBinder, m, args)

args:SetValue(MailSubject, 0)
m:GetType():InvokeMember("Subject", BindingFlags.SetProperty, Type.DefaultBinder, m, args)

args:SetValue(MailBody, 0)
if not String.IsNullOrEmpty(MailBody) then
	m:GetType():InvokeMember("HTMLBody", BindingFlags.SetProperty, Type.DefaultBinder, m, args)
end

local att = m:GetType():InvokeMember("Attachments", BindingFlags.GetProperty, Type.DefaultBinder, m, nil)

local attachmentFiles = Directory.GetFiles(WorkspaceFolder)
local attachmentsCount = attachmentFiles.Length

for i=0,attachmentsCount - 1 do
  args:SetValue(attachmentFiles[i], 0)
  att:GetType():InvokeMember("Add", BindingFlags.InvokeMethod, nil, att, args)
end

args:SetValue(MailRunModal, 0)
m:GetType():InvokeMember("Display", BindingFlags.InvokeMethod, nil, m, args)
```