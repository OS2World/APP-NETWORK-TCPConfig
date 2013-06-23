
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     TCP_USERWizard Unit                                                  บ
 บ                                                                          บ
 บ     Version 2 17.10.2005 - last changed 18.10.2005                       บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Unit TCP_UserWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, TabCtrls, Buttons, ExtCtrls,Messages,Dialogs;

Type
  TUserWizard = Class (TForm)
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    NoteBook1: TNoteBook;
    GroupBox1: TGroupBox;
    LabelTitle: TLabel;
    ButtonBrowse: TButton;
    Image5: TImage;
    LabelFinish1: TLabel;
    LabelFinish2: TLabel;
    GroupBox5: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    LabelStep1: TLabel;
    GroupBoxUser: TGroupBox;
    EditUserName: TEdit;
    LabelUserName: TLabel;
    LabelPassword1: TLabel;
    EditPassword1: TEdit;
    EditPassword2: TEdit;
    LabelPassword2: TLabel;
    EditComment: TEdit;
    GroupBoxUserDir: TGroupBox;
    EditRootDir: TEdit;
    Image4: TImage;
    Label3: TLabel;
    LabelStep3: TLabel;
    GroupBoxComment: TGroupBox;
    Image2: TImage;
    Label2: TLabel;
    LabelStep2: TLabel;
    Procedure ButtonBrowseOnClick (Sender: TObject);
    Procedure EditUserNameOnChange (Sender: TObject);
    Procedure ButtonNextOnClick (Sender: TObject);
    Procedure ButtonBackOnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure UserWizardOnSetupShow (Sender: TObject);
    Procedure ClearAllEntrys;
    Procedure DisplayAllEntrys;
    EntryFlag:Boolean;
    EntryIndex:Longint;
    Procedure StoreSettings;
    NextCaption:String;
    FinishCaption:String;
    Function CheckEntrys:Boolean;
    Procedure NLSSettings;
    Function NlS(aSection:String):String;
  Private
    {Private Deklarationen hier einfgen}
  Public
    {ffentliche Deklarationen hier einfgen}
  Constructor Create(aOwner:TComponent;aEntryFlag:Boolean;aIndex:Longint); virtual;
  End;

Var
  UserWizard: TUserWizard;
imports
Function DLLResultStr:String; 'TCPLIB' NAME 'DllReturnString';
Procedure CryptUserPassword(S:String);'TCPLIB' NAME 'CryptUserPassword';
End;

Implementation
USES DebugUnit,TCP_LanguageUnit,DirChangeDlg;

Function TUserWizard.NlS(aSection:String):String;
Begin
     Result:=GetNlsString(Name,aSection);
End;

Procedure TUserWizard.NlsSettings;
Begin
     Caption:=Nls('Caption');
     LabelTitle.Caption:=Nls('Title');
     Label1.Caption:=Nls('Label#1');
     Label2.Caption:=NLS('Label#2');
     Label3.Caption:=Nls('Label#3');
     LabelStep1.Caption:=Nls('LabelStep1');
     LabelStep2.Caption:=Nls('LabelStep2');
     LabelStep3.Caption:=Nls('LabelStep3');
     GroupBoxUser.Caption:=Nls('GroupBoxUser');
     GroupBoxComment.Caption:=Nls('GroupBoxCOmment');
     GroupBoxUSerDir.Caption:=Nls('GroupBoxUserDir');
     LabelFinish1.Caption:=Nls('LabelFinish1');
     LabelFInish2.Caption:=Nls('LabelFinish2');
     FInishCaption:=Nls('ButtonFinish');
     NextCaption:=Nls('ButtonNext');
     ButtonCancel.Caption:=Nls('ButtonCancel');
     ButtonNext.Caption:=NextCaption;
     ButtonBack.Caption:=Nls('ButtonBack');
     LabelUserName.Caption:=Nls('LabelUserName');
     LabelPassword1.Caption:=Nls('LabelPassword1');
     LabelPassword2.Caption:=Nls('LabelPassword2');
End;

Procedure TUserWizard.ButtonBrowseOnClick (Sender: TObject);
Begin
     DirDialog.Create;
     IF DirDialog.Execute Then EditRootDir.Text:=DirDialog.Directory;
     DirDialog.Destroy;
End;

Procedure TUserWizard.EditUserNameOnChange (Sender: TObject);
Begin
     IF EditUserName.Text<>'' Then ButtonNext.Enabled:=True else ButtonNext.Enabled:=FALSE;
End;

