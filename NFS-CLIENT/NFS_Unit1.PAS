Unit NFS_Unit1;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, Buttons, StdCtrls, ExtCtrls, ComCtrls,Dialogs,DOS,Sysutils,
  ListView,NFS_AdressBookV2,Messages, BmpList, Menus,NFS_Editor,NFS_IniFIles,NFS_AboutUnit,
  INet,MyPMHelp,Unit2;

Type
  TForm1 = Class (TForm)
    NoteBook1: TNoteBook;
    ButtonTraceLog: TButton;
    PrevButton: TBitBtn;
    NextButton: TBitBtn;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemDebug:TMenuItem;
    MenuTrace: TMenuItem;
    MenuSettings: TMenuItem;
    MenuItemAbout: TMenuItem;
    TCP1: TTCP;
    FTP1: TFTP;
    FTP2: TFTP;
    CheckBox1: TCheckBox;
    GroupBox3: TGroupBox;
    HeaderControl1: THeaderControl;
    BitmapListBoxUMount: TBitmapListBox;
    Image5: TImage;
    BMPDriveListBox: TBitmapListBox;
    HeaderControlDrive: THeaderControl;
    BitmapListBox1: TBitmapListBox;
    ButtonNew1: TButton;
    ButtonEdit1: TButton;
    ButtonDelete1: TButton;
    ServerListBox: tMultiColumnList;
    Image4: TImage;
    GroupBox18: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    ButtonInstallNFS: TButton;
    Label33: TLabel;
    RadioNFSOptions: TRadioButton;
    ButtonRPCInfo: TButton;
    Label11: TLabel;
    LabelDummy: TLabel;
    Image3: TImage;
    GroupBoxDummy5: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    ButtonMountLog: TButton;
    ButtonUmountLog: TButton;
    Image2: TImage;
    GroupBoxDummy4: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label10: TLabel;
    LabelServer: TLabel;
    GroupBoxDummy3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox8: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    GroupBox: TGroupBox;
    Label16: TLabel;
    LabelServerIP: TLabel;
    Label17: TLabel;
    LabelDrive: TLabel;
    Label18: TLabel;
    LabelAlias: TLabel;
    Label19: TLabel;
    LabelServerTyp: TLabel;
    GroupBoxDummy8: TGroupBox;
    GroupBoxDummy7: TGroupBox;
    LabelDummy2: TLabel;
    GroupBox1: TGroupBox;
    RadioButtonMount: TRadioButton;
    RadioButtonUnmount: TRadioButton;
    GroupBox2: TGroupBox;
    LabelAliasResourceName: TLabel;
    GroupBoxDummy6: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    ButtonUnMountAll: TButton;
    GroupBox9: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBoxDummy1: TGroupBox;
    Image1: TImage;
    GroupBoxDummy2: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Procedure ButtonDelete1OnClick (Sender: TObject);
    Procedure BitmapListBoxUMountOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure MenuItemDebugOnClick (Sender: TObject);
    Procedure ButtonTraceLogOnClick (Sender: TObject);
    Procedure FTP2OnError (Sender: TObject; Err: TFTPError;
      Const Description: String);
    Procedure TCP1OnError (Sender: TObject; ErrNumber: LongInt;
      Const Description: String);
    Procedure MenuItemAboutOnClick (Sender: TObject);
    Procedure MenuSettingsOnClick (Sender: TObject);
    Procedure DriveListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure BitmapListBox1OnItemFocus (Sender: TObject; Index: LongInt);
    Procedure ServerListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure ButtonUnMountAllOnClick (Sender: TObject);
    Procedure ButtonMountLogOnClick (Sender: TObject);
    Procedure Button3OnClick (Sender: TObject);
    Procedure ButtontestOnClick (Sender: TObject);
    Procedure PrevButtonOnClick (Sender: TObject);
    Procedure ButtonRPCInfoOnClick (Sender: TObject);
    Procedure ListBox4OnClick (Sender: TObject);
    Procedure ListBox3OnItemFocus (Sender: TObject; Index: LongInt);
    Procedure Form1OnDestroy (Sender: TObject);
    Procedure ButtonUmountLogOnClick (Sender: TObject);
    Procedure Button5OnClick (Sender: TObject);
    Procedure ButtonEditOnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
    Procedure Button2OnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure Form1OnSetupShow (Sender: TObject);
    Procedure ButtonNewOnClick (Sender: TObject);
    Procedure NextButtonOnClick (Sender: TObject);
    Procedure MakeBMPDriveList;
    Procedure ShowBitmapListboxUmount;
  Private
    {Private Deklarationen hier einfÅgen}
  Procedure GetExportList;
  Procedure GetAdressBook;
  Procedure LanguageSettings;
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

