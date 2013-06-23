Unit TCP_ProgramIni;

Interface
Procedure CheckProgramIniFile;
Implementation

USES FORMS,TCP_COnfigSysAdd,Sysutils,MyMessageBox,TCPUtilityUnit,Dialogs;

VAR ProgBootPath:String;

Function FindAnsiWordinStri(StringToFind:AnsiString;StringToSearch:AnsiString):integer;
{Version 1 15.12.2005 - Update von String auf ANSISTring

 Sucht nach dem vorkommen eines Strings innerhalb eines andern strings
 Gross und Kleinschreibung wird ignoriert (Kein unterscheid)
 RÅckgabe  Wert ist die Position an der das Wort im String "StringToFInd" (Suchstring) gefunden wurde.
 Wurde der Wert/String nicht gefunden, wird -1 ZurÅckgeliefert.
 }

VAR Found:Boolean;
          DebugStr:AnsiString;
          Loop:Longint;
          String1,String2:AnsiString;      
Begin
                //result:=-1;exit;
                Found:=FALSE;DebugStr:='';

          For Loop:=1 to length(StringToSearch) do
              Begin
                   DebugStr:=Copy(StringToSearch,loop,length(StringToFind));
                String1:=UpperCase(DebugStr);
                String2:=Uppercase(StringToFInd);
                IF String1=String2 Then        
                Begin
                                Found:=TRUE;Break;
                        End;
              End;
              IF Found Then Result:=Loop else Result:=-1;
      End;


Function GetPathFromConfigSys(PathName:String):String;
{ Version 1 15.11.2005
 Function search thru Config.SYS PATH entry, and returns entire path including drive
 Input = ':\IBMCOM'  Output = 'E:\IBMCOM'
}
VAR
   CfgSys:TConfigSysFile;
   Index:Longint;
   LineIndex:Longint;
   S:AnsiString;
Begin
     CfgSys:=TConfigSysFile.Create; // Open Config.sys file
     REPEAT
           Index:= CfgSys.FindEntry('SET PATH');IF Index<>-1 Then
     Begin
          S:=CFGSys.Cfg_Items.Items[INdex];
          LineIndex:=FindAnsiWordInStri(PathName,S);
          IF LineIndex<>-1 Then Begin Result:=Copy( S,LineINdex-1,length(PathName)+1 );CFGSys.Destroy;exit;End;
     End else
     Begin
        MyErrorBox('Unable to find the entry "'+PathName+#13+'" in your CONFIG.SYS file Correct the problem and restart the program');Halt;
     End;
    Until Index=-1;
    MyErrorBox('Your Config.sys does not contain a SET PATH command'+#13+' Correct the problem and restart the program');Halt;
    End;

              Procedure CheckProgramIniFile;
              // checks if the Application.ini file contains a section called "settings", if not the the default settings will be writtten into it.
              Begin
                IF Not FileExists(Application.ProgramIniFile.FileName) Then
                Begin
                     ShowMessage('Warning ! No Ini FIle !');Halt;
                End;

                ProgBootPath:=FileSplit(Paramstr(0),1);
                IF length(ProgBootPath)>3 Then ProgBootPath:=ProgBootPath+'\';
                IF Application.PrograminiFile.ReadString('Settings','MPTN_BIN_PATH','-1')='-1' Then Application.ProgramIniFIle.WriteString('Settings','MPTN_BIN_PATH',GetPathFromConfigSys(':\MPTN\BIN'));
                IF Application.ProgramIniFile.ReadString('Settings','BACKUP_PATH','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','BACKUP_PATH',ProgBootPath+'TCPBKP');
                IF Application.ProgramIniFile.ReadString('Settings','DOS_WIN31_RESOLV','-1')='-1' Then Application.ProgramIniFile.WriteBool('Settings','DOS_WIN31_Resolv',FALSE);
                IF Application.ProgramIniFile.ReadString('Settings','DOS_WIN_ETC_PATH','-1')='-1' Then Application.ProgramIniFIle.WriteString('Settings','DOS_WIN_ETC_PATH','');
                IF Application.ProgramIniFile.ReadString('Settings','NLS_FILENAME','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','NLS_FILENAME','TCP_GER.NLS');
                IF Application.ProgramIniFile.ReadString('Settings','CONFIG_LEVEL','-1')='-1' Then Application.ProgramIniFile.WriteInteger('Settings','CONFIG_LEVEL',0);
                IF Application.ProgramIniFile.ReadString('Settings','BACKUP_COUNTER','-1')='-1' Then Application.ProgramIniFile.WriteInteger('Settings','BACKUP_COUNTER',0);
                IF Application.ProgramIniFile.ReadString('Settings','PROFILE_COUNTER','-1')='-1' Then Application.ProgramIniFile.WriteInteger('Settings','PROFILE_COUNTER',0);
                IF Application.ProgramIniFile.ReadString('Settings','PROFILE_PATH','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','PROFILE_PATH',ProgBootPath+'PROFILE');
                IF Application.ProgramIniFile.ReadString('Settings','BACKUP_PATH','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','BACKUP_PATH',ProgBootPath+'BACKUPS');
                IF Application.ProgramIniFile.ReadString('Settings','SPLASH_SCREEN','-1')='-1' Then Application.ProgramIniFile.WriteBool('Settings','SPALSH_SCREEN',TRUE);
                IF Application.ProgramIniFile.ReadString('Settings','SPLASH_SCREEN_WAITTIME','-1')='-1' Then Application.ProgramIniFile.WriteInteger('Settings','SPLASH_SCREEN_WAITTIME',50);
                IF Application.ProgramIniFIle.ReadString('Settings','SPLASH_SCREEN_DELAYTIME','-1')='-1' Then Application.ProgramIniFile.WriteInteger('Settings','SPLASH_SCREEN_DELAYTIME',35);
                IF Application.ProgramIniFIle.ReadString('Settings','AUTOSTART','-1')='-1' Then Application.ProgramIniFile.WriteBool('Settings','AUTOSTART',TRUE);
                IF Application.ProgramIniFile.ReadString('Settings','IBMCOM_PATH','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','IBMCOM_PATH',GetPathfromConfigSys(':\IBMCOM'));
                IF Application.ProgramIniFile.ReadString('Settings','TCPIP_BIN_PATH','-1')='-1' Then Application.ProgramIniFile.WriteString('Settings','TCPIP_BIN_PATH',GetPathFromConfigSys(':\TCPIP\BIN'));
              End;

Initialization
End.