Procedure TUserWizard.StoreSettings;
VAR Tmp:String;
Begin

     Case EntryFlag of
     False:
             Begin
                 DebugForm.lbServicesUserName.items[EntryIndex]:=EditUserName.Text;
                 CryptUserPassword(EditPassword1.Text);
                 TRY
                 TMP:=DllResultStr;
                 Except raise EInvalidCast.Create('TUserWizard.StoreSettings : Exception bei Passwort String zuweisung');Halt;
                 End;
                 DebugForm.lbServicesPasswordCrypted.items[EntryIndex]:=TMP;
                 DebugForm.lbServicesPassword.items[EntryIndex]:=EditPassword1.Text;
                 //DebugForm.lbServicesPassword.items[EntryIndex]:=EditPassword2.Text;
                 DebugForm.lbServicesComments.items[EntryIndex]:=EditComment.Text;
                 DebugForm.lbServicesHomeDir.Items[EntryIndex]:=EditRootDir.Text;
              End;

      TRUE: Begin
                 CryptUserPassword(EditPassword1.Text);
                 TRY
                 TMP:=DllResultStr;
                 Except raise EInvalidCast.Create('TUserWizard.StoreSettings : Exception bei Passwort String zuweisung');Halt;
                 End;
                 DebugForm.lbServicesPasswordCrypted.items.Add(TMP);
                 DebugForm.lbServicesUserName.items.add(EditUserName.Text);
                 DebugForm.lbServicesPassword.items.add(EditPassword1.Text);
                 DebugForm.lbServicesComments.items.add(EditComment.Text);
                 DebugForm.lbServicesHomeDir.Items.add(EditRootDir.Text);
                 DebugForm.lbServicesFTP.Items.add('false');
                 DebugFOrm.lbServicesTelnet.items.add('false');
                 DebugForm.lbServicesRex.items.add('false');
                 DebugForm.lbServicesNFS.items.add('false');
                 DebugForm.lbServicesFTPDreadDirectory.Items.add('');
                 DebugForm.lbServicesFTPDWriteDirectory.Items.add('');
                 DebugForm.lbServicesFTPDcanRead.items.add('false');
                 DebugForm.lbServicesFTPDcanWrite.items.add('false');
                 DebugForm.lbServicesFTPDLog.items.add('');
                 DebugForm.lbServicesFTPDidleTimeout.items.add('900');
                 DebugForm.lbServicesTelnetShell.items.add('telnetd.cmd');
                 DebugForm.lbServicesTelnetParamter.items.add('');
                 DebugForm.lbTelnetDisconnect.items.add('false');
                 DebugForm.lbServicesNFSUSerID.items.add('');
                 DebugForm.lbServicesNFSGroupID.items.add('');
            End;
          End;
End;

Procedure TUserWizard.ButtonNextOnClick (Sender: TObject);
Begin

     IF checkEntrys Then Notebook1.PageIndex:=Notebook1.PageIndex+1;
End;

Procedure TUserWizard.ButtonBackOnClick (Sender: TObject);
Begin
     Notebook1.PageIndex:=Notebook1.PageIndex-1;
End;

Function TUserWizard.CheckEntrys:Boolean;
Begin
     Result:=FALSE;
     Case Notebook1.PageIndex of
     0:Begin
            IF EditPassword1.Text<>EditPassword2.Text Then Begin NlsInfoBox('SOCKS_INVPassword');EditPassword1.Focus;Exit;End;
       End;
     End;
 Result:=True;
End;

Procedure TUserWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
     Case Notebook1.PageIndex of
     0:Begin ButtonBack.Enabled:=FALSE;EditUserName.Focus;End;
     1:Begin ButtonBack.Enabled:=True;EditComment.Focus;End;
     2:Begin ButtonNext.Caption:=NextCaption;EditRootDir.Focus;End;
     3:ButtonNext.Caption:=FinishCaption;
     4:Begin StoreSettings;DisMissDlg(CMOK);End;
     End;
End;

Procedure TUserWizard.ClearAllEntrys;
Begin
    EditUserName.Clear;
    EditPassword1.Clear;
    EditPassword2.Clear;
    EditComment.Clear;
    EditRootDir.Clear;
End;

Procedure TUserWizard.DisplayAllEntrys;
Begin
     EditUserName.Text:=DebugForm.lbServicesUserName.items[EntryIndex];
     EditPassword1.Text:=DebugForm.lbServicesPassword.items[EntryIndex];
     EditPassword2.Text:=DebugForm.lbServicesPassword.items[EntryIndex];
     EditComment.Text:=DebugForm.lbServicesComments.items[EntryIndex];
     EditRootDir.Text:=DebugForm.lbServicesHomeDir.Items[EntryIndex];
End;

Procedure TUserWizard.UserWizardOnSetupShow (Sender: TObject);
Begin
    Case EntryFlag of
    TRUE: ClearAllEntrys;
    FALSE: Begin DisplayAllEntrys;EditUserNameOnChange(Self);End;
    End;
    EditUserName.Focus;
    NlsSettings;
    Notebook1.PageIndex:=0;
End;

Constructor TUserWizard.Create;
Begin
     inherited.Create(aOwner);
     EntryIndex:=aIndex;
     EntryFlag:=aEntryFlag;
End;

Initialization
  RegisterClasses ([TUserWizard, TButton,
    TImage, TNoteBook, TGroupBox, TLabel, TEdit]);
End.
