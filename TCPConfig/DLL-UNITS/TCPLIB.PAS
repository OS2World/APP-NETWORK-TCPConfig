{$H-}
 {$X+,T-}
library PasswordCrypt;
USES mem_util, sha1,DOS,sysutils,Os2Exec, Os2Base,VPUtils,IniFiles,crt,Classes,OS2DEF,TCPLib_UtilityUnit,OS2PMApi;

{$PMTYPE PM}     // Presentation Manager example
{$X+,T-}  // Compiler settings

Type
        TRPC_InfoRec=Record
        MountSucessFull:Boolean;
        Daemon_Status:Boolean;
        Daemon_Nlock:Boolean;
        Daemon_PCNFSD:Boolean;
        Daemon_NFSD:Boolean;
        Error:Boolean;
        End;

CONST   IniSection='Interface#';

VAR
    Ini:TOs2IniFile;
    ExeList:TStringlist;
    DLL_Result_String:String;
    ShowExpList:TStringlist;
    RPC_Info:TRPC_InfoRec;
    hwndClient : HWnd;   // client window handle
    {Ab         : Hab;
    Mq         : Hmq;}


CONST Query_PID=0;
      Query_PathName=1;

      Info_NFSD=0;
      INFO_PCNFSD=1;
      INFO_LOCK=2;
      INFO_STATUS=3;
      Info_Mount=4;
      Info_error=5;



Procedure CryptUserPassword(Stri:String);
VAR
  SHA1Context: TSHA1Context;
  SHA1Digest: TSHA1Digest;

Begin
  SHA1Init(SHA1Context);
  SHA1Update(SHA1Context,@stri[1],length(Stri));
  SHA1Final(SHA1Context,SHA1Digest);
  DLL_Result_String:=(HexStr(@SHA1Digest, sizeof(SHA1Digest)));
End;




      Function DLLVersion:Integer; export;
      Begin
        result:=7;
      End;



Function DLLTest(VAR aString:String;VAR aString2:String):Longint;
VAR ExitCode:Longint;
Begin

     execFlags:=efAsync;
     exec(aString,aString2);
     Result:=Dos.DosError;
     ExitCode:=DosExitCode;
     delay(600);
     Result:=0;
End;

Function DLLExecutePrg(aString:String;aString2:String):Longint;
VAR ExitCode:Longint;
Begin

     execFlags:=efAsync;
     exec(aString,aString2);
     Result:=Dos.DosError;
     ExitCode:=DosExitCode;

End;

Function DllReturnString:string;
Begin
     result:=DLL_Result_String;

End;


Procedure teststri2(test:String;B:Byte);
Begin
        DLL_Result_String:=Test+'! DLL + Wert von B '+Int2Str(B);
End;


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Process Information Query                                            บ
 บ                                                                          บ
 บ     Version 1 18.11.2005                                                 บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Function ReadString(StartPos:Byte;COnfigStr:String):String;
        // Liest einen String ab POS X bis zum vorkommen eines "Leerzeichens" und liefert danch den korrekten String zurck
        VAR
            Output:String;

        Begin
                IF StartPos>length(ConfigStr) Then Begin Result:='#';STartPos:=255;exit;End;
                Output:='';
           REPEAT
                IF COnfigStr[StartPos]=#0 Then Begin Result:=Output;StartPos:=254;Exit;End; // Zeilenende Erreicht
                IF ConfigStr[StartPos]<>' ' Then

                Begin
                        OutPut:=Output+ConfigStr[StartPos];
                End else
                Begin
                        Result:=Output;exit;
                End;
                Inc(StartPos);
          UNTIL StartPos>Length(ConfigStr);
          Result:=Output;
        End;



Procedure QueryMessage(s:String);
VAR   Loop:Byte;PID,TMP:String;
Begin
        For Loop:=0 to ExeList.count-1 do
        Begin
                IF FindWordInStri(EXEList[Loop],S)<>-1 Then
                                                        begin
                                                        PID:=COpy(S,1,5);
                                                        TMP:=ReadString(31,S);
                                                        IF ExeList[Loop]='FTPD' Then Ini.WriteString('TCPConfig',ExeList[loop]+'_PATH',TMP);
                                                        Ini.WriteString( 'TCPConfig',ExeList[loop],PID);Break;
                                                        End;
       End;

End;



Function DoGetProcessList:Boolean;
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  S   :String;
  O   :String;
  Test:Array[0..259] of char;
