{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     UNIT TCP_SOCKSWizard                                                 บ
 บ                                                                          บ
 บ     Version 1 15.10.2005 - last changed 15.10.2005                       บ
 บ     ** gendert fr WDSibyl 13.08.06                                     บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Unit TCP_SOCKSWizard;
Interface

Uses
  Classes, Forms, Graphics, StdCtrls, TabCtrls, Buttons, ExtCtrls,Dialogs,SysUtils,Messages;

Type
  TSocksWizard = Class (TForm)
    GroupBox1: TGroupBox;
    LabelTitle: TLabel;
    NoteBook1: TNoteBook;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    ButtonBack: TButton;
    GroupBoxdirectsubnet: TGroupBox;
    GroupBoxDirectIP: TGroupBox;
    GroupBoxserverip: TGroupBox;
    LabelServerStep1: TLabel;
    LabelServer1: TLabel;
    LabelReadyCaption2: TLabel;
    LabelReadyCaption1: TLabel;
    LabelDirectStep2: TLabel;
    LabelDirect2: TLabel;
    LabelDirectStep1: TLabel;
    LabelDirect1: TLabel;
    EditSocksServerIP: TEdit;
    EditSocksDirectSubnet: TEdit;
    EditSocksDirectIP: TEdit;
    Image5: TImage;
    LabelServer2: TLabel;
    Image1: TImage;
    LabelServerStep2: TLabel;
    GroupBoxServerTarget: TGroupBox;
    EditSocksServerTargetIP: TEdit;
    Image6: TImage;
    LabelServer3: TLabel;
    LabelServerStep3: TLabel;
    GroupBoxServerSubnet: TGroupBox;
    EditSocksServerSubnet: TEdit;
    Image7: TImage;
    LabelServer4: TLabel;
    LabelServerStep4: TLabel;
    GroupBoxuserid: TGroupBox;
    EditSocksServerUserID: TEdit;
    EditSocksServerPassword1: TEdit;
    EditSocksServerPassword2: TEdit;
    LabelUserID: TLabel;
    LabelPassword1: TLabel;
    LabelPassword2: TLabel;
    Image8: TImage;
    LabelReadyCaption3: TLabel;
    LabelReadyCaption4: TLabel;
    Procedure ButtonBackOnClick (Sender: TObject);
    Procedure ButtonNextOnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure NoteBook1OnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfgen}
  Procedure NewSocksEntry;
  Procedure EditSocksEntry;
  Public
    {ffentliche Deklarationen hier einfgen}
  SocksEntryFlag:Boolean;           // True if ADD Mode , FALSE when EDIT Mode
  SocksEntryIndex:Longint;          // Index of the Listbox Record
  SocksDirectFlag:Boolean;           // IF True , Wizard will be in SOCKS DIRECT Mode
  SocksServerFlag:Boolean;          // IF True, Wizard will be in SOCKS Server Mode
  Constructor Create(aOwner:TComponent);                 Override;
  End;

Var
  SocksWizard: TSocksWizard;

Implementation
USES DebugUnit,tcp_Check_IP_Unit,tcp_LanguageUnit;

Procedure TSocksWizard.NewSocksEntry;
Begin
     IF SOCKSDirectFlag Then
     Begin
          EditSocksDirectIP.Clear;
          EditSocksDirectSubnet.Clear;
          Notebook1.PageIndex:=0;
          EditSocksDirectIP.Focus;
     End;
     IF SocksServerFlag Then
     Begin
         EditSocksServerIP.Clear;
         EditSocksServerSubnet.Clear;
         EditSocksServerTargetIP.Clear;
         EditSocksServerUserID.Clear;
         EditSocksServerPassword1.Clear;
         EditSocksServerPassword2.Clear;
         Notebook1.PageIndex:=4;
         EditSocksServerIP.Focus;
     End;
End;

