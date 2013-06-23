Unit TCP_RoutingWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, TabCtrls, Buttons, ExtCtrls, Spin,Messages;

Type
  TRoutingWizard = Class (TForm)
    NoteBook1: TNoteBook;
    BackButton: TButton;
    CancelButton: TButton;
    NextButton: TButton;
    HelpButton: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    RadioConnectionType: TRadioGroup;
    GroupBoxShortInfo: TGroupBox;
    LabelConnectionInfo: TLabel;
    Label4: TLabel;
    GroupBoxParameter: TGroupBox;
    EditTargetAdress: TEdit;
    LabelTargetAdress: TLabel;
    LabelGateway: TLabel;
    EditGateway: TEdit;
    LabelMetric: TLabel;
    EditSubnetmask: TEdit;
    LabelSubnetMask: TLabel;
    SpinMetric: TSpinEdit;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    LabelWizardCaption: TLabel;
    GroupBox2: TGroupBox;
    LabelWizardCaption2: TLabel;
    Image3: TImage;
    Label5: TLabel;
    Image2: TImage;
    Label6: TLabel;
    Procedure HelpButtonOnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure RadioConnectionTypeOnClick (Sender: TObject);
    Procedure RoutingWizardOnSetupShow (Sender: TObject);
    Procedure NextButtonOnClick (Sender: TObject);
    Procedure BackButtonOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Procedure DoControls;
  Function CheckValidEntry:Boolean;
  Procedure AddNewRoutingEntrys;
  Procedure UpDateRoutingEntrys;
  Public
    {ôffent0liche Deklarationen hier einfÅgen}
  NewEntryFlag:Boolean;
  EntryIndex:longint;
  End;

Var
  RoutingWizard: TRoutingWizard;

Implementation

USES TCP_LanguageUnit,DebugUnit,TCPUtilityUnit,TCP_Check_IP_Unit,Dialogs,TCP_VAR_Unit;

Procedure TRoutingWizard.HelpButtonOnClick (Sender: TObject);
Begin
     ViewHelp(HELP_INDEX_Routing+Notebook1.PageIndex)
End;

Procedure TRoutingWizard.UpdateRoutingEntrys;
Begin
     DebugForm.LBRouteTargetAdress.Items[EntryIndex]:=EditTargetAdress.text;
     DebugForm.LBRouteGateway.Items[EntryIndex]:=EditGateway.Text;
     DebugForm.LBRouteSubnetmask.Items[EntryIndex]:=EditSubnetMask.Text;
     DebugFOrm.LBRouteHopCount.Items[EntryIndex]:=ToStr(SpinMetric.Value);
     Case RadioConnectionType.ItemIndex of
     0:DebugForm.LBRouteNetType.items[EntryIndex]:='default';
     1:DebugForm.LBRouteNetType.items[EntryIndex]:='net';
     2:DebugForm.lbRouteNetType.items[EntryIndex]:='host';
     End;
     ChangeRec.Routing:=True;
End;

Procedure TRoutingWizard.AddNewRoutingEntrys;
Begin
     DebugForm.LBRouteTargetAdress.Items.Add(EditTargetAdress.text);
     DebugForm.LBRouteGateway.Items.Add(EditGateway.Text);
     DebugForm.LBRouteSubnetmask.Items.add(EditSubnetMask.Text);
     DebugFOrm.LBRouteHopCount.Items.add(ToStr(SpinMetric.Value));
     Case RadioConnectionType.ItemIndex of
     0:DebugForm.LBRouteNetType.items.add('default');
     1:DebugForm.LBRouteNetType.items.add('net');
     2:DebugForm.lbRouteNetType.items.add('host');
     End;
     ChangeRec.Routing:=True;
End;

Function TRoutingWizard.CheckValidEntry:Boolean;
Begin
     RESULT:=FALSE;
     IF EditTargetAdress.Visible Then
     begin
          If not ValidIPAdress(EditTargetAdress.Text,ChkOpt_ZeroNotAllowed,'INVALID_TargetAdress') Then exit;
     End;

     IF EditGateway.Visible Then
     begin
          If not ValidIPAdress(EditGateway.text,ChkOpt_ZeroNotAllowed,'INVALID_Gateway') Then exit;
     End;

     IF EditSubnetMask.Visible Then
     Begin
          If not ValidIPAdress(EditSubnetMask.Text,ChkOpt_ZeroNotAllowed,'INVALID_SUBNET') Then exit;
     End;
     Result:=TRUE;
End;

Procedure TRoutingWizard.DoControls;
Begin
     Case RadioConnectionType.ItemIndex of
     0:Begin
            LabelTargetAdress.Visible:=FALSE;EditTargetAdress.Visible:=FALSE;LabelSubnetMask.Visible:=FALSE;EditSubnetMask.Visible:=FALSE;
            LabelGateway.Visible:=TRUE;EditGateway.Visible:=True;
            Label3.Caption:=GetNlsString('Routing-Wizard','Label#3')+' Default';
            EditGateway.Focus;
     end;
     1:Begin
            LabelTargetAdress.Visible:=TRUE;EditTargetAdress.Visible:=True;LabelSubnetMask.Visible:=TRUE;EditSubnetMask.Visible:=True;
            LabelGateway.Visible:=TRUE;EditGateway.Visible:=True;
            Label3.Caption:=GetNlsString('Routing-Wizard','Label#3')+' Net';
            EditTargetAdress.Focus;
       End;
     2:Begin
            LabelTargetAdress.Visible:=TRUE;EditTargetAdress.Visible:=True;LabelSubnetMask.Visible:=FALSE;EditSubnetMask.Visible:=FALSE;
            LabelGateway.Visible:=TRUE;EditGateway.Visible:=True;
            Label3.Caption:=GetNlsString('Routing-Wizard','Label#3')+' Host';
            EditTargetAdress.Focus;
       End;
     End;