begin

tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          StrPCopy(Test,S);                  // Set up DosExecPgm parameters
          tr.Execute('PSTAT.EXE','/C', nil );
          While not tr.Terminated do         // While command is executing
            If tr.MessageReady then          // Ask if a line is ready
             Begin
                        QueryMessage(tr.Message);
                        {O:=TR.Message;
                        QueryMessage(O);}
             End
else
              DosSleep( 30 );                // - otherwise wait a little
    finally
      tr.Destroy;                            // Free the instance
      Result:=True;
    end else Result:=FALSE;
end;

Function GetProcessList:longint;
Begin
        Ini:=TOS2IniFile.Create;
        ExeList:=TStringlist.Create;
        ExeList.add(Uppercase('TFTPD'));
        ExeList.add(Uppercase('TelnetD'));
        ExeList.add(Uppercase('FTPD'));
        ExeList.add(Uppercase('INETD'));
        ExeList.add(Uppercase('RSHD'));
        Exelist.add(Uppercase('LPD'));
        ExeList.add(Uppercase('routed'));
        ExeList.add(Uppercase('talkd'));
        ExeList.add(Uppercase('portmap'));
        ExeList.add(Uppercase('rsvpd'));
        ExeList.add(Uppercase('syslogd'));
        ExeList.add(Uppercase('timed'));
        ExeList.add(Uppercase('pcnfsd'));
        ExeList.add(Uppercase('nfsd'));
        ExeList.add(UpperCase('timed'));
        ExeList.add(Uppercase('rexecd'));
        ExeList.add(Uppercase('sendmail'));
        ExeList.add(Uppercase('rpcinfo'));
        IF DoGetProcessList Then result:=0 else Result:=-1;
        INI.Destroy;
End;

Function BootDrive: char;
var
  buffer: longint;
begin
  DosQuerySysInfo( QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,buffer,sizeof( buffer ) );
  Result := chr( ord( 'A' ) + buffer - 1 );
end;