CONST
     Mode_Mount=0;
     Mode_RPCInfo=1;
Var
  Form1: TForm1;
  ListFile:Text;
  List:String;
  ReadyButtonCaption:String;

IMPORTS
Function DLLVersion:Integer; 'TCPLIB' NAME 'DLLVersion';
Function DLLResultStr:String; 'TCPLIB' NAME 'DllReturnString';
Procedure GetNFSExport(aIPAdress:String); 'TCPLIB' NAME 'GetNFSExport';
Function DoMount(Exename:String;Param:String):Boolean; 'TCPLIB' NAME 'DoMount';
Function GetFSInfo(aDrive:String;VAR FSName:String;VAR USerInfo:String):Boolean; 'TCPLIB' NAME 'GetFSInfo';
Function DllExecNFSProg(ExeName:String;Parameter:String;LogFileName:String):Boolean; 'TCPLIB' NAME 'DllExecNFSProg';
Function GetRpcInfoDLL(Value:byte):Boolean; 'TCPLIB' NAME 'GetRpcInfo';
Function DLLExecutePrg(aString,aString2:STring):Longint;'TCPLIB' NAME 'DLLExecutePrg';


End;
Implementation
USES NFS_AdressWizard,NFS_UtiltyUnit,NFS_LanguageUnit,NFS_VAr_Unit,NFS_DebugUnit,NFS_NLS_IniFileUnit,NFS_ToolBox,MyMessageBox,NFS_STDIOError,NFS_LogViewUnit,
NFS_CheckFilesystemUnit,NFS_MountInfoDlg,NFS_StartupCheck,NFS_OptionsUnit,NFS_MountErrorUnit,ProgramOptions,nfs_hostlist;
{$R NFSResource}

VAR
   NFSFile:DataFile;
   Drives:Longint;
   Icon1:TIcon; // FolderOpen
   Icon2:TIcon; // NEtDrive
   Icon3:TIcon; // NETWork


Procedure TForm1.ButtonDelete1OnClick (Sender: TObject);
VAR Index:Longint;
Begin
     IF copy(ServerListBox.Items[ServerListBox.ItemIndex],1,5)='<DEL>' Then exit;
     IF NLSDialog('DLG_DELETE') Then
     Begin
          AdressBookFileName:='NFSBOOK.DAT';
          OpenFile(NfsFile,AdressBookFileName,Data_Size);
          Index:=ServerListBox.ItemIndex+1;
          //ShowMessage(ToStr(Index));
          //DeleteRec(NFSFile,ServerListBox.ItemIndex+1);
          DeleteRec(NFSFIle,Index);
          CloseFile(NFSFile);
          //OpenFile(NFSFile,AdressBookFileName,data_size);
          GetAdressBook;
     End;
End;

Procedure TForm1.BitmapListBoxUMountOnItemFocus (Sender: TObject;
  Index: LongInt);
Begin
     NextButton.Enabled:=True;
End;

Procedure TForm1.ShowBitmapListBoxUMount;
VAR
   Count:Byte;

Begin
     BitmapListBoxUmount.Clear;
     IF NFSDRiveList.count=0 Then exit;
     For count:=0 to NFSDriveList.count-1 do
     Begin
          BitmapListBoxUMount.AddBitmap('     '+NFSDriveList[count]+'                '+'NFS'+'      '+NFSDriveList_Info[count],Icon2);

     End;
End;

Procedure TForm1.MenuItemDebugOnClick (Sender: TObject);
Begin
    DebugForm.ShowModal;
End;

Procedure TForm1.ButtonTraceLogOnClick (Sender: TObject);
Begin
     Form3.ShowModal;
End;

Procedure TForm1.FTP2OnError (Sender: TObject; Err: TFTPError;
  Const Description: String);
Begin
     MyInfoBox(Description);
End;

Procedure TForm1.TCP1OnError (Sender: TObject; ErrNumber: LongInt;
  Const Description: String);