End;

Procedure TRoutingWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
    Case Notebook1.PageIndex of
    0:BackButton.Enabled:=FALSE;
    1:Begin
           DoControls;BackButton.Enabled:=TRUE;
            NextButton.Caption:=GetNLSString('Routing-Wizard','Button_Next');
      End;
     2:Begin
            NextButton.Caption:=GetNLSString('Routing-Wizard','Button_Finish');
       End;
    3:Begin
         Case NewEntryFlag of
         TRUE  : AddNewRoutingEntrys;
         FALSE : UpdateRoutingEntrys;
         End;
         NextButton.ModalResult:=CmOK;
         Close;
       End;
    End;
End;

Procedure TRoutingWizard.RadioConnectionTypeOnClick (Sender: TObject);
Begin
     Case RadioConnectionType.ItemIndex of
     0:LabelConnectionInfo.Caption:=GetNLsString('Routing-Wizard','TYPE_Default');
     1:LabelConnectionInfo.Caption:=GetNLsString('Routing-Wizard','TYPE_NET');
     2:LabelConnectionInfo.Caption:=GetNLsString('Routing-Wizard','TYPE_HOST');
     End;
     NextButton.Enabled:=TRUE;

End;

Procedure TRoutingWizard.RoutingWizardOnSetupShow (Sender: TObject);
Begin
     Caption:=GetNLSString('ROUTING-Wizard','CAPTION');
     LabelWizardCaption.Caption:=GetNlsString('Routing-Wizard','WizardCaption');
     Label1.Caption:=GetNlsString('Routing-Wizard','Label#1');
     Label2.Caption:=GetNlsString('Routing-Wizard','Label#2');
     RadioConnectionType.Caption:=GetNlsString('Routing-Wizard','RadioConnType');
     GroupBoxShortInfo.Caption:=GetNLSString('Routing-Wizard','ShortInfoCaption');
     NextButton.Caption:=GetNlsString('Routing-Wizard','Button_Next');
     BackButton.Caption:=GetNlsString('Routing-Wizard','Button_Back');
     HelpButton.Caption:=GetNlsString('Routing-Wizard','Button_Help');
     RadioConnectionType.Items[0]:=GetNLsString('Routing-Wizard','ITEM_Default');
     RadioConnectionType.Items[1]:=GetNLsString('Routing-Wizard','ITEM_NET');
     RadioConnectionType.Items[2]:=GetNLsString('Routing-Wizard','ITEM_HOST');
     Label3.Caption:=GetNLSString('Routing-Wizard','Label#3');
     Label4.Caption:=GetNlsString('Routing-Wizard','label#4');
     Label5.Caption:=GetNlsString('Routing-Wizard','Label#5');
     Label6.Caption:=GetNlsString('Routing-Wizard','Label#6');
     GroupBoxParameter.Caption:=GetNLSString('Routing-Wizard','GroupBoxParameter');
     LabelTargetAdress.Caption:=GetNlsString('Routing-Wizard','TargetIP');
     LabelMetric.Caption:=GetNlsString('Routing-Wizard','Metric');
     LabelSubnetMask.Caption:=GetNlsString('Routing-Wizard','Subnet');
     LabelConnectionInfo.Caption:=GetNlsString('ROUTING-Wizard','ShortInfo');
     CancelButton.Caption:=GetNLSString('ROUTING-Wizard','Button_Cancel');
     IF NewEntryFlag Then
     Begin
          EditTargetAdress.Clear;
          EditGateway.Clear;
          SpinMetric.Value:=1500;
          EditSubnetMask.Clear;
     End else
     Begin
          IF DebugFOrm.LBRouteNetType.Items[EntryIndex]='default' Then RadioConnectionType.ItemIndex:=0;
          IF DebugForm.LBRouteNetType.Items[EntryIndex]='net' Then RadioConnectionType.ItemIndex:=1;
          IF DebugFOrm.LBRouteNetType.Items[EntryIndex]='host' Then RadioConnectionType.ItemIndex:=2;
          RadioConnectionTypeOnClick(Self);
          EditTargetAdress.Text:=DebugForm.LBRouteTargetAdress.items[EntryIndex];
          EditGateway.Text:=DebugFOrm.LBRouteGateway.items[EntryIndex];
          SpinMetric.Value:=ToInt(DebugForm.LBRouteHopCount.items[EntryIndex]);
          EditSubnetMask.Text:=DebugForm.LBRouteSubnetmask.items[EntryIndex];

     End;
End;

Procedure TRoutingWizard.NextButtonOnClick (Sender: TObject);
Begin
 IF Notebook1.PageIndex=1 Then
 begin
       IF not CheckValidEntry Then exit;
 End;
   Notebook1.PageIndex:=Notebook1.PageIndex+1;
End;

Procedure TRoutingWizard.BackButtonOnClick (Sender: TObject);
Begin
     Notebook1.PageIndex:=Notebook1.PAgeIndex-1;
End;

Initialization
  RegisterClasses ([TRoutingWizard, TGroupBox, TLabel, TNoteBook, TButton, TImage,
    TRadioGroup, TEdit, TSpinEdit]);
End.
