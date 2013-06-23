Unit TCP_SpecialSettingsNotebook;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, Buttons, ExtCtrls, StdCtrls, INet,Messages,COlor;

Type
  TTCPSpecialSettingsNotebook = Class (TForm)
    Notebook: TTabbedNotebook;
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    LabelLoopback: TLabel;
    GroupLoopBack: TGroupBox;
    EditLoopbackIP: TEdit;
    LabelLoopBackIP: TLabel;
    LabelLoopBackSubnet: TLabel;
    EditLoopBackSubnet: TEdit;
    LabelIPRouter: TLabel;
    RadioIPGateway: TRadioGroup;
    Procedure ButtonSelectAliasIPOnClick (Sender: TObject);
    Procedure cbActivateFixedAliasIPOnClick (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure TCPSpecialSettingsNotebookOnSetupShow (Sender: TObject);
    Procedure HilfeButtonOnClick (Sender: TObject);
    Procedure RadioIPGatewayOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Procedure AliasIPStatus(Status:Boolean);
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  TCPSpecialSettingsNotebook: TTCPSpecialSettingsNotebook;

Implementation
USES DOS,TCPUtilityUnit,DebugUnit,TCP_VAR_Unit,TCPutilityUnit,MyMessageBox,TCP_LanguageUnit,TCP_ConfigSysAdd;
{$R TCP_SETTINGSNotebook}


Procedure TTCPSpecialSettingsNotebook.ButtonSelectAliasIPOnClick (Sender: TObject);
Begin
End;

Procedure TTCPSpecialSettingsNotebook.AliasIPStatus(Status:Boolean);
Begin
End;


Procedure TTCPSpecialSettingsNotebook.cbActivateFixedAliasIPOnClick (Sender: TObject);
Begin
End;

Procedure TTCPSpecialSettingsNotebook.OKButtonOnClick (Sender: TObject);
Begin
    OKButton.ModalResult:=cmOK;
    Default_IP_Error:=ISIPAdressValid(EditLoopBackIP.Text,False);



    if Default_IP_Error.Valid Then
    Begin
         ChangeRec.Loopback:=True;
         DebugForm.EditLoopIp.Text:=EditLoopBackIP.Text;
     End
         else
     Begin
          NLSInavlidIPDialog(EF_IPNum);
          OkButton.ModalResult:=CmNull;
          ChangeRec.LoopBack:=False;
     End;

     IF EditLoopBackSubnet.Text<>'' Then
     Begin
          Default_IP_Error:=IsIPAdressValid(EditLoopBackSubnet.Text,FALSE);
          IF Default_IP_Error.Valid Then
          Begin
               ChangeRec.LoopBack:=TRUE;
               DebugForm.EditLoopSubnet.Text:=EditLoopBackSubnet.Text;
          End else
          Begin
               NLSInavlidIPDialog(EF_Subnet);
               OkButton.ModalResult:=CmNull;
               ChangeRec.LoopBack:=False;
          End;

     End;

   Case RadioIPGateWay.ItemIndex of
   0:DebugForm.EditIPGate.Text:='IPGATE ON';
   1:DebugForm.EditIPGate.Text:='IPGATE OFF';
   End;
   //SaveProgINIFile;
End;


Procedure TTCPSpecialSettingsNotebook.TCPSpecialSettingsNotebookOnSetupShow (Sender: TObject);
VAR
   CFGFIle      : TCOnfigSysFile;
   Index        : LongInt;

Begin
      // Check if the ETC variable point to a other value as stored in config.sys
      EditLoopbackIP.Text:=DebugForm.EditLoopIP.Text;
      EditLoopbackSubnet.Text:=DebugForm.EditLoopSubnet.Text;

      Caption:=GetNlsString('TCP_Options','Caption');
      Notebook.Pages[0]:=GetNLSString('TCP_Options','TAB#1');
      Notebook.Pages[1]:=GetNlsString('TCP_Options','TAB#2');
      LabelIPRouter.Caption:=GetNLSString('TCP_Options','LabelIPRouter');
      LabelLoopBack.Caption:=GetNlsString('TCP_OPTIONS','LabelLoopback');
      RadioIPGateway.Caption:=GetNLSString('TCP_Options','RadioGatewayCaption');
      RadioIPGateway.Items[0]:=GetNlsString('TCP_Options','RadioGatewayitem#0');
      RadioIPGateway.Items[1]:=GetNlsString('TCP_Options','RadioGatewayItem#1');
      GroupLoopBack.Caption:=GetNLsString('TCP_Options','GroupLoopbackCaption');
      LabelLoopBackIP.Caption:=GetNlsString('TCP_Options','GroupLoopbackLabel#0');
      LabelLoopBackSubnet.Caption:=GetNlsString('TCP_Options','GroupLoopbackLabel#1');
      OKButton.Caption:=GetNLSString('TCP_Options','OKButton');
      CancelButton.Caption:=GetNlsString('TCP_Options','CancelButton');
      HelpButton.Caption:=GetNlsString('TCP_Options','HelpButton');
     { Edit1.Text:=TCP1.LocalIP;
      ListBox1.Items:=AliasRec[0].AliasIP;}
End;

Procedure TTCPSpecialSettingsNotebook.HilfeButtonOnClick (Sender: TObject);
Begin
       ViewHelp(HELP_Index_Settings+Notebook.PageIndex);
End;

Procedure TTCPSpecialSettingsNotebook.RadioIPGatewayOnSetupShow (Sender: TObject);
Begin
     If MyUpcaseStr(DebugForm.EditIPGate.Text)='IPGATE OFF' Then RadioIPGateWay.ItemIndex:=1 else RadioIPGateway.ItemIndex:=0;
End;


Initialization
  RegisterClasses ([TTCPSpecialSettingsNotebook, TTabbedNotebook, TButton, TRadioGroup, TLabel,
    TGroupBox, TEdit]);
End.
