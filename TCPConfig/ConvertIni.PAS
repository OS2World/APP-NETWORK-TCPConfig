{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Unit zum Konvertieren der INI eigenen INI Datei in das INI Format     บ
 บ                                                                          บ
 บ    von OS/2. Unit wird derzeit nicht ben”tigt.                           บ
 บ                                                                          บ
 บ    Unit erstellt am 10.10.2006                                           บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ConvertIni;

Interface
Procedure Convert_ProgramIni;
Implementation
USES TCP_VAR_Unit,TCPUtilityUnit,Dialogs,Sysutils,TCP_IniFIles,FOrms;

      Type
       TOldProgramSettings=record
        editBinText       :String;     {BIN Directory - usaly X:\MPTN\BIN}
        CheckBoxDosWin    :Boolean;    {TRUE: RESOLV File will be written to DOS PATH}
        EditDosWinETCText :String;     {Path to the ETC directory for DOS&WINOS/2}
        NLSFileName       :String;     {Name of Language File}
        ConfigLevel       :integer;    {Configuration Level 0-1 (0=BASIC  / 1=Advanced)}
        BackupPath        :String;     {Directory for Backup}
        BackupCounter     :Byte;       {counter for backup folder}
        ProfileCounter    :Byte;
        ProfilePath       :String;     {Directory for loading/storing profiles}
        cbActivateFixedAliasIP:Boolean; {TRUE : Use fixed ALIAS IP stored in "AliasIPStr" / FALSE do use }
        EditFixedAliasIP  :String;
        cbProgLogo        :Boolean;     {True Splash Screen will be displayed / False no Splash Screen}
        LogoWaitTime      :Byte;                                {Wait Time counter}
        LogoDelayTime     :Byte;
        Autostart         :Boolean;
        IBMCOMPath        :String;      {path to the IBMCOM directory}
        TCPIPBINPath      :String;      {path to the TCPIP\BIN directory}
        End;


VAR
   OldIni       :TOldProgramSettings;
   OLDIniFile   :File of TOldProgramSettings;
   Program_Boot_Path : String;

Procedure OpenOldProgIniFile;
LABEL START;

VAR IOError:Longint;

Begin
     Program_Boot_Path:=FileSplit(Paramstr(0),1)+'\';
     START:
     Assign(OldIniFile,Program_Boot_Path+'TCPCFG.INI');
     {$i-}
     Reset(OLDIniFile);IoError:=IoResult;
     IF IoError<>0 then
     Begin
          ErrorBox('Unable to open file for converting : "TCPCFG.INI"'+#13+SysErrorMessage(IoError));Halt;
     End;

     Read(OLDIniFile,OldIni);IOError:=IoResult;
     IF IoError<>0 Then Begin ErrorBox('Error trying reading datas from file  "TCPCFG.INI"'+#13+SysErrorMessage(IoError));Halt;End;
     Close(OLDIniFIle);IOError:=IoResult;
     IF IoError<>0 Then begin ErrorBox('Error by closing file TCPCFG.INI'+#13+SysErrorMessage(IoError));Halt;End;
     {$I+}
End;

Procedure WriteNewIni;
Begin
        Application.ProgramIniFIle.WriteString('Settings','MPTN_BIN_PATH',OldIni.EditBinText);
        Application.ProgramIniFile.WriteString('Settings','BACKUP_PATH',OldIni.BackupPath);
        Application.ProgramIniFile.WriteBool('Settings','DOS_WIN31_RESOLV',OLDIni.CHeckBoxDosWin);
        Application.ProgramIniFIle.WriteString('Settings','DOS_WIN_ETC_PATH',OldIni.EditDosWinETCText);
        Application.ProgramIniFile.WriteString('Settings','NLS_FILENAME',OldINI.NLSFileName);
        Application.ProgramIniFile.WriteInteger('Settings','CONFIG_LEVEL',OldINI.ConfigLevel);
        Application.ProgramIniFile.WriteInteger('Settings','BACKUP_COUNTER',OldIni.BackupCOunter);
        Application.ProgramIniFile.WriteInteger('Settings','PROFILE_COUNTER',OldIni.ProfileCOunter);
        Application.ProgramIniFile.WriteString('Settings','PROFILE_PATH',OldIni.ProfilePAth);
        Application.ProgramIniFile.WriteBool('Settings','SPLASH_SCREEN',OldINi.cbProgLogo);
        Application.ProgramIniFile.WriteInteger('Settings','SPLASH_SCREEN_WAITTIME',OLDIni.LogoWaitTime);
        Application.ProgramIniFile.WriteInteger('Settings','SPLASH_SCREEN_DELAYTIME',OLDIni.LogoDelayTime);
        Application.ProgramIniFile.WriteBool('Settings','AUTOSTART',OldIni.Autostart);
        Application.ProgramIniFile.WriteString('Settings','IBMCOM_PATH',OldIni.IBMComPath);
        Application.ProgramIniFile.WriteString('Settings','TCPIP_BIN_PATH',OldIni.TCPIPBinPath);
End;

Procedure Convert_ProgramINi;
begin
     IF FileExists(Program_Boot_Path+'TCPCFG.INI') Then
     Begin
          OpenOldProgIniFile;
          WriteNewIni;
     End;
End;

End.