Procedure TSocksWizard.EditSocksEntry;
Begin
        IF SOCKSDirectFlag Then
     Begin
          Try
          EditSocksDirectIP.Text:=DebugForm.lbSocksDirectTargetIP.Items[SocksEntryIndex];
          EditSocksDirectSubnet.Text:=DebugForm.lbSocksDirectSubnet.Items[SocksEntryIndex];
          Except
          Notebook1.PageIndex:=0;
          Raise Exception.Create('SOCKS-Zuweisung Ausnahme Verletzung aufgetreten !');
          End;
     End;
     IF SocksServerFlag Then
     Begin
         Try
         EditSocksServerIP.Text:=DebugForm.lbSOCKSServerIP.Items[SocksEntryIndex];
         EditSocksServerSubnet.Text:=DebugForm.lbSOCKSServerTargetIP.Items[SocksEntryIndex];
         EditSocksServerTargetIP.Text:=DebugForm.lbSOCKSServerSubnet.Items[SocksEntryIndex];
         EditSocksServerUserID.Text:=DebugForm.lbSOCSKSServerUserID.Items[SocksEntryIndex];
         EditSocksServerPassword1.Text:=DebugForm.lbSOCKSServerpassword.Items[SocksEntryIndex];
         EditSocksServerPassword2.text:=DebugForm.lbSOCKSServerpassword.Items[SocksEntryIndex];
         Except Raise Exception.Create('SOCKS-Zuweisung Ausnahme Verletzung aufgetreten !');
         End;
         Notebook1.PageIndex:=4;
     End;
End;

Procedure TSocksWizard.ButtonBackOnClick (Sender: TObject);
Begin

     NoteBook1.PageIndex:=Notebook1.PageIndex-1;
End;

Procedure TSocksWizard.ButtonNextOnClick (Sender: TObject);
Begin
          case notebook1.pageindex of
     4:if not ValidIPAdress(editsocksserverip.text,chkopt_zeronotallowed,'invalid_socksserverIP') then exit;
     5:if not ValidIPAdress(editsocksservertargetip.text,chkopt_zeronotallowed,'invalid_socksserverTargetIP') Then exit;
     6:if not ValidIPAdress(editsocksservertargetip.text,chkopt_zeronotallowed,'invalid_Subnet') Then exit;
     7:begin
            IF EditSocksServerUserID.Text='' Then Begin NLSInfoBox('SOCKS_EmptyUID');Exit;End;
            IF EditSocksServerPassword1.Text='' Then Begin NLSInfoBox('SOCKS_EmptyPassword');Exit;End;
            IF EditSocksServerPassword1.Text<>EditSocksServerPassword2.Text Then Begin NlsInfoBox('Socks_InvPassword');Exit;End;
       End;
     end;
         NoteBook1.PageIndex:=Notebook1.PageIndex+1;
End;



Procedure TSocksWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
     case Notebook1.PageIndex of
     0:Begin ButtonBack.Enabled:=FALSE;EditSocksDirectIP.Focus;End;
     1:Begin ButtonBack.Enabled:=True;EditSocksDirectSubnet.Focus;ButtonNext.Text:=getNlsString(Name,'ButtonNext');End;
     2:ButtonNext.text:=GetNLSString(Name,'ButtonNext');
     3:Begin
            Debugform.lbSocksDirectTargetIP.items.add(EditSocksDirectIP.Text);
            DebugForm.lbSocksDirectSubnet.Items.add(EditSocksDirectSubnet.Text);
            DisMissDlg(CmOK);
       End;
     4:Begin ButtonBack.Enabled:=false;EditSocksServerIP.Focus;End;
     5:Begin ButtonBack.Enabled:=true;EditSocksServerTargetIP.FOCUS;End;
     6:EditSocksServerSubnet.Focus;
     7:Begin ButtonNext.text:=GetNlsString(Name,'ButtonNext');EditSocksServerUserID.Focus;End;
     8:ButtonNext.Text:=GetNlsString(Name,'ButtonFinish');
     9:Begin
           DebugForm.lbSocksServerIP.Items.add(EditSocksServerIP.Text);
           DebugForm.lbSocksServerTargetIP.Items.Add(EditSocksServerTargetIP.Text);
           DebugForm.lbSocksServerSubnet.Items.add(EditSocksServerSubnet.Text);
           DebugForm.lbSOCSKSServerUserID.items.add(EditSocksServerUserID.Text);
           DebugFOrm.lbSocksServerPassword.items.add(EditSocksServerPassword1.Text);
           DisMissDlg(CmOK);
        End;

     End;
