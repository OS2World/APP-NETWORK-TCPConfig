{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
 ∫                                                                          ∫
 ∫     TCP_Unit_Autostart                                                   ∫
 ∫                                                                          ∫
 ∫     Version 1 November-Dezmber 2005                                      ∫
 ∫                                                                          ∫
 ∫Zulest geÑndert 25.09.2006                                                ∫
 »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}

Unit TCP_Autostart;
INTERFACE
USES CRT,SysUtils,Classes,TCP_VAR_Unit,DebugUnit,MyMessageBox,DOS,TCP_LanguageUnit,ustring,TCPUtilityUnit,Forms;



 Type
                TAutoStart=Object
                PRIVATE
                IOError:Longint;
                ServerList:TStringlist;
                FFileName:String;
                FFileMode:Byte;
                CMDFile:Text;
                CmdFileLine:String;
                InetDFile:Text;
                InetDLine:String;
                Procedure IOErrorProc(FileMode:Byte);
                Function ReadFile:Boolean;
                Procedure CreateServerList;
                Procedure FileModeRead;
                Procedure WriteDefaultEntrys;
                Procedure FileModeWrite;
                Procedure WriteFile(StringToWrite:String);
                Procedure QueryInetDList;
                Procedure GetInetD;
                Public
                Procedure Create(PathToAutostartCMDFile:String;FileMode:Byte);
                Function  RecIndex(EntryName:String):Longint;
                Function  HasChanged:Boolean;
                Procedure ResetCHanged;
                End;

CONST           OPEN_MODE=0;
                Create_Mode=1;

VAR             AutoStart:TAutoStart;
IMPLEMENTATION