Begin
    MyInfoBox(ToStr(ErrNumber)+#13+Description);
End;

Procedure TForm1.MenuItemAboutOnClick (Sender: TObject);
Begin
     AboutForm.ShowModal;
End;

Procedure TForm1.MenuSettingsOnClick (Sender: TObject);
Begin
     IF ProgramSettings.ShowModal=cmOK Then LanguageSettings;
End;

Procedure TForm1.MakeBMPDriveList;
VAR Count:Byte;
Begin
     For Count:=0 to FreeDriveList.count-1 do
     Begin
          BMPDriveListBox.AddBitmap('  <'+FreeDriveList[count]+'>                   '+GetNLSString('MainForm','NFSDrive'),Icon2);
          //DriveListBox.items:=FreeDriveList;
     End;
ENd;

Procedure TForm1.DriveListBoxOnItemFocus (Sender: TObject; Index: LongInt);
Begin
     NextButton.Enabled:=TRUE;
End;

Procedure TForm1.BitmapListBox1OnItemFocus (Sender: TObject; Index: LongInt);
Begin
    NextButton.Enabled:=TRUE;
End;

Procedure TForm1.ServerListBoxOnItemFocus (Sender: TObject; Index: LongInt);
Begin

   IF length(ServerListBox.Items[Index])=3 Then
   Begin
        NextButton.Enabled:=FALSE;
        ButtonDelete1.Enabled:=FALSE;
        ButtonEdit1.Enabled:=FALSE;

   End
   else
   Begin
        NextButton.Enabled:=TRUE;
        ButtonDelete1.Enabled:=TRUE;
        ButtonEdit1.Enabled:=True;
        ENd;
        
   //IF Index>0 Then ButtonDelete1.Enabled:=TRUE else ButtonDelete1.Enabled:=FALSE;

 IF copy(ServerListBox.Items[ServerListBox.ItemIndex],1,5)='<DEL>' Then
 BEgin
          ButtonDelete1.Enabled:=FALSE;
        ButtonEdit1.Enabled:=FALSE;
        NextButton.Enabled:=FALSE;
 End
 else
 Begin
        ButtonDelete1.Enabled:=TRUE;
        ButtonEdit1.Enabled:=TRUE;
        NextButton.Enabled:=TRUE;
 End;




End;

Procedure TForm1.ButtonUnMountAllOnClick (Sender: TObject);
VAR RC:Boolean;Dummy:String;
Begin
    FormMountInfo.Label1.Caption:=GetNLSString('Message','UMountInfoAll');
    FormMountInfo.Show;Dummy:=DLLResultStr;
    RC:=DLLExecNFSProg('umount.exe','*','umount.log');
    FormMountInfo.Close;
    IF not RC Then Begin MyErrorBox(Dummy);Notebook1.PageIndex:=1;Exit;End;

             FormActivateConfig.Create(Self);
             FormActivateConfig.showModal;
             FormActivateConfig.Destroy;
    IF NFSDriveList.count<>0 Then Begin Notebook1.PageIndex:=1;FormMountError.ShowModal(MODE_UnMount);Exit;End;
    Notebook1.PageIndex:=1;

End;

Procedure TForm1.ButtonMountLogOnClick (Sender: TObject);
Begin
  FormMountLogView.ShowModal(Output_Mount);
End;

Procedure TForm1.Button3OnClick (Sender: TObject);
Begin
//     Form2.ShowModal;
End;

Procedure TForm1.ButtontestOnClick (Sender: TObject);
Begin
     //ShowMessage(OptionString);
End;

Procedure TForm1.PrevButtonOnClick (Sender: TObject);
Begin
     Notebook1.PageIndex:=Notebook1.PageIndex-1;
End;

Procedure TForm1.ButtonRPCInfoOnClick (Sender: TObject);
Begin
     FormMountLogView.ShowModal(output_RpcInfo);
End;


Procedure TForm1.ListBox4OnClick (Sender: TObject);
Begin
     NextButton.Enabled:=TRUE;
End;

Procedure TForm1.ListBox3OnItemFocus (Sender: TObject; Index: LongInt);
Begin
   NextButton.Enabled:=True;
End;



Procedure TForm1.Form1OnDestroy (Sender: TObject);
Begin
     NFSDriveList.Destroy;
     FreeDriveList.Destroy;
     NFSDriveList_Info.Destroy;
     Output_RPCINFO.Destroy;
     Output_Mount.Destroy;
     Output_UMount.Destroy;
End;

Procedure TForm1.ButtonUmountLogOnClick (Sender: TObject);
Begin
     FormMountLogView.ShowModal(output_Umount);
End;

Procedure TForm1.Button5OnClick (Sender: TObject);
Begin
End;




Procedure TForm1.ButtonEditOnClick (Sender: TObject);
Begin
      {AdressWizard.AddMode:=FALSE;
      AdressWizard.UserIndex:=ListBox1.ItemIndex+1;
      AdressWizard.ShowModal;}
      AdressBookV2.Create(NIL);
      AdressBookV2.ShowModal(ABEditMode_Edit,ServerListBox.ItemIndex+1);
      AdressBookV2.Destroy;
      GetAdressBook;
      Form1.Focus;
End;


Procedure TForm1.Button1OnClick (Sender: TObject);
VAR IPAdresse:String;
Begin
    { IF Inputquery('Test','IP Adresse fÅr Portmap Server',IPAdresse) Then
     Begin
     Tcp1.Connect(IPAdresse,111);
     End;
     IF TCP1.Connected Then
     Begin
          MyInfoBox('Verbunden auf port 111 (Portmapper)');
     End;}
     MyErrorBox(GetNLSString('Errors','RPCInfo_Failed'));
End;

Procedure TForm1.Button2OnClick (Sender: TObject);
VAR Adresse:Longword;
    Milisek:longint;
    Hostname:String;
    RC:TFTPPingResult;

Begin
     //FTp2.Ping('81.223.81.201',64,Adresse,Millisek);
     Hostname:='81.223.81.195';
     IF not InputQuery('Test','IP Adresse oder Hostname',Hostname) then exit;
     Rc:=Ftp2.Ping(Hostname,64,Adresse,Milisek);
     MyInfoBox('Kommando Abgearbeitet');
     IF rc=FTPPingOK Then
     Begin
           Tcp1.Connect(Hostname,111);
           IF TCP1.Connected Then Begin MyInfoBox('Verbunden auf port 111 (Portmapper)');End;
           TCP1.CLose;
     End;

     IF rc=ftpPingHostDoesNotReply Then MyInfoBox('No Reply');
End;

{TFTPPingResult=(ftpPingOk,ftpPingHostDoesNotReply,ftpPingSocketError,
                  ftpPingUnkownProtocol,ftpPingSendFailed,ftpPingReceiveFailed,
                  ftpPingUnkownHost,ftpPingOther);}

Procedure TForm1.GetExportList;
VAR
   Filename:String;
   Tmp:String;
   DirBMP:TBitmap;
Begin
     DirBmp:=TBitmap.Create;
     DirBmp.LoadFromResourceName('DirectoryOpen');
     BitmapListBox1.Clear;
     Filename:=GetEnv('ETC')+'\TCPEXP.LST';
     {$I-}
     System.Assign(ListFile,filename);
     Reset(ListFile);IF IoResult<>0 Then Begin ShowMessage('I/O Error bei TCPEXP.LST');exit;End;
     while not eof(ListFile) do
     Begin
          Readln(ListFile,List);
          TMP:=SpaceCut(List);
          IF length(TMP)>1 Then
             Begin
                  BitmapListBox1.AddBitmap(TMP,DirBmp);
                  //Listbox3.Items.add(Tmp);
             End;
     //DirBMP.Destroy;
     End;

System.Close(ListFile);
{$I+}
End;


Procedure TForm1.GetAdressBook;
VAr
   Index:Longint;AddStri:String;
Begin
     //Icon3.LoadFromFile('Z:\Zvaiofu011.ico');
      AdressBookFileName:='NFSBOOK.DAT';
     Cursor:=CRHourGlass;
     ServerListBox.Items.Clear;
     OpenFile(NfsFile,AdressBookFileName,Data_Size);
     For Index:=1 to FileLen(NFSFile)-1 do
     Begin
          GetRec(NFSFile,Index,AdressBookData);
         IF length(AdressBookData.Comment)=0 Then AddStri:='<DEL>|'+GetNLSString('MainForm','DeletedEntry') else
          AddStri:=AdressBookData.IPAdress+'|'+AdressBookData.IPAdress+'|'+AdressBookData.Comment;
          ServerListBox.addObject(AddStri,Icon3);
     End;
     CLoseFile(NFSFile);
     Cursor:=CrDefault;
     NextButton.Enabled:=FALSE;
     ButtonEdit1.Enabled:=FALSE;
     ButtonDelete1.Enabled:=FALSE;
End;



Function  GetRPC_Info(ServerIP:String):Boolean;
VAR RC:Boolean;Dummy:String;
Begin
     Form2.ShowModal(MCStri2String(ServerIP)); // Dies startet RPCINFO -p
     case Form2.RPC_Result of
     TRUE:  Begin
                 Log2StriList(Output_RPCINFO,'RPCInfo.LOG');
                  If GetRpcInfoDLL(Info_error) Then Begin NlsErrorBox('NFS_RPCTimeout');Result:=FALSE;exit;End;

                  IF OS2UserIniFile.ReadBool(UserSection,'cbWarningStatus',FALSE) Then // PrÅfen ob STATUS DÑmon lÑuft
                  Begin
                       IF not GetRpcInfoDLL(Info_status) Then Begin NLSErrorBox('NFS_Status_Missing');Result:=FALSE;exit;End;
                  End;

                  IF OS2UserIniFIle.ReadBool(UserSection,'cbWarningNLOCK',FALSE) Then // PrÅfen ob Nlock Manager LÑuft
                  Begin
                       IF not GetRpcInfoDLL(Info_lock) Then Begin NlsErrorBox('NFS_NLOCK_Missing');Result:=FALSE;exit;End;
                  End;
                 If not GetRpcInfoDLL(Info_nfsd) Then Begin NlsErrorBox('NFS_NFSD_Missing');Result:=FALSE;exit;End;
            End;
     FALSE: Begin
                 Dummy:=DllResultStr;
                 MyErrorBox(GetNLSString('Errors','RPCInfo_Failed')); // Fehler aufgetreten
            End;
     End;
     Form2.CLose;
     Result:=Form2.RPC_Result;
End;



Function GenerateUserString:String;
// Erzeugen der Benutzerspezifischen Angaben mit unterscheidung zwischen OS/2 und Linux
VAR S:String;
Begin
     IF GetRpcInfoDll(Info_PCNFSD) Then
        Begin // OS/2 Server Typ : Anmelden mit Username sowie Passwort
             Result:='-l'+AdressBookData.UserName+' -p'+AdressBookData.Password;
             Exit;
        End
        else
        Begin
            // Linux Server Typ Anmelden mit UID,GIP,FileCtrlBit,DIRCtrlBit
            S:='-u'+AdressBookData.UID+' -g'+AdressBookData.GID+' -fcbits'+AdressBookData.FileBit+' -dcbits'+AdressBookData.DirBit;
            // PrÅfen ob Usermaske eingeschalten ist
           IF AdressBookData.UMaskUse Then S:=S+' -um'+AdressBookData.UMask; // wenn ja usermakse zum schluss anhÑngen
        End;

        IF AdressBookData.cbRespectCase Then S:=S+' -rc';
        IF AdressBookData.cblowercase Then S:=S+' -cl';
        IF AdressBookData.cbCaseSensetiv Then S:=S+' -cs';

        IF Paramstr(1)='\ADVANCED' Then S:=S+AdvancedOptionString;
        Result:=S;
End;


Function GenerateServerString:String;
Begin
      // RÅckwerte : Laufwerk: ServerIP MountPoint
      Result:=Form1.BMPDriveListBox.items[Form1.BMPDriveListBox.ItemIndex][4]+': '+AdressBookData.IPAdress+' '+Form1.BitmapListBox1.Items[FOrm1.BitmapListBox1.ItemIndex];

End;

Procedure TForm1.NoteBook1OnPageChanged (Sender: TObject);
VAR MountString:String;

Begin
     case Notebook1.PageIndex of
     0:Begin PrevButton.Enabled:=FALSE;ButtonTraceLog.Visible:=FALSE;ENd;
     1:Begin
            IF OS2UserIniFile.ReadBool(UserSection,'cbtrace',FALSE) Then ButtonTraceLOG.Visible:=TRUE else ButtonTraceLOG.Visible:=FALSE;
            PrevButton.Enabled:=TRUE;NextButton.Enabled:=TRUE;
     ENd;
     2:Begin
            NextButton.Enabled:=FALSE;
            FormMountLogView.Memo1.Clear;
            IF RadioButtonMount.checked Then GetAdressBook;
            IF RadioButtonUnmount.checked Then Notebook1.PageIndex:=8;
            IF RadioNFSOptions.checked Then Begin FormNFSOption.ShowModal;Notebook1.PageIndex:=1;End;
       End;
     3:Begin
            NextButton.Enabled:=FALSE;
            LabelServer.Caption:=ServerListBox.items[ServerListBox.ItemIndex];
            IF not GetRPC_Info(ServerListBox.items[ServerListBox.ItemIndex] ) then
            Begin
                 FormMountInfo.Close;Notebook1.PageIndex:=1;exit;
            End;

            FormMountInfo.Label1.Caption:=GetNLSString('Message','GettingExportList');FormMountInfo.Show;
            GetNfsExport(MCStri2String(ServerListBox.Items[ServerListBox.ItemIndex]));
            FormMountInfo.CLose;
            IF DLLResultStr='OK' Then getExportList
                                else
                                Begin
                                     MountString:=DLLResultStr;
                                     NLSErrorBox('ShowExp_Failed'+#13+MountString);
                                     Notebook1.PageIndex:=1;
                                End;
       End;
     4:Begin
                NextButton.Enabled:=FALSE;
                LabelAliasResourceName.Caption:=BitmapListbox1.Items[BitmapListBox1.ItemIndex];
                GetFreeDrives;
                BMPDriveListBox.Items.Clear;
                MakeBMPDriveList;
                //DriveListBox.items:=FreeDriveList;
       End;
     5:Begin
            OpenFile(NFSFile,AdressBookFileName,Data_Size);

            GetRec(NFSFile,ServerListBox.ItemIndex+1,AdressBookData);

            CloseFile(NFSFile);
            LabelServerIP.Caption:=AdressBookData.IPAdress;
            LabelDrive.Caption:=BMPDriveListBox.Items[BMPDriveListBox.ItemIndex][4]+':';
            LabelAlias.Caption:=BitmapListBox1.Items[BitmapListBox1.ItemIndex];
            IF GetRpcInfoDLL(Info_pcnfsd) Then LabelServerTyp.Caption:=GetNlsString('MESSAGE','NFS_PCNFSD')
                                        else LabelServerTyp.Caption:=GetNlsString('MESSAGE','NFS_UNIXLinux');
       End;
     6:Begin
            FormMountInfo.Label1.Caption:=GetNLSString('Message','MountInfo');FormMountInfo.Show;

            {IF not AdressBookData.UMaskUse Then MountString:=GenerateUserString+' '+BMPDriveListBox.Items[BMPDriveListBox.ItemIndex][4]+': '+AdressBookData.IPAdress+' '+BitmapListBox1.Items[BitmapListbox1.ItemIndex]
                                       else MountString:=GenerateMountString+' -um'+AdressBookData.UMask+' '+BMPDriveListBox.Items[BMPDriveListBox.ItemIndex][4]+': '+AdressBookData.IPAdress+' '+BitmapListBox1.Items[BitmapListBox1.ItemIndex];}


            DebugForm.Memo1.Lines.Clear;
            DebugForm.Memo1.Lines.add('Options String : '+GenerateUserString);
            DebugForm.Memo1.Lines.add('Mount String : '+GenerateServerString);
            DebugForm.Memo1.lines.add('Kompletter String : mount.exe '+generateUserString+' '+GenerateServerString) ;

            RenameNFSIni; // Ini umbenennen (falls vorhanden)
            IF DllExecNFSProg('mount.exe',GenerateUserString+' '+GenerateServerString,'mount.log') Then // AsufÅhrung erfolgreich ?
            Begin
                 RenameNFSIni; // Ini wieder in Orginalname umbenenen
                 Log2StriList(Output_Mount,'Mount.LOG');
                 IF DriveExists(LabelDrive.Caption[1]) Then Notebook1.PageIndex:=6 // Existiert das neue Laufwerk ? Ja dann zu Seite 7 springen
                                                       else Begin
                                                                 Notebook1.PageIndex:=5; // Nein, Fehlerausgeben
                                                                 FormMountError.Showmodal(Mode_Mount);
                                                                 Notebook1.PageIndex:=4;exit;
                                                              End;
            End else Begin Notebook1.PageIndex:=5;FormMountInfo.Close;MyErrorBox(DLLResultStr);Notebook1.PageIndex:=1;RenameNFSIni;Exit;End;
            FormMountInfo.Close;
            PrevButton.Enabled:=FALSE;
            NextButton.Enabled:=TRUE;NextButton.Caption:=ReadyButtonCaption;
        End;
      7:Begin
             PrevButton.Enabled:=TRUE;
             NextButton.Caption:=GetNlsString('MainForm','ButtonNext');
             Notebook1.PageIndex:=1;
        End;
      8:Begin
             NextButton.Enabled:=FALSE;
             Notebook1.Show;
             FormActivateConfig.Create(Self);
             FormActivateConfig.showModal;
             FormActivateConfig.Destroy;

             ShowBitmapListBoxUmount;
             {ListBox4.Items:=NFSDriveList;}
             IF NFSDriveList.count=0 Then Begin NlsInfoBox('NoNFSDrives');Notebook1.PageIndex:=1;End;
        End;
      9:Begin
             NextButton.Caption:=ReadyButtonCaption;
             PrevButton.Enabled:=FALSE;
             IF not DllExecNFSProg('UMOUNT.EXE',NFSDriveList[BitmapListBoxUmount.ItemIndex],'uMount.log') Then Begin MyErrorBox(DLLResultStr);Notebook1.PageIndex:=1;Exit;ENd;
             Log2StriList(Output_UMount,'uMount.log');
             IF DriveExists(NFSDriveList[BitmapListBoxUMount.ItemIndex][1]) Then Begin Notebook1.PageIndex:=1;FormMountError.ShowModal(MODE_UnMount);Exit;End;
        End;
     10:begin
             NextButton.Caption:=GetNLSString('MainForm','ButtonNext');
             PrevButton.Enabled:=True;
             Notebook1.PageIndex:=1;

        End;
     End;
End;

Procedure TForm1.Form1OnSetupShow (Sender: TObject);
VAR RC:Longint;S:String;
Begin
      IF PROG_DLLVersion<>DLLVersion Then Begin MyErrorBox('The Version of TCPLIB.DLL ('+ToStr(DLLVersion) +') is not valid for this program.'+#13+'You need Version '+ToStr(Prog_DLLVersion));Halt;End;
      Notebook1.PageIndex:=0;
      Icon1.Create;Icon2.Create;Icon3.Create;

      Icon1.LoadFromResourceName('FolderOpen');
      Icon2.LoadFromResourceName('NEtDrive');
      Icon3.LoadFromResourceName('Network');

      Image5.Bitmap:=Icon1;

      NLSIni.Create(OS2UserIniFile.ReadString(UserSectionLang,'NFS_NLSFile','Err'));

      NFSDefaultProgramCheck;
      IF not FileExists(AdressBookFileName) then
      Begin
           MakeFile(NFSFile,AdressBookFileName,data_size);
           CLoseFile(NFSFile);
           NlsInfoBox('NEWBOOK');
      End;
      ReadyButtonCaption:=GetNlsString('MainForm','ButtonReady');


      NFSDriveList.Create;
      FreeDriveList.Create;
      NFSDriveList_Info.Create;
      Output_RPCInfo.Create;
      Output_Mount.Create;
      Output_UMount.Create;

      LanguageSettings;
      IF PAramstr(1)='\ADVANCED' Then RadioNFSOptions.Visible:=TRUE;
      IF Paramstr(1)='\DEBUG' Then
      Begin
           Beep(100,100);
           MenuItemDebug.Create(nil);
           MenuItemDebug.Caption:='~Debug';
           MenuItemDebug.OnCLick:=MenuItemDebugOnClick;
           MainMenu1.Items.Add(MenuItemDebug);
      End;
End;


Procedure TForm1.ButtonNewOnClick (Sender: TObject);
VAR RC:Longint;
Begin
     //RC:=AdressWizard.ShowModal;
     AdressBookV2.Create(Self);
     RC:=AdressBookV2.ShowModal(ABEditMode_Add,0);
     IF RC=CMOK Then
     Begin
          getAdressBook;
     End;
     AdressBookV2.Destroy;
End;

Procedure TForm1.NextButtonOnClick (Sender: TObject);
Begin
     Notebook1.PageIndex:=Notebook1.PageIndex+1;
End;

Procedure TForm1.LanguageSettings;
Begin
     Label1.Caption:=GetNLSString('MainForm','label1');
     Label2.Caption:=GetNLSString('MainForm','label2');
     Label3.Caption:=GetNLSString('MainForm','label3');
     Label4.Caption:=GetNLSString('MainForm','label4');
     Label5.Caption:=GetNLSString('MainForm','label5');
     Label6.Caption:=GetNLSString('MainForm','label6');
     Label7.Caption:=GetNLSString('MainForm','label7');
     Label8.Caption:=GetNLSString('MainForm','label8');
     Label9.Caption:=GetNLSString('MainForm','label9');
     Label10.Caption:=GetNLSString('MainForm','label10');
     Label11.Caption:=GetNLSString('MainForm','label11');
     Label12.Caption:=GetNLSString('MainForm','label12');
     Label13.Caption:=GetNLSString('MainForm','label13');
     Label14.Caption:=GetNLSString('MainForm','label14');
     Label15.Caption:=GetNLSString('MainForm','label15');
     Label16.Caption:=GetNLSString('MainForm','label16');
     Label17.Caption:=GetNLSString('MainForm','label17');
     Label18.Caption:=GetNLSString('MainForm','label18');
     Label19.Caption:=GetNLSString('MainForm','label19');
     Label20.Caption:=GetNLSString('MainForm','label20');
     Label21.Caption:=GetNLSString('MainForm','Label21');
     Label22.Caption:=GetNLSString('MainForm','Label22');
     Label23.Caption:=GetNLSString('MainForm','Label23');
     Label24.Caption:=GetNLSString('MainForm','Label24');
     Label25.Caption:=GetNLSString('MainForm','Label25');
     Label26.Caption:=GetNLSString('MainForm','Label26');
     Label27.Caption:=GetNLSString('MainForm','Label27');

     GroupBox1.Caption:=GetNLSString('MainForm','GROUPBOX1');
     GroupBox2.Caption:=GetNLSString('MainForm','GROUPBOX2');
     GroupBox3.Caption:=GetNLSString('MainForm','GroupBox3');
     RadioButtonMount.Caption:=GetNLSString('MainForm','RadioButtonMount');
     RadioButtonUnmount.Caption:=GetNLSString('MainForm','RadioButtonUnmount');
     RadioNFSOptions.Caption:=GetNLSString('MAINForm','RadioNFSOptions');
     
     ServerListBox.Sections.Items[0].Text:=GetNLSString('MainForm','HeaderICon');
     ServerListBox.Sections.Items[1].Text:=GetNLSString('MainForm','HeaderIP');
     ServerListBox.Sections.Items[2].Text:=GetNLSString('MainForm','HeaderComment');

     HeaderControlDrive.sections.items[0].Text:=GetNlsString('MainForm','HeaderICON');
     HeaderControlDrive.sections.items[1].Text:=GetNLSString('MainForm','HeaderDrive');
     HeaderControlDrive.sections.items[2].Text:=GetNLSString('MainForm','HeaderType');
     //ServerListBox.Sections.Items[0]:='ss';
     ButtonMountLog.Caption:=GetNLSString('MainForm','ButtonLog');
     ButtonUnMountAll.Caption:=GetNLSString('MainForm','ButtonUnMountAll');
     MenuItem1.Caption:=GetNlsString('MainMenu','Menu');
     MenuSettings.Caption:=GetNlsString('MainMenu','Settings');
     MenuItemAbout.Caption:=GetNlsString('MainMenu','About');
     ButtonNew1.Caption:=GetNlsString('MainForm','ButtonNew');
     ButtonEdit1.Caption:=GetNlsString('MainForm','ButtonEdit');
     ButtonDelete1.Caption:=GetNlsString('MainForm','ButtonDelete');
     NextButton.Caption:=GetNLSString('MainForm','ButtonNext');
     PrevButton.Caption:=GetNlsString('MainForm','ButtonPrev');

ENd;

Initialization
  RegisterClasses ([TForm1, TNoteBook, TButton, TGroupBox, TImage, TLabel,
    TRadioButton, TBitBtn, tMultiColumnList, TBitmapListBox,
    THeaderControl, TMainMenu, TMenuItem, TTCP, TFTP, TCheckBox]);
End.
