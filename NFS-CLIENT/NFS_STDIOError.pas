{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     DOSCOPY Error Codes                                                  บ
 บ                                                                          บ
 บ     Version 1 11.10.2005 - last changed 23.10.2005                       บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Unit NFS_STDIOError;

Interface
         Procedure DosCopyError(ErrCode:Longword;FileName:String;NlsIdent:String);
         Procedure FileCreateError(ErrCode:Longword;FileName:String);
         Procedure FileReadError(ErrorCode:Longword;FileName:String);
         Procedure FileWriteError(ErrorCode:Longword;FileName:String);
         Procedure FileOpenError(ErrCode:Longword;FileName:String);
Implementation

USES  NFS_LanguageUnit,MyMessageBox,Sysutils;

Procedure DosCopyError(ErrCode:Longword;FileName:String;NLSIdent:String);
Var aString:String;
Begin
     case ErrCode of
       2:         aString:='ERROR_FILE_NOT_FOUND';
       3:          aString:='ERROR_PATH_NOT_FOUND';
       5:         aString:='ERROR_ACCESS_DENIED';
       26:        aString:='ERROR_NOT_DOS_DISK';
       32:        aString:='ERROR_SHARING_VIOLATION';
       36:        aString:='ERROR_SHARING_BUFFER_EXCEEDED';
       87:        aString:='ERROR_INVALID_PARAMETER';
       108:       astring:='ERROR_DRIVE_LOCKED';
       112:       aString:='ERROR_DISK_FULL';
       206:       aString:='ERROR_FILENAME_EXCED_RANGE';
       267:       aString:='ERROR_DIRECTORY';
       282:       aString:='ERROR_EAS_NOT_SUPPORTED';
       283:       aString:='ERROR_NEED_EAS_FOUND';
     ENd;
     aString:=SysErrorMessage(ErrCode);
     MyErrorBox(GetNLSString('ERRORS',NLSIdent)+#13+GetNLSString('ERRORS','CPY_FILENAME')+Filename+#13+GetNLSString('ERRORS','CPY_ERRORMESSAGE')+' '+aString);


End;

    Procedure FileOpenError(ErrCode:Longword;FileName:String);
    VAR S:String;
    Begin
      S:=GetNlsString('Errors','FileOpen');
      MYErrorBox(S+' '+Filename+#13+SysErrorMessage(ErrCode));
    End;

    Procedure FileCreateError(ErrCode:Longword;FileName:String);
    // 23.10.05
    VAR S:String;
    Begin
         S:=GetNLSString('ERRORS','FileCreate');
         MYErrorBox(S+' '+Filename+#13+SysErrorMessage(ErrCode));
    End;

    Procedure FileReadError(ErrorCode:Longword;FileName:String);
    // 23.10.05
    VAR S:String;
    Begin
         S:=GetNLSString('Errors','FileRead');
         MYErrorBox(S+' '+Filename+#13+SysErrorMessage(ErrorCode)) ;
    End;

    Procedure FileWriteError(ErrorCode:Longword;FileName:String);
    VAR S:String;
    Begin
         S:=GetNLSString('Errors','FileWrite');
         MYErrorBox(S+' '+Filename+#13+SysErrorMessage(ErrorCode));
    End;


End.