CONST
      Read_Mode=2;
      WRITE_MODE=3;
      FString='START';          // Vordergrund String --> START INETD
      BString='DETACH';         // Hintergrund String --> DETACH INETD
      IString='START /MIN';     // Symbolgrî·e        --> START /MIN INETD
      RString='REM';            // REM String         --> REM START INETD





        Procedure TAutoStart.WriteDefaultEntrys;
        Begin
                {$I-}Writeln(CMDFile,'@echo off');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,' ');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'echo CONFIGURING TCP/IP .....');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,' ');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'IF EXIST '+Application.ProgramIniFile.ReadString('Settings','TCP_BIN_PATH','')+'\B4TCP.CMD CALL '+Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','')+'\B4TCP.CMD' );
                IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'echo ..... FINISHED CONFIGURING TCP/IP');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,' ');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'echo Make current connection LAN only');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'IF EXIST '+Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','')+'\TOGGLE.EXE CALL '+Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','')+'\TOGGLE.EXE');
                {$I-}Writeln(CMDFile,'IF ERRORLEVEL 1 GOTO :DONESERVERS');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,' ');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'echo STARTING THE TCP/IP PROCESSES .....');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                IF DynDNS Then
                Begin
                {$I-}Writeln(CMDFile,'start /min ddnsaps.cmd');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'start /min dhcpscps.cmd');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                {$I-}Writeln(CMDFile,'start /min binlscps.cmd');IOError:=IOResult;{$I+}IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Halt;End;
                End;

        End;

        Procedure TAutostart.IOErrorProc;
        VAR Output:String;
        Begin
                Case FFileMode of
                Open_Mode:Output:=GetNlsString('Errors','FileOpen');
                Create_Mode:Output:=GetNlsString('Errors','FileCreate');
                Write_Mode:Output:=GetNlsString('Errors','FileWrite');
                Read_Mode:Output:=GetNlsString('Errors','FileRead');
                End;
                MyErrorBox(Output+FFileName+#13+SysErrorMessage(IOError));
                Halt;
        End;


        Procedure TAutoStart.WriteFile(StringToWrite:String);
        Begin
                {$I-}Writeln(CMDFile,StringToWrite);IOError:=IOResult;{$I+}
                IF IOError<>0 Then Begin IOErrorProc(Write_Mode);Close(CmdFile);Halt;End;
        End;

        Function TAutoStart.ReadFile:Boolean;
        VAr aLoop:Byte;
            FindStr:String;
            SourceStr:String;

        Begin
                Result:=TRUE;
                {$I-}
                        Readln(CMDFile,CMDFileLine);IOError:=IOResult;IF IOError<>0 Then Begin IOErrorProc(Read_Mode);Exit;End;
                {$I+}

                // Schleife fÅr alle Dienste

                IF FindWordInStri('start /min ddnsaps.cmd',CMDFileLine)<>-1 Then
                Begin
                     DynDNS:=True;
                End;

                For aLoop:=0 TO ServerList.Count-1 do
                begin
                        {Foreground}
                        FIndStr:=FString+' '+ServerList[aLoop];SourceStr:=UpperCase(CMDFileLine);
                        AutoStartRec[aLoop].ServName:=ServerList[aLoop];
                        IF FindStr=Copy( SourceStr,1,length(FindStr) ) Then
                        Begin
                                AutoStartRec[aLoop].ServName:=ServerList[aLoop];
                                AutoStartRec[aLoop].Enabled:=True;
                                AutoStartRec[aLoop].ForeGround:=True;
                                AutoStartRec[aLoop].Parameter:=Copy(CMDFileLine,Length(FindStr)+2,length(CMDFileLine));
                        End;

                        {Background ?}
                        FindStr:=BString+' '+ServerList[aLoop];SourceStr:=UpperCase(CMDFileLine);
                        IF FindStr=Copy( SourceStr,1,length(FindStr) ) Then
                        Begin
                                AutoStartRec[aLoop].ServName:=ServerList[aLoop];
                                AutoStartRec[aLoop].Enabled:=True;
                                AutoStartRec[aLoop].BackGround:=True;
                                AutoStartRec[aLoop].Parameter:=Copy(CmdFileLine,Length(FindStr)+2,length(CMDFileLine));
                        End;

                        {Icon Size ?}
                        FindStr:=IString+' '+ServerList[aLoop];SourceStr:=UpperCase(CMDFileLine);
                        IF FindStr=Copy( SourceStr,1,length(FindStr) ) Then
                        Begin
                                AutoStartRec[aLoop].ServName:=ServerList[aLoop];
                                AutoStartRec[aLoop].Enabled:=True;
                                AutoStartRec[aLoop].Symbol:=True;
                                AutoStartRec[aLoop].Parameter:=Copy(CMDFileLine,Length(FindStr)+2,length(CMDFileLine));

                        End;

                        {REM ?}
                        FindStr:=RString+' '+uppercase('START')+' '+ServerList[aLoop];SourceStr:=UpperCase(CMDFileLine);
                        IF FindStr=Copy( SourceStr,1,length(FindStr) ) Then
                        Begin
                                AutoStartRec[aLoop].ServName:=ServerList[aLoop];
                                AutoStartRec[aLoop].Enabled:=FALSE;
                                AutoStartRec[aLoop].Symbol:=FALSE;
                                AutoStartRec[aLoop].ForeGround:=True;
                                AutoStartRec[aLoop].Background:=FALSE;
                                AutoStartRec[aLoop].Parameter:=Copy(SourceStr,Length(FindStr)+2,length(SourceStr));

                        End;
                End;
        End;


        Procedure TAutoStart.CreateServerList;
        VAR Loop:Byte;
        Begin
                ServerList:=TStringlist.Create;
                ServerList.add(Uppercase('INETD'));
                ServerList.add(Uppercase('TelnetD'));
                ServerList.add(Uppercase('FTPD'));
                ServerList.add(Uppercase('TFTPD'));
                ServerList.add(Uppercase('rexecd'));
                ServerList.add(Uppercase('RSHD'));
                ServerList.add(Uppercase('LPD'));
                ServerList.Add(UpperCase('lprportD'));
                ServerList.add(Uppercase('routed'));
                ServerList.add(Uppercase('talkd'));
                ServerList.add(Uppercase('portmap'));
                ServerList.add(Uppercase('sendmail'));
                ServerList.add(Uppercase('rsvpd'));
                ServerList.add(Uppercase('syslogd'));
                ServerList.add(Uppercase('timed'));
                ServerList.add(Uppercase('nfsd'));
                ServerList.add(Uppercase('pcnfsd'));
                AutoStartRec[0].Amount:=ServerList.Count;
                // Clear the record first
                FOr Loop:=0 to ServerList.Count-1 do
                Begin
                        AutoStartRec[Loop].Enabled:=FALSE;
                        AutoStartRec[Loop].ServName:='';
                        AutoStartRec[Loop].Background:=FALSE;
                        AutoStartRec[Loop].ForeGround:=FALSE;
                        AutoStartRec[Loop].Symbol:=FALSE;
                        AutoStartRec[Loop].Changed:=FALSE;
                        AutoStartRec[Loop].Parameter:='';
                        AutoStartRec[loop].InetD:=FALSE;
                        AutoStartRec[Loop].InetDProtName:='';
                End;

        End;



        Procedure TAutostart.FileModeRead;
        Begin
                While not EOF(CMDFile) do
                Begin
                        IF not ReadFile then Begin Close(CMDFIle);Exit;End;
                End;
        End;

        Procedure TAutostart.FileModeWrite;
        VAR
                WLoop:Byte;S:String;
        Begin
                WriteDefaultEntrys;
                IF AutoStartRec[0].Amount=0 Then Begin Raise Exception.Create('BUG ! UNIT TCP_Autostart Function TAutostart.FileModeWrite : Anzahl Server Dienste ist 0 !');Halt;End;
                For WLoop:=0 To AutoStartRec[0].Amount-1 do
                Begin
                        IF AutoStartRec[Wloop].Enabled Then
                        Begin
                                IF AutoStartRec[wLoop].Foreground Then WriteFile( LowerCase(FString)+' '+AutoStartRec[wLoop].ServName+' '+AutoStartRec[wLoop].Parameter);
                                IF AutoStartRec[wLoop].Background Then WriteFile( LowerCase(BString)+' '+AutoStartRec[wLoop].ServName+' '+AutoStartRec[wLoop].Parameter);
                                IF AutoStartRec[wLoop].Symbol Then WriteFile( LowerCase(IString)+' '+AutoStartRec[wLoop].ServName+' '+AutoStartRec[wLoop].Parameter);
                                WriteFile('REM echo     .....'+AutostartRec[wloop].ServName+' DAEMON STARTED');
                        End;

                        IF not AutoStartRec[Wloop].Enabled Then
                        Begin
                                WriteFile(RString+' start '+AutoStartRec[wLoop].ServName+' '+AutoStartRec[wLoop].Parameter);
                                WriteFile('REM echo     .....'+AutostartRec[wloop].ServName+' DAEMON STARTED');
                        End;
                End;
                WriteFile('echo ..... FINISHED STARTING THE TCP/IP PROCESSES');
                WriteFile(' ');
                WriteFile(':DONESERVERS');
                WriteFile('IF EXIST '+Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','')+'\TCPEXIT.CMD CALL '+Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','')+'\TCPEXIT.CMD');
                WriteFile('echo .....  EXITING TCPSTART.CMD  .....');
        End;




        Function TAutostart.RecIndex(EntryName:String):Longint;
        Var Loop:Byte;
        Begin
                IF AutoStartRec[0].Amount=0 Then Begin Raise Exception.Create('BUG ! Anzahl Server Dienste ist 0 ! Fehler in Unit TCP_Autostart,Function TAutostartRecIndex');exit;End;
                For Loop:=0 to AutoStartRec[0].Amount-1 do
                Begin
                        IF EntryName=AutoStartRec[Loop].ServName Then Begin Result:=Loop;exit;End;
                End;
                Raise Exception.Create('BUG ! Server Name wurde nicht im Autostart REC gefunden Fehler in Unit: TCP_Autostart , Function TAutostart.RecIndex'+#13+'Nicht gefunden : '+AutoStartRec[loop].ServName);
                Halt;
        End;

        Procedure TAutoStart.QueryINETDList;
        Begin
                        IF Copy(uppercase(InetDLine),1,6)='TELNET' Then
                        Begin                           //1
                                AutostartRec[RecIndex('TELNETD')].InetD:=True;AutoStartRec[RecIndex('TELNETD')].InetDProtName:='tcp';
                        End;
        
                        IF COpy(uppercase(InetDLine),1,4)='EXEC' Then 
                        Begin                           //4
                                AutostartRec[RecIndex('REXECD')].InetD:=True;AutoStartRec[RecIndex('REXECD')].InetDProtName:='tcp';
                        End;
                        
                        IF COpy(uppercase(InetDLine),1,5)='SHELL' Then 
                        Begin
                             AutostartRec[RecIndex('RSHD')].InetD:=True;AutoStartRec[RecIndex('RSHD')].InetDProtName:='tcp';
                        End;
                        
                        IF COpy(uppercase(InetDLine),1,7)='PRINTER' Then 
                        Begin
                                                      //6
                                AutostartRec[RecIndex('LPD')].InetD:=True;AutoStartRec[RecIndex('LPD')].InetDProtName:='tcp';
                        End;

                        IF COpy(uppercase(InetDLine),1,4)='TIME' Then
                        Begin
                                                       //14
                                AutostartRec[RECIndex('TIMED')].InetD:=True;AutoStartRec[RECIndex('TIMED')].InetDProtName:='udp';
                        End;

                        
                        
                
        End;


        Procedure TAutoStart.GetInetD;
        Begin
                IF not FileExists(GetEnv('ETC')+'\INETD.LST') then exit;FFIleName:='INETD.LST';
                Assign(InetDFile,GetEnv('ETC')+'\INETD.LST');{$I-}ReSet(InetDFile);IOError:=IOResult;{$i+}IF IOError<>0 Then Begin IOErrorProc(Read_Mode);Halt;End;
                
                While not eof(InetDFile) do 
                Begin
                        {$I-} Readln(InetDFile,InetDLine);IOError:=IOResult;{$I+} IF IOError<>0 Then Begin IOErrorProc(Read_Mode);Halt;End;
                        QueryInetDList;
                End;
                Close(InetDFile);
        End;


        Procedure TAutoStart.Create(PathToAutostartCMDFile:String;FileMode:Byte);
        Label Start;
        Begin

                Assign(CMDFile,PathToAutostartCMDFIle);

                FFileName:=PathToAutostartCMDFile;
                FFileMode:=FileMode;

                IF FileMode=Open_Mode Then
                Begin
                        CreateServerList;
                  START:
                        {$I-}
                        ReSet(CMDFile);IOError:=IOResult;
                        IF FileSize(CMDFIle)=0 Then
                                                   Begin // Re-Write the file if it has 0 Bytes
                                                        FileModeWrite;Close(CMDFile);
                                                        Goto Start;
                                                   End;
                        IF IOError=2 Then // File not found ?
                                         Begin // Re-Create Mode
                                              {$I-} ReWrite(CMDFile);{$I+}IOError:=IoResult;IF IOError<>0 Then Begin IOErrorProc(Create_Mode);Halt;End;
                                              FileModeWrite;CLose(CMDFile);
                                              Goto Start;
                                         End;
                        IF IOError<>0 Then IOErrorProc(Open_Mode);
                        {$I+}

                        FileModeRead;
                        GetInetD;
                        ServerList.Destroy;
                End;

                IF FileMode=Create_Mode Then
                Begin
                        Rewrite(CMDFile);IOError:=IOResult;IF IOError<>0 Then Begin IOErrorProc(Create_Mode);Halt;End;
                        FileModeWrite;
                End;

                Close(CMDFIle);
        End;


Function TAutoStart.HasChanged:Boolean;
VAr COunter:Byte;
{Ermittelt ob ein Eintrag im  Autostart REC Feld geÑndert wurde
RÅckwert ist TRUE wenn sich ein einzelner Eintrag im Record geÑndert hat
RÅckwert ist FALSE wenn sich KEIN einziger Eintrag geÑndert hat
}


Begin
     IF AutoStartRec[0].Amount=0 Then Exception.Create('Fehler in Unit TCP_Autostart.PAS ! Function : HasChanged , AutoStartRec[0].Amount=0 !');
     FOr Counter:=0 to AutoStartRec[0].Amount-1 do
     Begin
          IF AutoStartRec[Counter].changed Then Begin Result:=True;exit;End;
     End;
     Result:=FALSE;
End;

Procedure TAutoStart.ResetChanged;
VAR Counter:Byte;
{
 Setzt die Variable ".Changed" immer auf den Wert "FALSE"

 }
Begin
    IF AutoStartRec[0].Amount=0 Then Exception.Create('Fehler in Unit TCP_Autostart.PAS ! Function : RestChanged , AutoStartRec[0].Amount=0 !');
     FOr Counter:=0 to AutoStartRec[0].Amount-1 do
     Begin
          AutoStartRec[Counter].changed:=FALSE;
     End;
End;






{
25.09.2006 - Function ReadFile : Abfrage auf "start /min ddnsaps.cmd" (DynDNS UnterstÅzung)
             Wird diese Zeile in der TCPStart.CMD gefunden, wird DynDNS Variable auf TRUE gesetzt

}
End.
