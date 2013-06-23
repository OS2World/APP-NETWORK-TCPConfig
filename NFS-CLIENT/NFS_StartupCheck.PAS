Unit NFS_StartupCheck;

Interface
Procedure NFSDefaultProgramCHeck;
Implementation
USES NFS_ConfigSYS,NFS_UtiltyUnit,NFS_LanguageUnit,Dialogs,NFS_VAR_Unit,MyMessageBox,SysUtils,NFS_MountErrorUnit;

IMPORTS
Function DllExecNFSProg(ExeName:String;Parameter:String;LogFileName:String):Boolean; 'TCPLIB' NAME 'DllExecNFSProg';
End;

VAR
   RC:Longint;
    S:String;
    SystemOpenDialog:TOpenDialog;


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
   Index:Longint;
   LineIndex:Longint;
   S:AnsiString;
Begin

     REPEAT
           Index:= ConfigSysFile.FindEntry('SET PATH');IF Index<>-1 Then
     Begin
          S:=ConfigSysFile.Cfg_Items.Items[INdex];
          LineIndex:=FindAnsiWordInStri(PathName,S);
          IF LineIndex<>-1 Then Begin Result:=Copy( S,LineINdex-1,length(PathName)+1 );exit;End;
     End else
     Begin
        MyErrorBox('Unable to find the entry "'+PathName+#13+'" in your CONFIG.SYS file Correct the problem and restart the program');Halt;
     End;
    Until Index=-1;
    MyErrorBox('Your Config.sys does not contain a SET PATH command'+#13+' Correct the problem and restart the program');Halt;
    End;


Procedure NFSDefaultProgramCheck;
VAR S:String;
Begin
     ConfigSysFile:=TConfigSysFile.Create; // Open Config.sys file
     PathRec.MPTNBIN:=GetPathFromConfigSys(':\TCPIP\BIN');
     ConfigSysFile.Destroy;  // Close file

     ConfigSysFile.Create; // Open again (reset search Variables)

     IF Not FIleExistInPath(PathRec.MountExe) Then Begin NLSErrorBox('MissMount');Halt;ENd;
     IF NOT FileExistInPath(PathRec.UMountExe) Then Begin NLSErrorBox('MissUMount');Halt;End;
     IF NOT FileExistInPath(PathRec.RPCInfo) Then Begin NLSErrorBox('MissRPCInfo');Halt;End;
      // öberprÅfen ob NFS300.IFS in CONFIG.SYS vorhanden ist
      RC:=ConfigSysFile.FindEntry('NFS300.IFS');
      IF RC<>-1 Then IF copy(ConfigSysFile.CFG_Items.items[RC],1,3)='REM' Then
      Begin
           IF not NLSDialog('DLG_NFS_MISSING') Then Halt else
           Begin
                S:=Copy(ConfigSysFile.CFG_Items.items[RC],5,Length(ConfigSysFile.CFG_Items.items[RC]));
                ConfigSysFile.ReplaceLine(RC,S);ConfigSysFile.SaveFile;
                NLSInfoBox('Reboot');
                Halt;
           End;
      End;
      IF RC=-1 Then
      Begin
           IF NLSDialog('DLG_ADDNFS') Then
           Begin
               IF not FileExistInPath(PathRec.NFS300IFS) Then
               Begin
                    NLSInfoBox('MissNFS300');
                    SystemOpenDialog.Create(NIL);
                    SystemOpenDialog.Title:='Position von NFS300.IFS angeben :';
                    SystemOpenDialog.FIleName:='NFS300.IFS';
                    SystemOpenDialog.Filter:='Installable File System|NFS300.IFS';
                    IF SystemOpenDialog.Execute Then
                    Begin
                       //  ShowMessage(PathRec.MPTNBin+'\NFS300.IFS');
                         IF not FileCopy(SystemOpenDialog.Filename,PathRec.MPTNBin+'\NFS300.IFS') Then halt;

                         ConfigSysFile.AddLine('IFS='+PathRec.MPTNBIN+'\NFS300.IFS');
                         IF not ConfigSysFile.SaveFile then Halt; // Schwerer Fehler !!!
                         ConfigSysFile.Destroy;
                         NLSInfoBox('Reboot');
                         Halt;
                    End else Halt;
               End;
               ConfigSysFile.AddLine('IFS='+PathRec.NFS300IFS);
               IF ConfigSysFile.SaveFile Then Begin ConfigSysFile.Destroy;NLSInfoBox('NFS_Found');Halt;End
                                         else Halt;
           End else Halt;
      End;
      ConfigSysFile.Destroy;
      // PrÅfen ob IFS installiert und bereits geladen ist
      IF not DLLExecNFSProg('MOUNT.EXE','','DUMP.$$$') Then MyErrorBox('Fehler bei MOUNT.EXE');
      FormMountError.Create(NIL);
      FormMountError.Label1.Caption:=GetNLSString('FormMountError','LabelMountError');
      FormMountError.Memo1.lines.loadFromFIle('DUMP.$$$');
      DeleteFile('DUMP.$$$');
      IF FindInStringList('NFSU1102',FormMountError.Memo1.Lines)<>-1 Then Begin FormMountError.DisplayModal;Halt;End;
      FormMountError.Memo1.Clear;
      // OK Programm kann starten
End;

Initialization
End.