End;

Procedure TSocksWizard.NoteBook1OnSetupShow (Sender: TObject);
Begin
     //IF (SOcksServerFlag=FALSE) or (SocksDirectFlag)=False Then Begin ErrorBox('Programm Fehler ! weder SocksServerFLAG  noch SocksDirectFlag gesetzt !');DisMissDlg(CmCancel);Exit;End;
     Case SocksEntryFlag of
     TRUE: NewSocksEntry;
     FALSE: EditSocksEntry;
     End;
     Caption:=GetNlsString(Name,'Caption');
     LabelTitle.Caption:=GetNlsString(Name,'LabelTitle');
     LabelDirect1.Caption:=GetNlsString(Name,'LabelDirect1');
     LabelDirect2.Caption:=GetNlsString(Name,'LabelDirect2');
     LabelDirectStep1.Caption:=GetNlsString(Name,'LabelDirectStep1');

     LabelServer1.Caption:=GetNlsString(Name,'LabelServer1');
     LabelServer2.Caption:=GetNlsString(Name,'LabelServer2');
     LabelServer3.Caption:=GetNlsString(Name,'LabelServer3');
     LabelServer4.Caption:=GetNlsString(Name,'LabelServer4');

     LabelServerStep1.Caption:=GetNlsString(Name,'LabelServerStep1');
     LabelServerStep2.Caption:=GetNlsString(Name,'LabelServerStep2');
     LabelServerStep3.Caption:=GetNlsString(Name,'LabelServerStep3');
     LabelServerStep4.Caption:=GetNlsString(Name,'LabelServerStep4');

     LabelReadyCaption1.Caption:=GetNlsString(Name,'LabelReadyCaption1');
     LabelReadyCaption2.Caption:=GetNlsString(Name,'LabelReadyCaption2');
     LabelReadyCaption3.Caption:=GetNlsString(Name,'LabelReadyCaption3');
     LabelReadyCaption4.Caption:=GetNlsString(Name,'LabelReadyCaption4');

     GroupBoxDirectIP.Caption:=GetNlsString(Name,'GroupBoxDirectIP');
     GroupBoxDirectSubnet.Caption:=GetNlsString(Name,'GroupBoxDirectSubnet');

     GroupBoxServerIP.Caption:=GetNlsString(Name,'GroupBoxServerIP');
     GroupBoxServerTarget.Caption:=GetNlsString(Name,'GroupBoxServerTarget');
     GroupBoxServerSubnet.Caption:=GetNlsString(Name,'GroupBoxServerSubnet');
     GroupBoxUSerID.Caption:=GetNlsString(Name,'GroupBoxUserID');

     LabelUserID.Caption:=GetNLSString(Name,'LabelUSerID');
     LabelPassword1.Caption:=GetNLSString(Name,'LabelPassword1');
     LabelPassword2.Caption:=GetNLSString(Name,'labelpassword2');

     ButtonBack.Caption:=GetNlsString(Name,'ButtonBack');
     ButtonNext.Caption:=GetNlsString(Name,'ButtonNext');
     ButtonCancel.Caption:=GetNlsString(Name,'ButtonCancel');

End;

Constructor TSocksWizard.Create;
Begin
     SocksServerFlag:=FALSE;
     SocksDirectFlag:=FALSE;
     inherited.Create(aOwner);
End;

Initialization
  RegisterClasses ([TSocksWizard, TGroupBox, TLabel, TNoteBook, TButton, TImage, TEdit
   ]);
End.