Function Execute_TCPStart(Path:String):longint;
Begin
        IF Path='' Then Begin Result:=2;exit;End;
        Exec( GetEnv('COMSPEC'), '/C '+Path+'\'+'TCPSTART.CMD');
        Result:=DOS.DOsError;
End;


Function InsertCommand(StringToInsert:String):String;
        VAR
                Posi:Byte;
                S:String;
        Begin
                S:=StringToInsert;
                IF Copy(Uppercase(StringToInsert),1,5)='START' Then
                Begin
                        Insert('/C ',S,7);
                End;
        Result:=S;
        End;


Function Execute_TCPServer(Command:String):Longint;
VAR
        ServerFile:Text;IOError:Longint;
Begin
        Assign(ServerFile,BootDrive+':\OS2\TCPHLP.CMD');
        {$I-}
         Rewrite(ServerFile);IOError:=IOResult;IF IOError<>0 Then Begin Result:=IOError;exit;END;

        //Writeln(ServerFile,InsertCommand(Path));
        Writeln(ServerFile,Command);
        IOError:=IOResult;IF IOError<>0 Then Begin Close(ServerFile);Result:=IOError;exit;END;

        CLose(ServerFile);

        Exec( GetEnv('COMSPEC'), '/C '+BootDrive+':\OS2\TCPHLP.CMD');
        Result:=DOS. DOSError;



End;

Procedure ExecuteMount(MountString:String);
Begin

End;


Procedure QueryProcessList(ProcessName:String;Mode:Byte);
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  S   :String;
  Test:Array[0..259] of char;
  Loop:Byte;
begin
DLL_Result_String:='';
tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          StrPCopy(Test,S);                  // Set up DosExecPgm parameters
          tr.Execute('PSTAT.EXE','/C', nil );
          While not tr.Terminated do         // While command is executing
            If tr.MessageReady then          // Ask if a line is ready
             Begin
                        //PlaySound(100,10);
                        //QueryMessage(tr.Message);
                        S:=Tr.Message;
                        IF FindWordInStri(ProcessName,S)<>-1 Then
                        Begin
                        Case Mode of
                                Query_PID:Begin DLL_Result_String:=COpy(S,2,4);exit;End;
                                Query_Pathname:Begin DLL_Result_String:=ReadString(31,S);exit;End;
                         End;
                        End;

             End
                else DosSleep( 30 );                // - otherwise wait a little
    finally
      tr.Destroy;                            // Free the instance
    end;
    DLL_Result_String:='-1';
End;


Function DOShowExp(IPAdress:String):Boolean;
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  Test:Array[0..259] of char;
  StrMessage:String;

Begin
Result:=FALSE;DLL_Result_String:='OK';
tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
  Begin
        StrPCopy(Test,IPAdress);                  // Set up DosExecPgm parameters
        { Execute the command to grab the output from }
        if not tr.Execute('ShowExp.EXE',test, nil ) Then Begin Tr.Destroy;exit;End;

          While not tr.Terminated do         // While command is executing
          If tr.MessageReady then          // Ask if a line is ready
             Begin
                        StrMessage:=TR.Message;
                        {ShowExpList.Add(Tr.Message);}
                        IF Copy(StrMessage,1,6)='NFSU30' Then
                        Begin
                              DLL_Result_String:=StrMessage;
                              Tr.Destroy;Exit;
                        End;
             ShowExpList.Add(StrMessage);
             End else DosSleep( 30 );                // - otherwise wait a little
      tr.Destroy;                            // Free the instance
      Result:=True;
End
         else
                TR.Destroy;
End;

Function DoMount(ExeName:String;Parameter:String):Boolean;
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  Test:Array[0..259] of char;
  PExeName:Array[0..259] of char;
  TextFile:Text;
  aText:String;

Begin
Assign(TextFile,'output.txt');Rewrite(textfile);
Result:=FALSE;
tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
  Begin
        StrPCopy(Test,Parameter);                  // Set up DosExecPgm parameters
        StrPCopy(PExeName,ExeName);
        { Execute the command to grab the output from }
        if not tr.Execute(ExeName,test, nil ) Then Begin Tr.Destroy;exit;End;

          While not tr.Terminated do         // While command is executing
          If tr.MessageReady then          // Ask if a line is ready
             Begin
                        Writeln(TextFile,Tr.Message);
             End else DosSleep( 30 );                // - otherwise wait a little
      tr.Destroy;                            // Free the instance
      Result:=True;
      CLose(TextFile);
End
         else
                TR.Destroy;

End;


Procedure GetNFSExport(aIPAdress:String);
VAR
        ExpFile:Text;
        ExpText:String;
        IOError:Integer;
        I:longint;
        FileName:String;
Begin
        DLL_Result_String:='ERR';
        FileName:=GetEnv('ETC')+'\TCPEXP.LST';
        ShowExpList:=TStringList.Create;
        IF doShowExp(aIPAdress) Then
        Begin
                // die ersten 3 Eintrge l”schen
                ShowExpList.delete(0);
                ShowExpList.delete(0);
                ShowExpList.delete(0);
                ShowExpList.Delete(0);
                Assign(EXPFIle,filename);
                {$I-}
                Rewrite(EXPFile);IOError:=IOResult;
                IF IOError<>0 Then Begin DLL_Result_String:=Int2Str(IOError);exit;End;
                For I:=0 to ShowExpList.Count-1 do
                Begin
                        writeln(ExpFile,showExpList[I]);
                End;
                Close(ExpFile);
                DLL_Result_String:='OK';
        End;
        ShowExpList.Destroy;
End;


Function GetFSInfo(aDrive:String;VAR FSName:String;VAR USerInfo:String):Boolean;
VAR
        szDeviceName : Array[0..7] of Char;  // Device name or drive letter string
        ulOrdinal    : LongInt;  // Ordinal of entry in name list
        pszFSDName   : PChar;  // pointer to FS name
        prgFSAData   : PChar;  // pointer to FS data
        rc           : LongInt; // Return code
        fsqBuffer    : Array[0..sizeof(FsqBuffer2) + (3 * cchMaxPath)] of Char;
        cbBuffer     : ULong;       // Buffer length)
        pfsqBuffer   : PFsqBuffer2;
        Drive:String;

BEgin
    Result:=FALSE;
    pszFSDName := nil;
    prgFSAData := nil;
    cbBuffer   := sizeof(fsqBuffer);
    pfsqBuffer := @fsqBuffer;
    FillChar(fsqBuffer, SizeOf(fsqBuffer), 0);
    StrPCopy(szDeviceName, aDrive);

    rc := DosQueryFSAttach(
      szDeviceName,    // Logical drive of attached FS
      ulOrdinal,       // ignored for fsail_QueryName
      fsail_QueryName, // Return data for a Drive or Device
      pfsqBuffer,      // returned data
      cbBuffer);       // returned data length

        // On successful return, the fsqBuffer structure contains
        // a set of information describing the specified attached
        // file system and the DataBufferLen variable contains
        // the size of information within the structure

    if rc <> No_Error then
    begin
      DLL_Result_String:=IntToStr(rc);exit;
    end
    else
    begin
      // The data for the last three fields in the FsqBuffer2
      // structure are stored at the offset of fsqBuffer.szName
      // Each data field following fsqBuffer.szName begins
      // immediately after the previous item.
      Result:=TRUE;
      DLL_Result_String:='0';
      pszFSDName := PChar(@pfsqBuffer^.szName[0]) + pfsqBuffer^.cbName + 1;
      prgFSAData := pszFSDName + pfsqBuffer^.cbFSDName + 1;

      {Writeln('iType     = ', pfsqBuffer^.iType);
      Writeln('szName    = ', PChar(@pfsqBuffer^.szName[0]));
      Writeln('szFSDName = ', pszFSDName);
      Writeln('rgFSAData = ', prgFSAData);}
      FSName:=strpas(pszFSDName);
      UserInfo:=StrPas(prgFSAData);
      end;
End;

Procedure Reset_RPCInfo_Rec;
Begin
        RPC_Info.MountSucessFull:=FALSE;
        RPC_Info.Daemon_Status:=FALSE;
        RPC_Info.Daemon_Nlock:=FALSE;
        RPC_Info.Daemon_PCNFSD:=FALSE;
        RPC_Info.Daemon_NFSD:=FALSE;
        RPC_Info.Error:=FALSE;
End;

Function GetRpcInfo(Value:byte):Boolean;
Begin
        case Value of
        Info_Lock   :    Result:=RPC_Info.Daemon_Nlock;
        Info_PCNFSD :    Result:=RPC_Info.Daemon_PCNFSD;
        Info_Mount  :    Result:=RPC_Info.MountSucessFull;
        Info_Status :    Result:=RPC_Info.Daemon_Status;
        Info_NFSD   :    Result:=RPC_Info.Daemon_NFSD;
        Info_Error  :    Result:=RPC_Info.Error;
        End;
End;

Function DllExecNFSProg(ExeName:String;Parameter:String;LogFileName:String):Boolean;
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  Test:Array[0..259] of char;
  PExeName:Array[0..259] of char;
  TextFile:Text;
  aText:String;
  IOError:Integer;
  TMP_Stri:String;

Begin
        {$I-}
        Result:=FALSE;DLL_Result_String:='OK';Reset_RPCInfo_Rec;

        Assign(TextFile,LogFileName); // Assign new File for output
        Rewrite(textfile);IOError:=IOResult;           // Create the File and store I/O error in IOError
        IF IOError<>0 Then Begin DLL_Result_String:='I/O Error (Rewrite) '+SysErrorMessage(IOError);exit;End;

  tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
  Begin
        StrPCopy(Test,Parameter);StrPCopy(PExeName,ExeName); // Convert PascalStrings into PChar
        { Execute the command to grab the output from }
        if not tr.Execute(ExeName,test, nil ) Then Begin Tr.Destroy;DLL_Result_String:=SysErrorMessage(2);exit;End;
          While not tr.Terminated do         // While command is executing
          If tr.MessageReady then          // Ask if a line is ready
          Begin
                        TMP_Stri:=Tr.Message;   // Copy Message into a string for later use

                        Writeln(TextFile,TMP_Stri);IOError:=IOResult;     // Write the string into a file
                        IF IOError<>0 Then Begin DLL_Result_String:='I/O Error (writelen) '+SysErrorMessage(IOError);Tr.Destroy;Exit;End;
                        IF FindWordinStri('pcnfsd',Tmp_Stri)<>-1   Then RPC_Info.Daemon_PCNFSD:=TRUE;
                        IF FindWordinStri('status',TMP_Stri) <>-1  Then RPC_Info.Daemon_Status:=TRUE;
                        IF FindWordinStri('nlockmgr',TMP_Stri)<>-1 Then RPC_Info.Daemon_Nlock:=TRUE;
                        IF FindWordinStri('tcp',TMP_Stri)<>-1 Then RPC_Info.Daemon_NFSD:=TRUE;
                        IF FIndWordInStri('RPC_SYSTEM_ERROR',TMP_Stri)<>-1 Then Begin RPC_Info.Error:=TRUE;DLL_Result_String:=Tmp_Stri;End;
          End
                else DosSleep( 30 );                // - otherwise wait a little

        tr.Destroy;                            // Execute ready, free the instance
        Result:=True;CLose(TextFile);          // Successfuly executed program, close logfile
        Exit;                                  // Exit the Function
  End
         else
                Begin
                        TR.Destroy;Close(TextFile);
                        DLL_Result_String:='Error creating TRedirExec, Error in TCPLIB.DLL Function "DLLExecNFSProg"';
                End;
{$I+}
End;


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Interface & Routings Section                                         บ
 บ     Version 1 18.11.2005                                                 บ
 บ     Version 2 04.12.2006                                                 บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Procedure ClearRouteEntrys;
VAR Loop:Byte;
Begin
        For Loop:=0 to 100 do
        Begin
                Ini.EraseSection('Routing'+Int2Str(Loop));
        End;
End;

procedure QueryRoute;
Var
  tr1  : TRedirExec;
  index: Integer;
  x,y : Integer;
  O:String;
  Screen   : array [0..259] of Char;
  RoutingNumber:Integer;
  TYPE_String:String;
  Debug:String;

begin
  tr1 := TRedirExec.Create;                   // Create a TRedirExec instance
  RoutingNumber:=0;
  if Assigned( tr1 ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          O:='-r';
          StrPCopy(Screen,O);                  // Set up DosExecPgm parameters
          tr1.Execute(GetEnv('ETC')[1]+':\MPTN\BIN\NETSTAT.EXE', Screen, nil );
          While not tr1.Terminated do         // While command is executing
            If tr1.MessageReady then          // Ask if a line is ready
              Begin
                O:=Tr1.Message;
                IF FindWordInStri('UGSP',O)<>-1 Then
                Begin
                        Ini.WriteString('Routing'+Int2Str(RoutingNumber),'DESTINATION',GetIPAdressFromString(1,o));
                        Ini.WriteString('Routing'+Int2Str(RoutingNumber),'ROUTER',GetIpAdressFromString(24,o));
                        Debug:=GetStringValue(24,o);
                        ini.WriteString('Routing'+int2Str(RoutingNumber),'NETMASK',GetIPAdressFromString(47,o));
                        ini.WriteString('Routing'+int2Str(RoutingNumber),'HOPCOUNT',GetIPAdressFromString(65,o));
                        IF GetStringValue(1,o)='default' Then TYPE_STRING:='default' else TYPE_String:='net';
                        ini.writeString('Routing'+int2Str(RoutingNumber),'TYPE',Type_String);
                        Inc(RoutingNumber);
                End;
                IF FindWordInStri('UGHS',O)<>-1 Then
                begin
                        Ini.WriteString('Routing'+Int2Str(RoutingNumber),'DESTINATION',GetIPAdressFromString(1,o));
                        Ini.WriteString('Routing'+Int2Str(RoutingNumber),'ROUTER',GetIPAdressFromString(24,o));
                        ini.WriteString('Routing'+int2Str(RoutingNumber),'NETMASK',GetIPAdressFromString(47,o));
                        ini.WriteString('Routing'+int2Str(RoutingNumber),'HOPCOUNT',GetIPAdressFromString(65,o));
                        ini.writeString('Routing'+int2Str(RoutingNumber),'TYPE','host');
                        Inc(RoutingNumber);
                End;

        End
            else
              DosSleep( 30 );                // - otherwise wait a little
    finally
      tr1.Destroy;                            // Free the instance
    end
  else
    ErrorBox('Procedure QueryRoute: Error creating TRedirExec class instance' );
end;


procedure QueryNetStat_Interfaces(IFNumber:Byte);
Var
  tr1  : TRedirExec;
  index: Integer;
  x,y : Integer;
  O:String;
  Screen   : array [0..259] of Char;

begin
  tr1 := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr1 ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          O:='-n';
          StrPCopy(Screen,O);                  // Set up DosExecPgm parameters
          tr1.Execute(GetEnv('ETC')[1]+':\MPTN\BIN\NETSTAT.EXE', Screen, nil );
          While not tr1.Terminated do         // While command is executing
            If tr1.MessageReady then          // Ask if a line is ready
              Begin
                O:=Tr1.Message;
                IF FindWordInStri('Interface '+Int2Str(IFNumber),O)<>-1 Then
                Begin
                        O:=TR1.Message;
                        Index:=FindWordInStri('MTU',O);IF Index<>-1 Then
                        Begin
                                Ini.WriteString(IniSection+Int2Str(IFNumber),'MTU',GetStringValue(Index+1,O));
                                Break;
                        End;

                End;
            End
            else
              DosSleep( 30 );                // - otherwise wait a little
    finally
      tr1.Destroy;                            // Free the instance
    end
  else
    ErrorBox('Procedure QueryNetStat_Interfaces: Error creating TRedirExec class instance' );
end;

procedure QueryNetStat_Address(IFNumber:Byte);
Var
  tr1  : TRedirExec;
  index: Integer;
  x,y : Integer;
  O:String;
  Screen   : array [0..259] of Char;
  AddressNumber:Integer;
  Mask:String;

begin
  AddressNumber:=0;
  tr1 := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr1 ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          O:='-a';
          StrPCopy(Screen,O);                  // Set up DosExecPgm parameters
          tr1.Execute(GetEnv('ETC')[1]+':\MPTN\BIN\NETSTAT.EXE', Screen, nil );
          While not tr1.Terminated do         // While command is executing
            If tr1.MessageReady then          // Ask if a line is ready
              Begin
                O:=Tr1.Message;
                IF FindWordInStri('Interface '+Int2Str(IFNumber),O)<>-1 Then
                Begin
                        Index:=FindWordInStri('addr',O);IF Index<>-1 Then
                        Begin
                                Ini.WriteString(IniSection+Int2Str(IFNumber),'ADDRESS#'+int2str(addressNumber),GetStringValue(Index+1,O));
                        End;
                        Index:=FindWordInStri('mask',O);IF Index<>-1 Then
                        Begin
                                Mask:=GetStringValue(Index+1,O);
                                Ini.WriteString(IniSection+Int2Str(IFNumber),'NETMASK#'+int2str(addressNumber),DecodeNetMask(mask));
                        End;

                        Index:=FindWordInStri('broadcast',O);IF Index<>-1 Then
                        Begin
                                Ini.WriteString(IniSection+Int2Str(IFNumber),'BROADCAST#'+int2str(addressNumber),GetStringValue(Index+1,O));
                        End;
                        Inc(AddressNumber);

                End;
            End
            else
              DosSleep( 30 );                // - otherwise wait a little
    finally
      tr1.Destroy;                            // Free the instance
    end
  else
    ErrorBox('Procedure QueryLocalInterface: Error creating TRedirExec class instance' );
end;


procedure QueryIFConfig(LanNum:Byte;QueryOnlyRunning:Boolean);
Var
  tr  : TRedirExec;
  i   : Integer;
  x,y : Integer;
  s:String;
  Test   : array [0..500] of Char;
  Test1:String;


        Procedure QueryAttributes;
        Begin
                                {Bridge : TRUE interface has bridge ENABLED (Default) / FALSE interface does not have/use bridge attribute
                                 ARP    : TRUE interface has DISABLED ARP / FALSE interface has enabled ARP (Default)
                                 Snap   : TRUE interface has SNAP ENABLED  (Default) / FALSE interface has SNAP DISABLED
                                 802.3  : TRUE interface has 802.3 ENABLED / FALSE Interface has 802.3 DISABLED (Default)
                                }
                                // Find the interface
                                IF FIndWordInStri('UP',S)<>-1 Then  Ini.WriteBool(IniSection+Int2Str(LanNum),'UP',TRUE) else Ini.WriteBool(IniSection+Int2Str(LanNum),'UP',FALSE);

                                // find "bridge" attribute
                                IF FindWordInStri('BRIDGE',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'BRIDGE',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'BRIDGE',FALSE);

                                // find the "noarp" attribute
                                IF FindWordInStri('NOARP',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'ARP',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'ARP',FALSE);

                                // find the word "snap"
                                IF FindWordInStri('SNAP',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'SNAP',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'SNAP',FALSE);

                                // find the word "802_3"
                                IF FindWordInStri('802_3',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'802.3',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'802.3',FALSE);

                                // find the word "canonical"
                                IF FindWordInStri('CANONICAL',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'CANONICAL',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'CANONICAL',FALSE);

                                { find the word "NoTrailers" Anmerkung : Wird NOTRAILERS gefunden, ist der WERT FALSE da spter im Programm der Schalter auf "EIN" (TRAILERS) gesetzt werden kann.
                                  Default Value is "Trailers off" (NOTRAILERS)
                                  TRUE=TRAILSERS ON FALSE=TRAILERS OFF
                                }
                                IF FindWordInStri('NOTRAILERS',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'NOTRAILERS',FALSE) else ini.WriteBool(IniSection+Int2Str(LanNum),'NOTRAILERS',TRUE);

                                I:=FindWordInStri('METRIC',S);IF I<>-1 Then Ini.WriteString(IniSection+Int2Str(LanNum),'METRIC',GetStringValue(I+1,S) ) else Ini.WriteString(IniSection+Int2Str(LanNum),'METRIC','');

                                IF FindWordInStri('POINTTOPOINT',S)<>-1 then ini.WriteBool(IniSection+Int2Str(LanNum),'POINT2POINT',TRUE) else ini.WriteBool(IniSection+Int2Str(LanNum),'POINT2POINT',FALSE);

                                // Write the 2 flags wich are not visible to ifconfig but according to IBM's TCP/IP guide they are enabled defaultly

                                Ini.WriteBool(IniSection+Int2Str(LanNum),'ICMPRED',FALSE);
                                Ini.WriteBool(IniSection+Int2Str(LanNum),'ALLRS',FALSE);

                                Ini.WriteString( IniSection+Int2Str(LanNum),'NAME','LAN'+Int2Str(LanNum));
        End;


begin
  tr := TRedirExec.Create;                   // Create a TRedirExec instance
  if Assigned( tr ) then                     // If creation was ok...
    try                                      // Catch any errors
          { Execute the command to grab the output from }
          S:='LAN'+Int2Str(LanNum);
           //S:='LAN0 81.223.81.195 netmask 255.255.255.240 metric 1 mtu 1500 trailers -snap';
          StrPCopy(Test,S);                  // Set up DosExecPgm parameters
          tr.Execute(GetEnv('ETC')[1]+':\MPTN\BIN\IFConfig.Exe', test, nil );
          While not tr.Terminated do         // While command is executing
            If tr.MessageReady then          // Ask if a line is ready
              Begin
                S:=Tr.Message;
                IF QueryOnlyRunning Then
                Begin
                        I:=FIndWordInStri('RUNNING',S);IF I<>-1 Then QueryAttributes;
                End else
                Begin
                        QueryAttributes;
                End;

              End
            else
              DosSleep( 30 );                // - otherwise wait a little
    finally
      tr.Destroy;                            // Free the instance
    end
  else
    Writeln( 'Error creating TRedirExec class instance' );
end;


//var loop:Byte;






{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Query SETUP.CMD file for additional settings not found in ifconfig   บ
 บ                                                                          บ
 บ     Version 1 09.12.2006                                                 บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Procedure QuerySetupCMD;
VAR
        IFNAME:String;
        ICMPREED:Boolean; {TRUE means present (on [default] , FALSE means off (-icmpred)}
        ALLRS:Boolean;    {TRUE means present (on [default] , FALSE means off (-allrs)}
        ProgIni:TIniFiles;
        FilePath:String;
        FCMD:Text;
        SCMD:String;
        IOError:Integer;
        InterfaceName:String;
        Posi:Integer;
Begin

        //ProgIni:=TIniFiles.Create('F:\WDSibyl\OS\OS2\Output\NEW_TCPCONFIG\PROJECT1.INI');
        //Ini:=TOS2IniFile.Create;
        ProgIni:=TIniFiles.Create(GetDefaultIni);
        FilePath:=ProgIni.ReadString('Settings','MPTN_BIN_PATH','-1');
        IF FilePath='-1' Then Begin ErrorBox('Error : Section oder IDENT nicht in INI Datei gefunden !');Halt;End;
        ProgIni.Destroy;
        {$I-}
        Assign(FCMD,FilePath+'\SETUP.CMD');Reset(FCMD);IOError:=IOResult;
        IF IOError<>0 Then Begin ErrorBox('Unable to open SETUP.CMD'+#13+syserrormessage(IOError));Halt;End;
        While not eof(FCMD) do
        Begin
                Readln(FCMD,SCMD);IOError:=IOResult;IF IOError<>0 Then Begin ErrorBox('Error during reading SETUP.CMD');Halt;End;
                IF Copy(uppercase(SCMD),1,8)='IFCONFIG' Then
                Begin
                        InterfaceName:=GetStringValue(10,SCMD);
                        IF interfaceName<>'lo' Then
                        Begin
                                IF FIndWordInStri('-icmpred',SCMD)<>-1 Then
                                Begin
                                     Ini.WriteBool(IniSection+Interfacename[4],'ICMPREED',TRUE);
                                End;
                                IF FIndWordInStri('-allrs',SCMD)<>-1 Then
                                Begin
                                     Ini.WriteBool(IniSection+Interfacename[4],'ALLRS',TRUE);
                                End;

                        End;     // End of Local Interface

                End;    // End of IFCONFIG

                                IF FindWordInStri('ipgate on',SCMD)<>-1 Then
                                begin
                                        Ini.WriteBool(IniSection+Interfacename[4],'IPGATE',TRUE);
                                End;
                                IF FindWordInStri('ipgate off',SCMD)<>-1 Then
                                Begin
                                        Ini.WriteBool('TCPConfig','IPGATE',FALSE);
                                End;

                                IF FindWordInStri('dhcpstrt',SCMD)<>-1 Then
                                Begin
                                        // SCMD: 'dhcpstrt -i lan1'
                                        POSI:=FindWordInStri('-i',SCMD);IF Posi<>-1 Then
                                        Begin
                                                InterfaceName:=GetStringValue(Posi+1,SCMD);
                                                Ini.WriteBool(IniSection+InterfaceName[4],'DHCP',TRUE);
                                        End;
                                        // SCMD: 'dhcpstrt -i lan1 -d 50'
                                        POSI:=FindWordInStri('-d',SCMD);IF Posi<>-1 Then
                                        Begin
                                                InterfaceName:=GetStringValue(Posi+1,SCMD);
                                                Ini.WriteString(IniSection+InterfaceName[4],'DHCP-TIME',InterfaceName);
                                        End;

                                End;
        End; // end of while loop

        //Ini.Destroy;
        CLose(FCMD);
End;


 Procedure QueryInterfaceAndRoutings;
        VAR InterfaceCounter:Byte;
        Begin
                Ini:=TOS2IniFile.Create; // OPEN OS2 USER INI
                For InterfaceCounter:=0 to 7 do
                Begin
                Ini.EraseSection(IniSection+Int2Str(InterfaceCounter));
                QueryIFCOnfig(InterfaceCounter,TRUE);
                QueryNetStat_Interfaces(InterfaceCounter);            // Get the Name of the interfaces along with addional informations
                QueryNetStat_Address(InterfaceCounter);
                End;
                QuerySetupCMD;
                ClearRouteEntrys;
                QueryRoute;
                Ini.Destroy;
        End;

Procedure MBox;
VAR aMessy:String;
Begin
      {aMessy:='Test DLL MessageBox';
      WinMessageBox(HWND_DESKTOP,
      hwnd_Desktop,                // client-window handle
      @aMessy[1],                   // body of the message
      'ERROR in DLL appeared !',   // title of the message
      0,                         // message box id
      MB_ERROR OR MB_OK or MB_APPLMODAL );       // icon and button flags}
      ErrorBox(Paramstr(0));
End;

Function Terminate:Boolean;
Begin
        //IF not WinDestroyMsgQueue(mq);
        IF not Winterminate(ab) then PlaySound(1000,1000);
End;

exports
    // Specify which entry points to export
    DLLVersion Name 'DLLVersion',
    DllTest Name 'DLLTest',
    DLLExecutePrg Name 'DLLExecutePrg',
    GetProcessList Name 'GetProcessList',
    Execute_TCPStart Name 'Execute_TCPStart',
    Execute_TCPServer NAME 'Execute_TCPServer',
    teststri2 NAME 'teststri2',
    DllReturnString NAME 'DllReturnString',
    GetNFSExport NAME 'GetNFSExport',
    DoMount NAME 'DoMount',
    GetFSInfo Name 'GetFSInfo',
    DllExecNFSProg Name 'DllExecNFSProg',
    QueryInterfaceAndRoutings,
    MBox Name 'MBox',
    CryptUserPassword Name 'CryptUserPassword',
    GetRpcInfo Name 'GetRpcInfo',
    Terminate Name 'Terminate',
    QueryProcessList Name 'QueryProcessList';
Initialization
    //Ab := WinInitialize(0);
    //Mq :=WinCreateMsgQueue(Ab, 0);
End.
