{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     TCP_ServerServices Unit                                              บ
 บ                                                                          บ
 บ     Version 2 18.10.2005 - last changed 20.10.2005                       บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Unit TCP_ServerServiceWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, TabCtrls, Buttons, ExtCtrls, Spin, Dialogs,Menus,Messages;
  CONST
       Mode_FTP      = 0;
       Mode_Telnet   = 1;
       Mode_Rex      = 2;
       Mode_NFS      = 3;

Type
  TServerServiceWizard = Class (TForm)
    GroupBox1: TGroupBox;
    Title: TLabel;
    NoteBook1: TNoteBook;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    Image12: TImage;
    Label10: TLabel;
    GroupBoxRex: TGroupBox;
    cbAcessRex: TCheckBox;
    Image10: TImage;
    Label9: TLabel;
    NFSStep2: TLabel;
    GroupBoxNfs2: TGroupBox;
    LabelUserID: TLabel;
    LabelGroupID: TLabel;
    EditNFSUSerID: TEdit;
    EditNFSGroupID: TEdit;
    PopUpMenuReadDir: TPopupMenu;
    MenuItemReadDirEdit: TMenuItem;
    MenuItemReadDirDelete: TMenuItem;
    PopupMenuWriteDir: TPopupMenu;
    MenuItemWriteListEdit: TMenuItem;
    MenuItemWriteDirDelete: TMenuItem;
    Image14: TImage;
    Image1: TImage;
    GroupBox4: TGroupBox;
    Image2: TImage;
    Label2: TLabel;
    Label1: TLabel;
    LabelFin8: TLabel;
    LabelFin7: TLabel;
    Image15: TImage;
    GroupBox25: TGroupBox;
    LabelFin6: TLabel;
    LabelFin5: TLabel;
    Image11: TImage;
    GroupBox20: TGroupBox;
    LabelFin4: TLabel;
    LabelFin3: TLabel;
    Image8: TImage;
    GroupBox14: TGroupBox;
    FTPStep1: TLabel;
    FTPStep2: TLabel;
    GroupBoxFTPReadDir: TGroupBox;
    lbReadDir: TListBox;
    cbdenyRead: TCheckBox;
    ButtonBrowseRead: TButton;
    GroupBoxFTPAcess: TGroupBox;
    cbAcessFTP: TCheckBox;
    GroupBoxTelnet1: TGroupBox;
    cbAcessTelnet: TCheckBox;
    Image7: TImage;
    GroupBox6: TGroupBox;
    Image3: TImage;
    Label3: TLabel;
    FTPStep3: TLabel;
    GroupBoxFTPWriteDir: TGroupBox;
    lbWriteDir: TListBox;
    cbdenywrite: TCheckBox;
    ButtonBrowseWrite: TButton;
    GroupBox8: TGroupBox;
    Image4: TImage;
    Label4: TLabel;
    FTPStep4: TLabel;
    GroupBoxFTPIdle: TGroupBox;
    SpinIdleTime: TSpinEdit;
    GroupBox22: TGroupBox;
    Image13: TImage;
    label5: TLabel;
    FTPStep5: TLabel;
    GroupBoxFTPCom: TGroupBox;
    cd: TCheckBox;
    mkdir: TCheckBox;
    get: TCheckBox;
    rmd: TCheckBox;
    put: TCheckBox;
    dir: TCheckBox;
    rename: TCheckBox;
    del: TCheckBox;
    CheckBoxAll: TCheckBox;
    CheckBoxdbg: TCheckBox;
    GroupBox19: TGroupBox;
    Image5: TImage;
    LabelFin2: TLabel;
    LabelFin1: TLabel;
    GroupBox10: TGroupBox;
    Image6: TImage;
    Label6: TLabel;
    TelnetStep1: TLabel;
    GroupBox12: TGroupBox;
    Label7: TLabel;
    TelnetStep2: TLabel;
    GroupBoxTelnet2: TGroupBox;
    EditProgram: TEdit;
    EditShellParam: TEdit;
    LabelProgram: TLabel;
    LabelShell: TLabel;
    cbDropConnection: TCheckBox;
    GroupBox15: TGroupBox;
    Image9: TImage;
    Label8: TLabel;
    GroupBoxNFS1: TGroupBox;
    NFSStep1: TLabel;
    cbAcessNFS: TCheckBox;
    GroupBox17: TGroupBox;
    GroupBox21: TGroupBox;
    GroupBox2: TGroupBox;
    Procedure lbReadDirOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure PopUpMenuReadDirOnPopup (Sender: TObject);
    Procedure PopupMenuWriteDirOnPopup (Sender: TObject);
    Procedure lbWriteDirOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure MenuItemWriteDirDeleteOnClick (Sender: TObject);
    Procedure MenuItemWriteListEditOnClick (Sender: TObject);
    //Procedure lbReadDirOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure MenuItemReadDirDeleteOnClick (Sender: TObject);
    Procedure MenuItemReadDirEditOnClick (Sender: TObject);
    Procedure ButtonBrowseWriteOnClick (Sender: TObject);
    Procedure ButtonBrowseReadOnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure ServerServiceWizardOnSetupShow (Sender: TObject);
    Procedure ButtonBackOnClick (Sender: TObject);
    Procedure ButtonNextOnClick (Sender: TObject);
    Procedure GroupBox4OnClick (Sender: TObject);
    Procedure renameOnClick (Sender: TObject);
    Procedure putOnClick (Sender: TObject);
    Procedure getOnClick (Sender: TObject);
    Procedure delOnClick (Sender: TObject);
    Procedure dirOnClick (Sender: TObject);
    Procedure rmdOnClick (Sender: TObject);
    Procedure mkdirOnClick (Sender: TObject);
    Procedure cdOnClick (Sender: TObject);
    Procedure CheckBoxAllOnClick (Sender: TObject);
    ServerService:Byte;
    EntryIndex:Longint;
    Procedure StoreALLSettings;
    NextCaption:String;
    BackCaption:String;
    FinishCaption:String;
    Function NLS(aSection:STring):String;
    Procedure NlsSettings;
    Procedure NLS_PageSettings;
  Private
    {Private Deklarationen hier einfgen}

  Public
    {ffentliche Deklarationen hier einfgen}
  Constructor Create(aOwner:TComponent;ServerMode:Byte;ItemIndex:longint); Virtual;
  End;

Var
  ServerServiceWizard: TServerServiceWizard;

Implementation
USES DebugUnit,TCP_VAr_Unit,DirChangeDlg,TCPUtilityUnit,TCP_LanguageUnit;



Function TServerServiceWizard.NLS(aSection:String):String;
Begin
     Result:=GetNlsString('SERVER-WIZARD',aSection);
End;

Procedure TServerServiceWizard.NLS_PageSettings;
Begin
     Case Notebook1.PageIndex of
     0:Begin
            Label1.Caption:=Nls('Label#1');
            FTPStep1.Caption:=NLS('FTPStep1');
            GroupBoxFTPAcess.Caption:=NLS('GroupBoxFTPAcess');
            cbAcessFTP.Caption:=NLS('cbAcessFTP');
       End;
     1:Begin
            Label2.Caption:=NLS('Label#2');
            FTPStep2.Caption:=NLS('FTPStep2');
            GroupBoxFTPreadDir.Caption:=NLS('GroupBoxFTPReadDir');
            ButtonBrowseRead.Caption:=NLS('ButtonBrowse');
            cbDenyRead.caption:=NLS('cbdenyRead');
            MenuItemReadDirEdit.Caption:=Nls('MenuItemEdit');
            MenuItemReadDirDelete.Caption:=Nls('MenuItemDel');

       End;
     2:Begin
             Label3.Caption:=NLS('Label#3');
             FTPStep3.Caption:=NLS('FTPStep3');
             cbDenyWrite.caption:=NLS('cbdenyWrite');
             GroupBoxFTPWriteDir.Caption:=NLS('GroupBoxFTPWriteDir');
             ButtonBrowseWrite.Caption:=NLS('ButtonBrowse');
             MenuItemWriteListEdit.Caption:=Nls('MenuItemEdit');
             MenuItemWriteDirDelete.Caption:=Nls('MenuItemDel');
       End;
     3:Begin
            Label4.Caption:=NLS('Label#4');
            FTPStep4.Caption:=NLS('FTPStep4');
            GroupBoxFTPIdle.Caption:=NLS('GroupBoxFTPIdle');
       End;

     4:Begin
            Label5.Caption:=NLS('Label#5');
            FTPStep5.Caption:=NLS('FTPStep5');
            checkBoxAll.Caption:=NLS('CheckBoxAll');
            CheckBoxdbg.Caption:=NLS('CheckBoxdbg');
            GroupBoxFTPCOM.Caption:=NLS('GroupBoxFTPCom');
       End;
      5:Begin
             LabelFin1.Caption:=NLS('LabelFin1');
             LabelFIn2.Caption:=NLS('LabelFin2');
        End;
      7:Begin
             Label6.Caption:=NLS('Label#6');
             TelnetStep1.Caption:=Nls('TelnetStep1');
             GroupBoxTelnet1.Caption:=Nls('GroupBoxTelnet1');
             cbAcessTelnet.Caption:=Nls('cbAcessTelnet');
        End;
       8:Begin
              Label7.Caption:=NLS('Label#7');
              TelnetStep2.Caption:=NLS('TelnetStep2');
              GroupBoxTelnet2.Caption:=Nls('GroupBoxTelnet2');
              LabelProgram.Caption:=NLS('LabelProgram');
              LabelShell.Caption:=Nls('LabelShell');
              cbDropConnection.Caption:=Nls('cbDropConnection');
              EditProgram.Focus;
         End;

       9:Begin
              LabelFin3.Caption:=Nls('LabelFin3');
              LabelFin4.Caption:=Nls('LabelFin2');
         End;

      11:Begin
              Label8.Caption:=NlS('Label#8');
              NFSStep1.Caption:=Nls('NFSStep1');
              cbAcessNFS.Caption:=Nls('cbAcessNFS');
              GroupBoxNFS1.Caption:=Nls('GroupBoxNFS1');
         End;
      12:Begin
              Label9.Caption:=NlS('Label#9');
              NFSStep2.Caption:=Nls('NFSStep2');
              GroupBoxNFS2.Caption:=Nls('GroupBoxNFS2');
              LabelUserID.Caption:=Nls('LabelUserID');
              LabelGroupID.Caption:=Nls('LabelGroupID');
              EditNFSUserID.Focus;
         End;
      13:begin
              LabelFin5.Caption:=Nls('LabelFin5');
              LabelFin6.Caption:=Nls('LabelFin2');
         End;
     15:Begin
             Label10.Caption:=Nls('Label#10');
             //GroupBoxRex.Caption:=NLS('GroupBoxRex');
             cbAcessRex.Caption:=Nls('cbAcessRex');
             LabelFin7.Caption:=NLS('LabelFin7');
             LabelFin8.Caption:=Nls('LabelFin2');
        End;
     End;
End;
Procedure TServerServiceWizard.NLSSettings;
Begin
     Caption:=Nls('Caption');
     Title.Caption:=Nls('Title');
     ButtonNext.Caption:=NLS('ButtonNext');
     ButtonBack.Caption:=NLS('ButtonBack');
     ButtonCancel.Caption:=Nls('ButtonCancel');
     NextCaption:=NLS('ButtonNext');
     BackCaption:=NLS('ButtonBack');
     FinishCaption:=NLS('ButtonFinish');
End;

{Procedure TServerServiceWizard.NLSSettings;
Begin
     Cursor:=CrHourGlass;
     Caption:=Nls('Caption');
     Title.Caption:=Nls('Title');
     Label1.Caption:=Nls('Label#1');
     Label2.Caption:=NLS('Label#2');
     Label3.Caption:=NLS('Label#3');
     Label4.Caption:=NLS('Label#4');
     Label5.Caption:=NLS('Label#5');
     LabelFin1.Caption:=NLS('LabelFin1');
     LabelFIn2.Caption:=NLS('LabelFin2');
     FtpStep1.Caption:=NLS('FTPStep1');
     FTPStep2.Caption:=NLS('FTPStep2');
     FTPStep3.Caption:=NLS('FTPStep3');
     FTPStep4.Caption:=NLS('FTPStep4');
     FTPStep5.Caption:=NLS('FTPStep5');
     GroupBoxFTPAcess.Caption:=NLS('GroupBoxFTPAcess');
     GroupBoxFTPreadDir.Caption:=NLS('GroupBoxFTPReadDir');
     GroupBoxFTPWriteDir.Caption:=NLS('GroupBoxFTPWriteDir');
     GroupBoxFTPIdle.Caption:=NLS('GroupBoxFTPIdle');
     GroupBoxFTPCOM.Caption:=NLS('GroupBoxFTPCom');
     cbAcessFTP.Caption:=NLS('cbAcessFTP');
     cbDenyRead.caption:=NLS('cbdenyRead');
     cbdenywrite.Caption:=NLS('cbDenyWrite');
     checkBoxAll.Caption:=NLS('CheckBoxAll');
     CheckBoxdbg.Caption:=NLS('CheckBoxdbg');
     ButtonBrowseWrite.Caption:=NLS('ButtonBrowse');
     ButtonBrowseRead.Caption:=Nls('ButtonBrowse');
     ButtonNext.Caption:=NLS('ButtonNext');
     ButtonBack.Caption:=NLS('ButtonBack');
     ButtonCancel.Caption:=Nls('ButtonCancel');
     NextCaption:=NLS('ButtonNext');
     BackCaption:=NLS('ButtonBack');
     FinishCaption:=NLS('ButtonFinish');

     Label6.Caption:=NLS('Label#6');
     Label7.Caption:=NLS('Label#7');

     TelnetStep1.Caption:=Nls('TelnetStep1');
     TelnetStep2.Caption:=Nls('TelnetStep2');
     GroupBoxTelnet1.Caption:=Nls('GroupBoxTelnet1');
     GroupBoxTelnet2.Caption:=Nls('GroupBoxTelnet2');
     cbAcessTelnet.Caption:=Nls('cbAcessTelnet');
     LabelProgram.Caption:=NLS('LabelProgram');
     LabelShell.Caption:=Nls('LabelShell');
     cbDropConnection.Caption:=Nls('cbDropConnection');
     LabelFing3.Caption:=Nls('LabelFin3');
     LabelFin4.Caption:=Nls('LabelFin2');

     Label8.Caption:=NlS('Label#8');
     Label9.Caption:=Nls('Label#9');
     NFSStep1.Caption:=Nls('NFSStep1');
     NFSStep2.Caption:=Nls('NFSStep2');
     cbAcessNFS.Caption:=Nls('cbAcessNFS');
     LabelUserID.Caption:=Nls('LabelUserID');
     LabelGroupID.Caption:=Nls('LabelGroupID');
     LabelFin5.Caption:=Nls('LabelFin5');
     LabelFin6.Caption:=Nls('LabelFin2');
     GroupBoxNFS1.Caption:=Nls('GroupBoxNFS1');
     GroupBoxNFS2.Caption:=Nls('GroupBoxNFS2');

     Label10.Caption:=Nls('Label#10');
     //GroupBoxRex.Caption:=NLS('GroupBoxRex');
     cbAcessRex.Caption:=Nls('cbAcessRex');
     LabelFin7.Caption:=NLS('LabelFin7');
     LabelFin8.Caption:=Nls('LabelFin2');
     CurSor:=CrDefault;
End;}


Procedure TServerServiceWizard.PopUpMenuReadDirOnPopup (Sender: TObject);
Begin
           IF lbreadDir.items.Count=0 Then
     Begin
           MenuItemReadDirDelete.Enabled:=FALSE;
           MenuItemReadDirEdit.Enabled:=FALSE;
     End;
End;

Procedure TServerServiceWizard.PopupMenuWriteDirOnPopup (Sender: TObject);
Begin
     IF lbWriteDir.items.Count=0 Then
     Begin
           MenuItemWriteDirDelete.Enabled:=FALSE;
           MenuItemWriteListEdit.Enabled:=FALSE;
     End;
End;

Procedure TServerServiceWizard.lbWriteDirOnItemFocus (Sender: TObject;
  Index: LongInt);
Begin
     MenuItemWriteDirDelete.Enabled:=True;
     MenuItemWriteListEdit.Enabled:=TRUE;
End;

Procedure TServerServiceWizard.MenuItemWriteDirDeleteOnClick (Sender: TObject);
Begin
     lbWriteDir.Items.Delete(lbWriteDir.ItemIndex);
End;

Procedure TServerServiceWizard.MenuItemWriteListEditOnClick (Sender: TObject);
Begin
     DirDialog.Create;
     IF DirDialog.Execute Then lbWriteDir.items[lbWriteDir.ItemIndex]:=DirDialog.Directory;
     DirDialog.Destroy;
End;

Procedure TServerServiceWizard.lbReadDirOnItemFocus (Sender: TObject;
  Index: LongInt);
Begin

     MenuItemReadDirEdit.Enabled:=True;
     MenuItemReadDirDelete.Enabled:=True;
End;

Procedure TServerServiceWizard.MenuItemReadDirDeleteOnClick (Sender: TObject);
Begin
     lbReadDir.Items.Delete(lbReadDir.ItemIndex);
End;

Procedure TServerServiceWizard.MenuItemReadDirEditOnClick (Sender: TObject);
Begin
     DirDialog.Create;
     IF DirDialog.Execute Then lbReadDir.items[lbReadDir.ItemIndex]:=DirDialog.Directory;
     DirDialog.Destroy;
End;

Procedure TServerServiceWizard.ButtonBrowseWriteOnClick (Sender: TObject);
Begin
     DirDialog.Create;
     IF DirDialog.Execute Then lbWriteDir.items.add(DirDialog.Directory);
     DirDialog.Destroy;
End;

Procedure TServerServiceWizard.renameOnClick (Sender: TObject);
Begin
     if not rename.checked then CHeckBoxAll.checked:=false;
    IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.putOnClick (Sender: TObject);
Begin
    IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.getOnClick (Sender: TObject);
Begin
     if not get.checked then CHeckBoxAll.checked:=false;
    IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.delOnClick (Sender: TObject);
Begin
     if not del.checked then CHeckBoxAll.checked:=false;
    IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.dirOnClick (Sender: TObject);
Begin
     if not dir.checked then CHeckBoxAll.checked:=false;
    IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.rmdOnClick (Sender: TObject);
Begin
   if not rmd.checked then CHeckBoxAll.checked:=false;
  IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.mkdirOnClick (Sender: TObject);
Begin
  if not mkdir.checked then CHeckBoxAll.checked:=false;
  IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.cdOnClick (Sender: TObject);
Begin
  IF not cd.Checked then CheckBoxAll.checked:=False;
  IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;
End;

Procedure TServerServiceWizard.CheckBoxAllOnClick (Sender: TObject);
Begin
  cd.checked:=True;
  mkdir.checked:=True;
  rmd.checked:=True;
  dir.checked:=True;
  del.checked:=True;
  get.checked:=True;
  put.checked:=True;
  Rename.checked:=True;
End;


Procedure TServerServiceWizard.ButtonBrowseReadOnClick (Sender: TObject);
Begin
  DirDialog.Create;
  IF DirDialog.Execute Then lbReadDir.items.add(DirDialog.Directory);
  DirDialog.Destroy;
End;



Procedure TServerServiceWizard.StoreAllSettings;
var Loop:longint;S1,S2:String;debugStr:String;


Begin
    DebugStr:='';
    IF cbAcessFTP.checked Then DebugForm.lbServicesFTP.items[entryIndex]:='true'
                           else DebugForm.lbServicesFTP.items[entryIndex]:='false';

    IF cbAcessTelnet.checked Then DebugForm.lbServicesTelnet.items[entryIndex]:='true'
                           else DebugForm.lbServicesTelnet.items[entryIndex]:='false';

    IF cbAcessRex.checked Then DebugForm.lbServicesRex.items[entryIndex]:='true'
                           else DebugForm.lbServicesRex.items[entryIndex]:='false';

    IF cbAcessNFS.checked Then DebugForm.lbServicesNFS.items[entryIndex]:='true'
                           else DebugForm.lbServicesNFS.items[entryIndex]:='false';

    FtpServerRec[EntryIndex].ReadDir.Clear;
         FtpServerRec[EntryIndex].WriteDir.Clear;

    IF lbReadDir.Items.count<>0 Then
    Begin
         For Loop:=0 To lbReadDir.Items.count-1 do FtpServerRec[EntryIndex].ReadDir.add(lbReadDir.Items[loop]);
    End else FtpServerRec[EntryIndex].ReadDir.Clear;

    IF LbWriteDir.Items.count<>0 Then
    Begin
         For Loop:=0 To lbWriteDir.Items.Count-1 do FtpServerRec[EntryIndex].WriteDir.add(lbWriteDir.Items[loop]);
    End else FtpServerRec[EntryIndex].WriteDir.Clear;

    IF cbdenyRead.checked then DebugForm.lbServicesFTPDcanRead.items[EntryIndex]:='true'
                          else DebugForm.lbServicesFTPDcanRead.items[EntryIndex]:='false';

    IF cbdenyWrite.checked then DebugForm.lbServicesFTPDcanwrite.items[EntryIndex]:='true'
                          else DebugForm.lbServicesFTPDcanwrite.items[EntryIndex]:='false';

    DebugForm.lbServicesFTPDidleTimeout.items[EntryIndex]:=ToStr(SpinIdleTime.Value);

    DebugForm.lbServicesFTPDreadDirectory.items[EntryIndex]:=MultiValueToString(lbReadDir.items);
    DebugForm.lbServicesFTPDWriteDirectory.items[EntryIndex]:=MultiValueToString(lbWriteDir.items);

    IF CheckBoxdbg.checked Then debugStr:='logdbg ';
    IF del.checked then DebugStr:=DebugStr+'logdel ';
    if dir.checked then DebugStr:=DebugStr+'logdir ';
    if get.checked then DebugStr:=DebugStr+'logget ';
    if mkdir.checked then DebugStr:=DebugStr+'logmkd ';
    if put.checked Then DebugStr:=DebugStr+'logput ';
    IF rmd.checked then DebugStr:=DebugStr+'logrmd ';
    if rename.checked then DebugStr:=DebugStr+'logren ';
    IF cd.checked then DebugStr:=DebugStr+'logcd';
    DebugForm.lbServicesFTPDLog.items[EntryIndex]:=DebugStr;

    IF cbDropConnection.checked Then DebugForm.lbTelnetDisconnect.items[EntryIndex]:='true'
                                else DebugForm.lbTelnetDisconnect.items[EntryIndex]:='false';

    DebugForm.lbServicesTelnetShell.Items[EntryIndex]:=EditShellParam.Text;
    DebugForm.lbServicesTelnetParamter.items[EntryIndex]:=EditProgram.Text;

    DebugForm.lbServicesNFSUSerID.items[entryindex]:=EditNfsUserID.Text;
    DebugForm.lbservicesNFSGroupID.Items[EntryIndex]:=EditNfsGroupID.Text;
End;

Procedure TServerServiceWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
    Case Notebook1.PageIndex of
    0:Begin ButtonBack.Enabled:=FALSE;NLS_PageSettings;End;
    1:Begin ButtonBack.Enabled:=True;NLS_PageSettings;End;
    2:NLS_PageSettings;
    3:NLS_PageSettings;
    4:Begin ButtonNext.Caption:=NextCaption;NLS_PageSettings;End;
    5:Begin ButtonNext.Caption:=FinishCaption;NLS_PageSettings;End;
    6:Begin StoreAllSettings;DisMissDlg(CmOk);End;
    7:Begin ButtonBack.Enabled:=FALSE;NLS_PageSettings;End;
    8:Begin ButtonBack.Enabled:=True;ButtonNext.Caption:=NextCaption;NLS_PageSettings;End;
    9:Begin ButtonNext.Caption:=FinishCaption;NLS_PageSettings;End;
    10:Begin StoreALLSettings;DisMissDlg(CmOk);End;
    11:Begin ButtonBack.Enabled:=FALSE;Nls_PageSettings;End;
    12:Begin ButtonBack.Enabled:=True;ButtonNext.Caption:=NextCaption;NLS_PageSettings;End;
    13:Begin ButtonNext.Caption:=FInishCaption;NLS_PageSettings;END;
    14:Begin StoreAllSettings;DisMissDlg(CmOK);End;
    15:Begin ButtonBack.Enabled:=FALSE;ButtonNext.Caption:=NextCaption;NLS_PageSettings;End;
    16:Begin ButtonBack.Enabled:=True;ButtonNext.Caption:=FinishCaption;End;
    17:Begin StoreAllSettings;DisMissDlg(CmOK);End;
    End;
End;

Procedure TServerServiceWizard.ServerServiceWizardOnSetupShow (Sender: TObject);
Begin
     {Common Settings .. FTP,Telnet,Rex,NFS}
     IF DebugForm.lbServicesFTP.items[EntryIndex]='true' then cbAcessFTP.checked:=TRUE else cbAcessFTP.checked:=FALSE;
     IF DebugForm.lbServicesTelnet.items[EntryIndex]='true' Then cbAcessTelnet.Checked:=True else cbAcessTelnet.checked:=False;
     IF DebugForm.lbServicesRex.Items[EntryIndex]='true' Then cbAcessRex.Checked:=True else cbAcessRex.checked:=False;
     IF DebugForm.lbServicesNFS.Items[EntryIndex]='true' Then cbAcessNFS.Checked:=True else cbAcessNFS.checked:=FALSE;

     {FTP Only Settings}
     IF DebugForm.lbServicesFTPDcanRead.items[EntryIndex]='true' Then cbdenyRead.Checked:=True else cbdenyRead.CHecked:=FALSE;
     IF DebugForm.lbServicesFTPDcanWrite.Items[EntryIndex]='true' Then cbdenyWrite.Checked:=True else cbDenyWrite.checked:=False;
     SpinIdleTime.Value:=ToInt(DebugForm.lbServicesFTPDidleTimeout.Items[EntryIndex]);
     lbReadDir.Items:=FTPServerRec[EntryIndex].ReadDir;
     lbWriteDir.Items:=FTPServerRec[EntryIndex].WriteDir;
       IF FindWordinStri('logcd',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then cd.checked:=True else cd.checked:=False;
       IF FindWordinStri('logdbg',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then CheckBoxdbg.checked:=True else CheckBoxdbg.checked:=False;
       IF FindWordinStri('logdel',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then del.checked:=True else del.checked:=False;
       IF FindWordinStri('logdir',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then dir.checked:=True else dir.checked:=False;
       IF FindWordinStri('logget',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then get.checked:=True else get.checked:=False;
       IF FindWordinStri('logput',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then put.checked:=True else get.checked:=False;
       IF FindWordinStri('logren',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then rename.checked:=True else rename.checked:=False;
       IF FindWordinStri('logmkd',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then mkdir.checked:=True else mkdir.checked:=False;
       IF FindWordinStri('logrmd',DebugForm.lbServicesFTPDLog.items[EntryIndex])<>-1 Then rmd.checked:=True else rmd.checked:=False;
       IF ( (cd.checked) and (mkdir.checked) and (mkdir.checked) and (rmd.checked) and (dir.checked) and (del.checked) and (get.checked) and (put.checked) and (rename.checked) ) Then CheckBoxAll.checked:=TRUE else CheckBoxAll.checked:=FALSE;

       {Telnet Settings}
       EditProgram.Text:=DebugForm.lbServicesTelnetShell.items[EntryIndex];
       EditShellParam.Text:=DebugForm.lbServicesTelnetParamter.items[EntryIndex];
       IF DebugForm.lbTelnetDisconnect.Items[EntryIndex]='true' Then cbDropConnection.Checked:=True;

       {NFS Settings}
       EditNFSUserId.Text:=DebugForm.lbServicesNFSUSerID.Items[EntryIndex];
       EditNFSGroupID.Text:=DebugFOrm.lbServicesNfsGroupID.Items[EntryIndex];
     Case ServerService of
     Mode_FTP:Notebook1.PageIndex:=0;
     MODE_Telnet:Notebook1.PageIndex:=7;
     Mode_NFS:Notebook1.PageIndex:=11;
     Mode_Rex:Notebook1.PageIndex:=15;
     End;

     NlsSettings;
     NLS_PageSettings;


End;

Procedure TServerServiceWizard.ButtonBackOnClick (Sender: TObject);
Begin
  Notebook1.PageIndex:=Notebook1.PageIndex-1;
End;

Procedure TServerServiceWizard.ButtonNextOnClick (Sender: TObject);
Begin
     Notebook1.PageIndex:=Notebook1.PageIndex+1;
End;

Procedure TServerServiceWizard.GroupBox4OnClick (Sender: TObject);
Begin
End;

Constructor TServerServiceWizard.Create;
Begin
     Inherited.Create(aOwner);
     ServerService:=ServerMode;
     EntryIndex:=ItemIndex;
End;

Initialization
  RegisterClasses ([TServerServiceWizard, TGroupBox, TLabel, TNoteBook, TButton, TImage,
    TCheckBox, TListBox, TEdit, TSpinEdit, TPopupMenu, TMenuItem]);
End.
