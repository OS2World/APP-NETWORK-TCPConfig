Unit Deltree;
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Deltree Unit Version 1                                               บ
 บ                                                                          บ
 บ     Modified for TCP Project 13.08.2005                                  บ
 บ     Last Modified 13.08.2005                                             บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Interface
Procedure DeltreeProc(sPath : string);
Implementation

USES DOS,Dialogs,SysUtils;

VAR
   MyIOResult:Longint;

function RemoveSlash( Dir: string ): string;
begin
  Result:= Dir;
  if Dir<>'' then
    if Result[ length( Result ) ]='\' then
      Delete( Result, length( Result ), 1 );
end;

Procedure MyDeleteFile(FileName:String);
// Routine DeleteFile in Sysutils doesnt return Error Code
VAR DelFile:File;
    ErrCode:Word;
    Attr:Longword;
Begin
{$I-}
     Assign(DelFile,FileName);
     GETFAttr(DelFile,Attr);
     SetFAttr(DelFile,0);
     IF DosError<>0 Then
     Begin
          ErrorBox('FileAttrib Error : '+ToStr(DOsError));
     End;
     Erase(DelFile);ErrCode:=IoResult;
     IF ErrCode<>0 then
     begin
          ErrorBox(FileName+' could not be deleted , Code :'+toStr(ErrCOde));
     End;
End;

procedure DeltreeProc(sPath : string);
var Search : SearchRec;
begin

     Spath:=RemoveSlash(Spath); // Remove the "/" (if any (root dir only) ) from the given path

     DOS.FindFirst(sPath + '\*.*', (AnyFile), Search); // call findfirst

     while (DosError = 0) do
        begin
                // Direcory found check if any other Direcotrys are inside

                if (Search.Attr = Directory) or (Search.Attr = 48) or (Search.Attr=22) then
                { Check if the Attribute in Search.Attr matches one of the following pre-definated values :
                 16:(Directory) Entry found is a Directory
                 48:(Unknown)   Entry found is a Directory with the ARCHIVE Attrib set (only seen by a JFS drive so far)
                 22:(Unkown)    Entry found is a SPECIAL Directory (HPFS Drive \OS2 folder)
                }
                  begin
                       if (Search.Name <> '.') and (Search.Name <> '..') then // is the Directory Name NOT "." or ".." then search next Directory (call procedure again)
                          begin
                               DeltreeProc(sPath + '\' + Search.Name);
                          end;
                  end
                     else // Attib is no Directory wich means we found a FILE now calling File Delete Routine
                         begin
                            MyDeleteFile(sPath + '\' + Search.Name); // call the DeleteFile Routine
                         end;

            DOS.FindNext(Search); // continue search until DOS Error reports 18 (no more files)
     end;
 DOS.FindClose(Search); // Close the search for now

{$I-}
     RMDir(sPath);MyIoResult:=IoResult; // Try to remove the "empty" Directory
      IF MyIoResult<>0 Then
      Begin
           // Error Direcory not empty or locked
           ErrorBox('Could not delete Direcory : '+SPath+#13+SysErrorMessage(MyIoResult));
      End else
     Begin
          // Directory was empty and is successfully removed
          ShowMessage('Directory : '+Spath+' deleted successfuly');
     End;
{$I+}
end;

End.
