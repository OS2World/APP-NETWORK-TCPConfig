{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
 ∫                                                                          ∫
 ∫     Interface IP-Setup Wizard                                            ∫
 ∫                                                                          ∫
 ∫     Version 2 04.10.2005                                                 ∫
 ∫     Zulest geÑndert am 06.10.2006                                        ∫
 ∫                                                                          ∫
 »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}
Unit TCP_NewIPWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, ExtCtrls, TabCtrls, Buttons, Spin,
  ComCtrls,Messages,ustring,PMWIn, Menus,DOS;

Type
  TAliasHelpWizard = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    OKButton: TButton;
    ButtonCancel: TButton;
    cbHomeIP: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    GroupBox1: TGroupBox;
    EditSubnet: TEdit;
    GroupBox2: TGroupBox;
    EditIP: TEdit;
    Procedure cbHomeIPOnClick (Sender: TObject);
    Procedure TabbedNotebook1OnSetupShow (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure AliasHelpWizardOnSetupShow (Sender: TObject);
    Procedure TabbedNotebook1OnPageChanged (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Function IPAlreadyUsed:Boolean;
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  AddMode:Boolean; // TRUE if a New IP should be added, FALSE if a existing IP should be edited
  //InterfaceIndex:Byte;
  End;

Type
  TNewIPWizard = Class (TForm)
    ButtonNext: TButton;
    NoteBook1: TNoteBook;
    AliasBox: tMultiColumnList;
    ButtonAliasAdd: TButton;
    ButtonALiasEdit: TButton;
    ButtonAliasDelete: TButton;
    ButtonCancel: TButton;
    ButtonHelp: TButton;
    LabelFinish4: TLabel;
    LabelFinish5: TLabel;
    LabelFinish6: TLabel;
    Tab1Caption: TLabel;
    Tab1Info: TLabel;
    Tab2Caption: TLabel;
    Tab2Info: TLabel;
    Image5: TImage;
    GroupBox9: TGroupBox;
    GroupBox7: TGroupBox;
    Tab0Caption: TLabel;
    Tab0Info: TLabel;
    Tab0Caption1: TLabel;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox1: TGroupBox;
    LabelInfo2: TLabel;
    Label1: TLabel;
    ButtonBack: TButton;
    DebugButton: TButton;
    LabelAttentionNote: TLabel;
    LabelHomeIP: TLabel;
    GrpBoxDHCP: TGroupBox;
    SpinEditDHCPTime: TSpinEdit;
    GrpBoxAttribute: TGroupBox;
    ButtonManualSetupFinish: TBitBtn;
    PopupMenu1: TPopupMenu;
    MenuItemMoveUp: TMenuItem;
    MenuItemMoveDown: TMenuItem;
    TabbedNotebook1: TTabbedNotebook;
    EditBroadcast:TEdit;
    RadioIPSelect:TRadioGroup;
    EditTargetAdress:TEdit;
    SpinMTUSize:TSpinEdit;
    SpinMetricSize:TSpinEdit;
    CheckBox1:TCheckBox;
    CheckBox2:TCheckBox;
    CheckBox3:TCheckBox;
    CheckBox4:TCheckBox;
    CheckBox5:TCheckBox;
    CheckBox6:TCheckBox;
    CheckBox7:TCheckBox;
    CheckBox8:TCheckBox;
    Label2:TLabel;
    Label3:TLabel;
    Label5:TLabel;
    LabelMTUSize:TLabel;
    LabelBroadcast:TLabel;
    LabelMetricSize:TLabel;
    GrpBoxIP:TLabel;
    LabelDestinAdress:TLabel;
    Procedure DebugButtonOnClick (Sender: TObject);
    Procedure CheckBox8OnClick (Sender: TObject);
    Procedure CheckBox7OnClick (Sender: TObject);
    Procedure CheckBox6OnClick (Sender: TObject);
    Procedure CheckBox5OnClick (Sender: TObject);
    Procedure CheckBox4OnClick (Sender: TObject);
    Procedure CheckBox1OnClick (Sender: TObject);
    Procedure CheckBox3OnClick (Sender: TObject);
    Procedure CheckBox2OnClick (Sender: TObject);
    Procedure ButtonManualSetupFinishOnClick (Sender: TObject);
    Procedure TabbedNotebook1OnPageChanged (Sender: TObject);
    Procedure ButtonBackOnClick (Sender: TObject);
    Procedure MenuItemMoveDownOnClick (Sender: TObject);
    Procedure PopupMenu1OnPopup (Sender: TObject);
    Procedure MenuItemMoveUpOnClick (Sender: TObject);
    Procedure ButtonAliasDeleteOnClick (Sender: TObject);
    Procedure AliasBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure NewIPWizardOnDestroy (Sender: TObject);
    Procedure NewIPWizardOnCreate (Sender: TObject);
    Procedure ButtonALiasEditOnClick (Sender: TObject);
    Procedure ButtonAliasAddOnClick (Sender: TObject);
    Procedure TabbedNotebook1OnSetupShow (Sender: TObject);
    Procedure ButtonCancelOnClick (Sender: TObject);
    Procedure ButtonHelpOnClick (Sender: TObject);
    Procedure RadioIPSelectOnClick (Sender: TObject);
    Procedure ButtonNextOnClick (Sender: TObject);
    Procedure EditIPAdress1OnChange (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure NewIPWizardOnSetupShow (Sender: TObject);
    Procedure DrawAliasItems;
    Procedure Copy;
    Procedure SaveIPAdresses;
    Procedure LanguageSettings;
    Function FIndHomeIP:Integer;
  Private
    {Private Deklarationen hier einfÅgen}

  Public
    {ôffentliche Deklarationen hier einfÅgen}
  NewEntryFlag:Boolean;
  EntryIndex:Byte;

  Procedure ClearAll;
  Procedure StoreSettings;
  Procedure AddSettings;
  Procedure SetupSettings;
  Procedure ClearTempAlias;
  Procedure StoreTempAlias;
  Function  CheckDuplicateIP:Boolean;
  Procedure TabbedNotebook1LanguageCaption;
  End;

Var
  NewIPWizard: TNewIPWizard;
  LanNum     : Byte; // Number of new LAN Interface
  AliasHelpWizard: TAliasHelpWizard;
  HasChanged:Boolean;               // Indicates if something has changed
  FInishCaption:String;
  Imports
  Procedure DLLExec(FileName,Parameter:String); 'TCPLIB' NAME 'DLLExecutePrg';
  procedure IFConfig2(LAN_Num:Byte;Running:Boolean); 'TCPLIB' NAME 'QueryIFConfig2';
  End;

Implementation


USES TCP_Var_Unit,Dialogs,DEBUGUnit,TCPUtilityUnit,MyMessageBoX,TCP_LanguageUnit,TCP_Check_IP_Unit,TCP_Unit_QueryEntrys,tcp_iniFiles;

CONST S1='Interface-Wizard';
VAR
   ICO_IP:TIcon;
   ICO_Attn:TIcon;
   ICO_Subnet:TIcon;
   Ini:TOs2UserIniFile;
   ss:longint;
   TempAlias:TAliasRec;
   DHCP_MODE:Boolean;  // TRUE if USER select DHCP , FALSE if user select manualy config

{$R FOrmWizard}


Procedure TAliasHelpWizard.cbHomeIPOnClick (Sender: TObject);
Begin
     IF cbHomeIP.checked Then
     Begin
          Image1.Bitmap:=ICO_Attn;
          Image2.Bitmap:=ICO_Attn;
     End
        else
     Begin
          Image1.Bitmap:=ICO_IP;
          Image2.Bitmap:=ICO_IP;
     End;
End;

Procedure TAliasHelpWizard.TabbedNotebook1OnSetupShow (Sender: TObject);
Begin
{      Image1.Bitmap:=ICO_IP;
      Image2.Bitmap:=ICO_IP;}
End;

Function TAliasHelpWizard.IPAlreadyUsed:Boolean;
{
checks if the entered IP is already setuped before
Result is TRUE if the IP is already setuped, FALSE if not setuped
02.10.2006
}
VAR Loop:Byte;
    ResultStr:String;
Begin
     IF NewIPWizard.AliasBox.Items.count=0 Then Begin Result:=FALSE;exit;End;
     For Loop:=0 to NewIPWizard.AliasBox.items.count-1 do
     Begin
          ResultStr:=NewIPWizard.AliasBox.Values[1,Loop];
          IF ResultStr=EditIP.Text Then
          Begin
               Result:=True;
               NLSInfoBox('IPAlreadyAssigned');
               Exit;
          End;
     End;
     Result:=FALSE;
End;

Procedure TAliasHelpWizard.OKButtonOnClick (Sender: TObject);

Begin
     // check if IP Adress is valid
     If not ValidIpAdress(EditIP.Text,ChkOpt_ZeroNotAllowed,'INVALID_IP_Address') Then Begin OKButton.ModalResult:=CmNull;Exit;End else OkButton.ModalResult:=cmOK;
     // check if Subnet is valid
     If not ValidIpAdress(EditSubnet.Text,ChkOpt_ZeroNotAllowed,'INVALID_Subnet') Then Begin OKButton.ModalResult:=CmNull;Exit;End else OkButton.ModalResult:=cmOK;
     // check if IP and Subnet are the same
     IF EditiP.Text=EditSubnet.Text Then Begin NLSInfoBox('SAME_IP_and_Subnet');OKButton.ModalResult:=cmNull;End;
     {Check if IP was already setuped}
     IF AddMode Then IF IPAlreadyUsed Then OKButton.ModalResult:=CmNull;

     IF AliasHelpWizard.cbHomeIP.checked Then
     Begin
          NewIPWizard.AliasBox.Values[0,NewIPWizard.AliasBox.ItemIndex]:='HOME=TRUE';
     End else
     Begin
          NewIPWizard.AliasBox.Values[0,NewIPWizard.AliasBox.ItemIndex]:='HOME=FALSE';
     End;


End;


Procedure TAliasHelpWizard.AliasHelpWizardOnSetupShow (Sender: TObject);
Begin
     EditIP.Focus;
     Caption:=GetNlsString(Self.Name,'Caption');

     TabbedNotebook1.Pages[0]:=GetNlsString(Self.Name,'IPAdress');
     TabbedNotebook1.Pages[1]:=GetNlsString(Self.Name,'Subnet');

     OkButton.Caption:=GetNlsString(Self.Name,'Ok');
     ButtonCancel.Caption:=GetNlsString(Self.Name,'Cancel');

     IF (TempAlias.HomeIP=EditIP.Text) and (TempAlias.HomeIP<>'') Then
     Begin
          cbHomeIP.checked:=True;
          Image1.Bitmap:=ICO_Attn;
          Image2.Bitmap:=ICO_Attn;
     End
     else
         Begin
         cbHomeIP.checked:=FALSE;
         Image1.Bitmap:=ICO_IP;
         Image2.Bitmap:=ICO_IP;
     End;

     IF NewIPWizard.AliasBox.items.count>0 Then cbHomeIP.Visible:=TRUE
                                           else cbHomeIP.Visible:=FALSE;
End;

Procedure TAliasHelpWizard.TabbedNotebook1OnPageChanged (Sender: TObject);
Begin
     Case TabbedNotebook1.PageIndex of
     0:Begin EditIP.Focus;End;
     1:EditSubNet.Focus;
     End;
End;

Function GetInterfaceName:String;
VAR IF_Loop:Byte;IF_Str:String;Index:longint;
Begin
     For IF_Loop:=0 to 7 do
     Begin
          IF_Str:='LAN'+ToStr(IF_Loop);
          Index:=DebugForm.LBIPSetupLanNum.Items.Indexof(IF_Str);
          IF Index=-1 Then Begin Result:='lan'+ToStr(IF_loop);exit;End;
     End;
End;




Procedure TNewIPWizard.TabbedNotebook1LanguageCaption;
Begin
     Case DHCP_MODE of
     TRUE:Begin
               TabbedNotebook1.Pages[0]:=GetNlsString(S1,'Tab#2');
               TabbedNotebook1.Pages[1]:=GetNlsString(S1,'Tab#5');
          End;
     FALSE:Begin
                TabbedNotebook1.Pages[0]:=GetNlsString(S1,'Tab#1');
                IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=0 Then
                Begin
                     TabbedNotebook1.Pages[1]:=GetNlsString(S1,'Tab#5');
                     Exit;
                End;

                TabbedNotebook1.Pages[1]:=GetNlsString(S1,'Tab#3');
                TabbedNotebook1.Pages[2]:=GetNlsString(S1,'Tab#4');
                TabbedNotebook1.Pages[3]:=GetNlsString(S1,'Tab#5');
           End;
     End;
End;

Procedure TNewIPWizard.DebugButtonOnClick (Sender: TObject);
Begin
     DebugForm.ShowModal;
End;


Procedure TNewIPWizard.CheckBox8OnClick (Sender: TObject);
Begin
  if checkbox8.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' canonical')
                        else
  Begin
       DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -canonical');
       //ShowMessage('Done');
  End;
End;

Procedure TNewIPWizard.CheckBox7OnClick (Sender: TObject);
Begin
  if checkbox7.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' 802.3')
                       else
  Begin
       DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -802.3');
       //ShowMessage('Done -802.3');
  End;

End;

Procedure TNewIPWizard.CheckBox6OnClick (Sender: TObject);
Begin
    if checkbox6.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' trailers')
                        else DllExec('ifconifg.exe','lan'+ToStr(EntryIndex)+' -trailers');
End;

Procedure TNewIPWizard.CheckBox5OnClick (Sender: TObject);
Begin
   if checkbox5.checked then
      Begin
           DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -bridge');
           //ShowMessage('Brdige off');
           End else
           Begin
           DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' bridge');
           //ShowMessage('Brdige on');
           End;
End;

Procedure TNewIPWizard.CheckBox4OnClick (Sender: TObject);
Begin
     Ini.Create;
     IF Ini.ReadString('Interface#'+toStr(EntryIndex),'POINT2POINT','-1')='0' Then
     Begin
          NLSErrorBox('POINT2POINT');
          IF CheckBox4.checked then Begin checkbox4.checked:=FALSE;End;
          exit;
     End;
     IF Ini.ReadString('Interface#'+toStr(EntryIndex),'POINT2POINT','-1')='-1' Then Begin MyErrorBox('Program Error ! Section "Interface#" or "Point2Point" missing in OS2User.ini !');Halt;End;
     IF checkBox4.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -snap')
                          else DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' snap');
     Ini.Destroy;
End;

Procedure TNewIPWizard.CheckBox1OnClick (Sender: TObject);
Begin
   if checkbox1.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -allrs')
                        else DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' allrs')
End;

Procedure TNewIPWizard.CheckBox3OnClick (Sender: TObject);
Begin
  if checkbox3.checked then DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' -icmpred')
                       else DllExec('ifconfig.exe','lan'+ToStr(EntryIndex)+' icmpred');
End;

Procedure TNewIPWizard.CheckBox2OnClick (Sender: TObject);
{ARP Enable / DISABLE }
Begin
     IF checkbox2.checked then DllExec('ifconfig.EXE','lan'+ToStr(EntryIndex)+' -arp')
                          else DllExec('IFCONFIG.EXE','lan'+ToStr(EntryIndex)+' arp');

End;

Function TNewIPWizard.FindHomeIP:Integer;
VAR Loop:Byte;
Begin
     IF AliasBox.Items.count=0 then exit;
     For Loop:=0 to AliasBox.Items.count-1 do
     Begin
          IF ALiasBox.Values[0,loop]='HOME=TRUE' Then Begin Result:=Loop;exit;End;
     end;
Result:=-1;
ENd;


Procedure TNewIPWizard.ButtonManualSetupFinishOnClick (Sender: TObject);
Begin

     {Check if at least 1 ip is setuped in manual mode}
     IF not DHCP_MODE Then
     Begin
          IF ALiasBox.Items.count=0 Then Begin NLSInfoBox('IPAdress_Missing');ButtonManualSetupFinish.ModalResult:=cmNUll;Exit;End
                                    else ButtonManualSetupFinish.ModalResult:=cmOK;
     End;

    AliasRec.HomeIP:=TempAlias.HomeIP;
    AliasRec.HomeSubnet:=TempAlias.HomeSubnet;

    IF NewEntryFlag then AddSettings else StoreSettings;

    HasChanged:=TRUE;
End;

Procedure TNewIPWizard.TabbedNotebook1OnPageChanged (Sender: TObject);
Begin
     //ShowMessage(ToStr(TabbedNotebook1.PageIndex));
     Case TabbedNotebook1.PageIndex of
     0:Begin ButtonNext.Enabled:=TRUE;ButtonBack.Enabled:=FALSE;End;
     1:Begin
             ButtonBack.Enabled:=TRUE;
             IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=0 Then
             ButtonNext.Enabled:=FALSE
             else ButtonNext.Enabled:=True;
             IF DHCP_MODE Then ButtonNext.Enabled:=FALSE;
     End;
     2:Begin
            //IF DHCP_MODE Then ButtonNext.Enabled:=FALSE;
       End;
     3:ButtonNext.Enabled:=FALSE;
     End;
End;

Procedure TNewIPWizard.PopupMenu1OnPopup (Sender: TObject);
Begin
     IF AliasBox.ItemIndex=-1 Then
     Begin
          MenuItemMoveUp.Enabled:=FALSE;
          MenuItemMoveDown.Enabled:=FALSE;
     End else
     Begin
          MenuItemMoveUp.Enabled:=TRUE;
          MenuItemMoveDown.Enabled:=TRUE;
     End;
End;

Procedure TNewIPWizard.MenuItemMoveUpOnClick (Sender: TObject);
Begin
     IF AliasBox.ItemIndex>0 Then
     Begin
          AliasBox.Items.Move(AliasBox.ItemIndex,AliasBox.ItemIndex-1);
          ButtonALiasEdit.Enabled:=FALSE;
          ButtonAliasDelete.Enabled:=FALSE;
          StoreTempAlias;
          DrawAliasItems;
     End;
End;

Procedure TNewIPWizard.MenuItemMoveDownOnClick (Sender: TObject);
Begin
     IF AliasBox.ItemIndex+1<AliasBox.items.count Then
     Begin
          AliasBox.Items.Move(AliasBox.ItemIndex,AliasBox.ItemIndex+1);
          ButtonALiasEdit.Enabled:=FALSE;
          ButtonAliasDelete.Enabled:=FALSE;
          StoreTempAlias;
          DrawAliasItems;
     End;
End;

Procedure TNewIPWizard.ButtonAliasDeleteOnClick (Sender: TObject);
VAR Index:longint;
Begin
     ButtonAliasDelete.Enabled:=FALSE;
     ButtonAliasEdit.Enabled:=FALSE;

     Index:=ALiasbox.itemindex;

     IF TempAlias.HomeIp=AliasBox.Values[1,Index] Then TempAlias.HomeIP:='';


     AliasBox.Delete(Index);
     TempAlias.AliasIP[ENtryIndex].Delete(Index);
     TempAlias.AliasSubnet[EntryIndex].Delete(Index);

     DrawAliasItems;
     HasChanged:=True;
End;

Procedure TNewIPWizard.AliasBoxOnItemFocus (Sender: TObject; Index: LongInt);
Begin
     ButtonAliasEdit.Enabled:=TRUE;
     ButtonAliasDelete.Enabled:=True;
End;

Procedure TNewIPWizard.NewIPWizardOnDestroy (Sender: TObject);
VAR Loop:Byte;
Begin
     ICO_IP.Destroy;
     ICO_Attn.Destroy;
     ICO_Subnet.Destroy;
     For Loop:=0 to 7 do
     begin
     TempALias.AliasIP[loop].Destroy;
     TempALias.AliasSubnet[loop].Destroy;
     End;
End;

Procedure TNewIPWizard.NewIPWizardOnCreate (Sender: TObject);
VAR Loop:Byte;
Begin
    ICO_IP.Create;
    ICO_Attn.Create;
    ICO_Subnet.Create;
    ICO_IP.LoadFromResourceName('IpWorld');
    ICO_Attn.LoadFromResourceName('Info');
    ICO_Subnet.LoadFromResourceName('Subnet');
    FOr Loop:=0 to 7 do
    Begin
         TempALias.AliasIP[loop]:=TStringlist.Create;
         TempALias.AliasSubnet[loop]:=TStringlist.Create;
    End;
End;

Procedure TNewIPWizard.ButtonALiasEditOnClick (Sender: TObject);
VAR RC:Longint;
Begin
     AliasHelpWizard.Create(Self);
     AliasHelpWizard.AddMode:=FALSE;

     //Setup IP and subnet
     AliasHelpWizard.EditIP.Text:=AliasBox.Values[1,AliasBox.ItemIndex];
     AliasHelpWizard.EditSubNet.Text:=AliasBox.Values[2,AliasBox.ItemIndex];

     IF AliasHelpWizard.ShowModal=cmOK Then
     Begin
          // Store IP and subnet
          TempAlias.AliasIP[EntryIndex][AliasBox.ItemIndex]:=AliasHelpWizard.EditIP.Text;
          TempAlias.AliasSubnet[EntryIndex][AliasBox.ItemIndex]:=AliasHelpWizard.EditSubnet.Text;
          HasChanged:=True;
          LabelHomeIP.Caption:=AliasBox.Values[0,AliasBox.ItemIndex];

          //ShowMessage(ToStr(FindHomeIP));
          IF AliasBox.Values[0,AliasBox.ItemIndex]='HOME=TRUE' Then
          Begin
               TempALias.HomeIP:=AliasHelpWizard.EditIP.Text;
               TempALias.HomeSubnet:=AliasHelpWizard.EditSubnet.Text;
          End else
          Begin
               TempALias.HomeIP:='';
               TempALias.HomeSubnet:='';
          End;
          DrawAliasItems;
     End;
     AliasHelpWizard.Destroy;

End;

Procedure TNewIPWizard.ButtonAliasAddOnClick (Sender: TObject);
Begin
     AliasHelpWizard.Create(Self);
     AliasHelpWizard.AddMode:=True;
     IF AliasHelpWizard.ShowModal=cmOK Then
     Begin
          AliasBox.AddObject('Dummy|'+AliasHelpWizard.EditIP.Text+'|'+AliasHelpWizard.EditSubnet.Text,ICO_IP);
          TempAlias.AliasIP[EntryIndex].Add(AliasHelpWizard.EditIP.Text);
          TempAlias.AliasSubnet[EntryIndex].Add(AliasHelpWizard.EditSubnet.Text);
          IF AliasHelpWizard.cbHomeIP.checked Then
          Begin
               TempAlias.HomeIP:=ALiasHelpWizard.EditIP.Text;
               TempAlias.HomeSubnet:=ALiasHelpWizard.EditSubnet.Text;
               HasChanged:=TRUE;
          End;
          DrawAliasItems;
     End;
     AliasHelpWizard.Destroy;

End;

Procedure TNewIPWizard.TabbedNotebook1OnSetupShow (Sender: TObject);
Begin

End;

Function TNewIPWizard.CheckDuplicateIP;
VAR Index:Longint;
Begin
        {Index:=BoxAliasIP.Items.Indexof(EditIPAdress.Text);
        IF Index<>-1 Then
                         Begin
                              Result:=TRUE;TabbedNotebook1.PageIndex:=0;NlsInfoBox('IPAlreadyAssigned');
                         End
                     else Result:=FALSE;}
End;



Procedure TNewIPWizard.ButtonCancelOnClick (Sender: TObject);
Begin

End;

Procedure TNewIPWizard.ButtonHelpOnClick (Sender: TObject);
Begin
     IF Notebook1.PageIndex=4 Then ViewHelp(Help_Index_Interface+5) else
     IF Notebook1.PageIndex=0 Then ViewHelp(HELP_INDEX_INTERFACE);
     IF Notebook1.PageIndex=1 Then ViewHelp(Help_Index_Interface+TabbedNotebook1.PageIndex+1);
End;




Procedure TNewIPWizard.RadioIPSelectOnClick (Sender: TObject);
Begin
     ButtonNext.Enabled:=TRUE;
End;


Procedure TNewIPWizard.ClearAll;
Begin
     //IF ProgramSettings.ConfigLevel=1 Then
     IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=1 Then;
     Begin
          EditBroadcast.Clear;
          EditTargetAdress.Clear;
          SpinMTUSize.value:=1500;
          SpinMetricSize.Value:=1;
          CheckBox1.Checked:=FALSE;
          CheckBox2.Checked:=FALSE;
          CheckBox3.Checked:=FALSE;
          CheckBox4.Checked:=FALSE;
          CheckBox5.Checked:=FALSE;
          CheckBox6.Checked:=FALSE;
          CheckBox7.Checked:=FALSE;
          CheckBox8.Checked:=FALSE;
    End;
End;



Procedure TNewIPWizard.DrawAliasItems;
VAR aLoop:Byte;
    Test:String;
Begin

     IF TempAlias.AliasIP[EntryIndex].count=0 Then exit;
     AliasBox.Clear;
     For aLoop:=0 to TempAlias.AliasIP[EntryIndex].count-1 do
     Begin
          Test:=TempALias.HomeIp;
          Test:=TempAlias.AliasIP[EntryIndex][aloop];

          IF TempAlias.HomeIp=TempAlias.AliasIP[EntryIndex][aloop] Then
          Begin
               TRY
               AliasBox.AddObject('HOME=TRUE|'+TempAlias.AliasIP[EntryIndex][aLoop]+'|'+TempAlias.AliasSubnet[EntryIndex][aLoop],ICO_ATTN);
               Except Raise  EInvalidCast.Create('Fehler');
               End;
          End
          else
          Begin
               TRY
               AliasBox.AddObject('HOME=FALSE|'+TempAlias.AliasIP[EntryIndex][aLoop]+'|'+TempAlias.AliasSubnet[EntryIndex][aLoop],ICO_IP);
               Except Raise EInvalidCast.Create('Exception in Unit NewIPWizard_Unit bei DrawAliasItems'+#13+'Fehler bei zugriff auf TempAlias Record');
               End;
          End;

     End;
End;

Procedure TNewIPWizard.ClearTempAlias;
VAR Loop:Byte;
Begin
     For Loop:=0 to 7 do
     BEgin
          TempAlias.AliasIP[EntryIndex].Clear;
          TempAlias.AliasSubnet[EntryIndex].clear;
     End;
     //AliasBox.Clear;
End;

Procedure TNewIPWizard.StoreTempAlias;
VAR Loop:Byte;
Begin
      ClearTempAlias;
       For Loop:=0 to AliasBox.Items.count-1 do
       begin
            TempAlias.AliasIP[EntryIndex].add(AliasBox.Values[1,loop]);
            TempAlias.AliasSubnet[EntryIndex].Add(AliasBox.Values[2,loop]);
       End;
End;

Procedure TNewIPWizard.Copy;
VAR Loop:Byte;
Begin
     {TempALias[EntryIndex].AliasIP.Clear;
     TempALias[EntryIndex].AliasSubnet.Clear;}

     {TempALias.AliasIP[EntryIndex]:=TStringlist.Create;
     TempALias.AliasSubnet[EntryIndex]:=TStringlist.Create;}

     TempAlias.HomeIP:=AliasRec.HomeIP;
     TempAlias.HomeSubnet:=AliasRec.HomeSubnet;

     IF AliasRec.ALiasIP[EntryIndex].count=0 Then exit;

     FOr Loop:=0 to AliasRec.AliasIP[EntryIndex].count-1 do
     Begin
          TRY
          TempAlias.AliasIP[EntryIndex].add(AliasRec.AliasIP[EntryIndex][Loop]);
          Except Begin Raise  EInvalidCast .Create('Fehler in NewIPWizard_Unit ! Konnte nicht auf Feld "AliasRec.AliasIP" zugreifen');Halt;End;
          End;

          TRY
          TempAlias.AliasSubnet[EntryIndex].add(AliasRec.AliasSubnet[EntryIndex][Loop]);
          Except Begin Raise  EInvalidCast .Create('Fehler in NewIPWizard_Unit ! Konnte nicht auf Feld "AliasRec.AliasSubnet" zugreifen');Halt;End;
          End;
     End;

End;

Procedure TNewIPWizard.SetupSettings;
VAR
   TmpHelp:TStringList;
   aLoop:Longint;
   Test:String;

Begin
     IF DebugForm.LBIpSetupIPAdress.items[EntryIndex]<>'DHCP-Auto' Then RadioIPSelect.ItemIndex:=1 else Begin RadioIPSelect.ItemIndex:=0;Exit;END;


     TempAlias.AliasIP[EntryIndex].Add(DebugForm.lbIPSetupIPAdress.items[EntryIndex]);
     TempAlias.AliasSubnet[EntryIndex].add(DebugForm.LBIPSetupSubnetmask.items[EntryIndex]);

     copy;

    { TempAlias.HomeIP:=DebugForm.LBIpSetupIPAdress.items[EntryIndex];
     TempAlias.HomeSubnet:=DebugForm.LBIpSetupSubnetmask.items[EntryIndex];}

     //showMessage(ToStr(TempALias.AliasIP[EntryIndex].count));
     DrawAliasItems;

     {For aLoop:=0 to AliasRec[EntryIndex].AliasIP.count-1 do
     Begin
          IF ProgramSettings.EditFixedAliasIP=AliasRec[EntryIndex].AliasIP[aloop] Then AliasBox.AddObject('Dummy|'+AliasRec[EntryIndex].AliasIP[aLoop]+'|'+AliasRec[EntryIndex].AliasSubnet[aLoop],ICO_ATTN)
                                                                                  else AliasBox.AddObject('Dummy|'+AliasRec[EntryIndex].AliasIP[aLoop]+'|'+AliasRec[EntryIndex].AliasSubnet[aLoop],ICO_IP);
     End;}

     With DebugForm do
     Begin
           {TmpHelp.Create;
           MakeAliasMultiString(EntryIndex,TmpHelp);
           AliasBox.Items:=TmpHelp;
           TmpHelp.Destroy;}



           //IF ProgramSettings.ConfigLevel=1 Then
           IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=1 Then
           Begin
                EditBroadcast.Text:=LBIpSetupBroadcast.items[EntryIndex];
                EditTargetAdress.Text:=LBIPSetupTargetAdress.Items[EntryIndex];
                IF EditBroadcast.Text='Nil' Then EditBroadcast.Clear;
                IF EditTargetAdress.Text='Nil' Then EditTargetAdress.Clear;

                   LBIPSetupTargetAdress.Text:=LBIPSetupTargetAdress.items[EntryIndex];
                   SpinMtuSize.Value:=ToInt(LBIPSetupMTU.items[EntryIndex]);
                   SpinMetricSize.Value:=ToInt(LBIPSetupMetric.items[EntryIndex]);
                   SpinEditDHCPTime.Value:=ToInt(LBIpSetupDHCPTime.items[EntryIndex]);

                IF LBSpSettingsALLRS.items[EntryIndex]='true' Then CheckBox1.Checked:=True else CheckBox1.Checked:=FALSE;
                IF lbSpSettingsARP.items[EntryIndex]='true' Then CheckBox2.Checked:=True else CheckBox2.Checked:=FALSE;
                IF lbSpSettingsICMPRED.items[EntryIndex]='true' Then CheckBox3.Checked:=True else CheckBox3.Checked:=FALSE;
                IF lbSpSettingsSNAP.items[EntryIndex]='true' Then CheckBox4.Checked:=True else CheckBox4.Checked:=FALSE;
                IF lbSpSettingsBRIDGE.items[EntryIndex]='true' Then CheckBox5.Checked:=True else CheckBox5.Checked:=FALSE;
                IF LBSpSettingstrailers.items[EntryIndex]='true' Then CheckBox6.Checked:=True else CheckBox6.Checked:=FALSE;
                IF lbSpSettings802.items[EntryIndex]='true' Then CheckBox7.Checked:=True else CheckBox7.Checked:=FALSE;
                IF lbSpSettingsCANONICAL.items[EntryIndex]='true' Then CheckBox8.Checked:=True else CheckBox8.Checked:=FALSE;
            End;
           ButtonNext.Enabled:=TRUE;
     End;
End;


Procedure TNewIPWizard.EditIPAdress1OnChange (Sender: TObject);
Begin

End;

Procedure TNewIPWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
    Case Notebook1.PageIndex of
    0:Begin
           //IF RadioIPSelect.ItemIndex<>-1 Then Begin ButtonNext.enabled:=True;End;
           ButtonBack.Enabled:=FALSE;
      End;
    1:Begin

           Case RadioIPSelect.ItemIndex of
           0:Begin
                  DHCP_MODE:=TRUE;
                  TabbedNotebook1.Pages.delete(0); // Lîsche IP öbersicht
                  TabbedNotebook1.Pages.Delete(1); // Lîsche "erweitert-1"
                  TabbedNotebook1.Pages.Delete(1); // Lîsche "erweirter-2"
                  TabbedNotebook1.PageIndex:=1;
                  TabbedNotebook1.PageIndex:=0;
           End;
           1:Begin
                  DHCP_MODE:=FALSE;
                  TabbedNotebook1.Pages.delete(1);// Lîsche DHCP
                  IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=0 Then
                  Begin
                       // Einfacher Modus hat keine "erweiterte" Seiten
                       TabbedNotebook1.Pages.Delete(1); // Lîsche "Erweitert1"
                       TabbedNotebook1.Pages.Delete(1); // Lîsche "Erweitert2"
                  End;
             End;
           End;
           TabbedNotebook1LanguageCaption;
      End;
    End;
End;


Procedure TNewIPWizard.ButtonBackOnClick (Sender: TObject);
Begin
  SS:=Notebook1.PageIndex;
  Case Notebook1.PageIndex of
  0:Notebook1.PageIndex:=0;
  1:Begin
         IF TabbedNotebook1.PageIndex-1=-1 Then Begin Notebook1.PageIndex:=0;Exit;End;
         TabbedNotebook1.PageIndex:=TabbedNotebook1.PageIndex-1;
    End;
  End;
End;

Procedure TNewIPWizard.ButtonNextOnClick (Sender: TObject);
Begin
  Case Notebook1.PageIndex of
  0:Notebook1.PageIndex:=1;
  1:TabbedNotebook1.PageIndex:=TabbedNotebook1.PageIndex+1;
  End;

End;


Procedure TNewIPWizard.LanguageSettings;
Begin
    Caption:=GetNlsString(S1,'Caption');
    //LabelInfo.Caption:=GetNLSString(S1,'LabelInfo');
    ButtonManualSetupFinish.Caption:=GetNlsString(S1,'ButtonFinish');
    Label1.Caption:=GetNlsString(S1,'Label#1');
    Label2.Caption:=GetNlsString(S1,'Label#2');
    Label3.Caption:=GetNlsString(S1,'Label#3');
    ButtonBack.Caption:=GetNlsString(S1,'ButtonBack');
    ButtonNext.Caption:=GetNLSString(S1,'ButtonNext');
    ButtonCancel.Caption:=GetNlsString(S1,'ButtonCancel');
    ButtonHelp.Caption:=GetNlsString(S1,'ButtonHelp');
    LabelAttentionNote.Caption:=GetNlsString(S1,'LabelAttentionNote');
    {LabelFinish1.Caption:=GetNlsString(S1,'LabelFin1');
    LabelFinish2.Caption:=GetNlsString(S1,'LabelFin2');
    LabelFinish3.Caption:=GetNlsString(S1,'LabelFin3');}
    {LabelDHCPFin1.Caption:=GetNlsString(S1,'LabelFin1');
    LabelDHCPFin2.Caption:=GetNlsString(S1,'LabelFin4');}
    RadioIPSelect.Caption:=GetNLSString(S1,'RadioCaption');
    GrpBoxDHCP.Caption:=GetNLsString(S1,'GrpBoxDHCP');
    RadioIPSelect.Items[0]:=GetNlsString(S1,'RadioItem#0');
    RadioIPSelect.Items[1]:=GetNlsString(S1,'RadioItem#1');
    ButtonAliasAdd.Caption:=GetNlsString(S1,'ButtonAliasIPAdd');
    ButtonAliasDelete.Caption:=GetNlsString(S1,'ButtonALiasIPDel');
    ButtonAliasEdit.Caption:=GetNlsString(S1,'ButtonAliasIPEdit');
    AliasBox.Sections[0].Text:=GetNlsString(S1,'Icon');
    AliasBox.Sections[1].Text:=GetNlsString(S1,'AliasIP');
    AliasBox.Sections[2].Text:=GetNlsString(S1,'AliasSubnet');
    MenuItemMoveUp.Caption:=GetNlsString('Popup_Menu','Popup_Moveup');
    MenuItemMoveDown.Caption:=GetNlsString('Popup_Menu','Popup_Movedown');
    Tab0Caption.Caption:=GetNlsString(S1,'TAB#0Caption');
    TAB0Info.Caption:=GetNLSString(S1,'TAB#0Caption');
    LabelFinish4.Caption:=GetNlsString(S1,'LabelFin1');
    LabelFinish5.Caption:=GetNlsString(S1,'LabelFin2');
    LabelFinish6.Caption:=GetNlsString(S1,'LabelFin3');
    Label5.Caption:=GetNlsString(S1,'Label#5');
    {Label6.Caption:=GetNlsString(S1,'Label#6');}
    Label7.Caption:=GetNlsString(S1,'Label#7');
    LabelBroadcast.Caption:=GetNLSString(S1,'LabelBroadcast');
    LabelDestinAdress.Caption:=GetNLSString(S1,'LabelDestinAdress');
    LabelMTUSize.Caption:=GetNLSString(S1,'LabelMTUSize');
    LabelMetricSize.Caption:=GetNlsString(S1,'LabelMetricSize');
    CheckBox1.Caption:=GetNlsString(S1,'CheckBox1');
    CheckBox2.Caption:=GetNlsString(S1,'CheckBox2');
    CheckBox3.Caption:=GetNlsString(S1,'CheckBox3');
    CheckBox4.Caption:=GetNlsString(S1,'CheckBox4');
    CheckBox5.Caption:=GetNlsString(S1,'CheckBox5');
    CheckBox6.Caption:=GetNlsString(S1,'CheckBox6');
    CheckBox7.Caption:=GetNlsString(S1,'CheckBox7');
    CheckBox8.Caption:=GetNlsString(S1,'CheckBox8');
    GrpBoxAttribute.Caption:=GetNlsString(S1,'GrpBoxTokken');
    Tab1Caption.Caption:=GetNlsString(S1,'TAB#1Caption');
    TAB1Info.Caption:=GetNlsString(S1,'TAB#1Info');
    Tab2Caption.Caption:=GetNlsString(S1,'TAB#2Caption');
    Tab2Info.Caption:=GetNlsString(S1,'TAB#2Info');
    TabbedNotebook1.PageIndex:=0;
End;

Procedure TNewIPWizard.NewIPWizardOnSetupShow (Sender: TObject);
VAR S1:String;
Begin
    IF Paramstr(1)='\DEBUG' Then Begin LabelHomeIP.Visible:=TRUE;DebugButton.Visible:=True;End;

    //LanNum:=DebugForm.LBIPSetupLanNum.items.count;

       IF not NewEntryFlag Then
       Begin
            IFConfig2(EntryIndex,TRUE);
            QueryInterfaceFlags2(EntryIndex);
            GrpBoxAttribute.Enabled:=TRUE;
       End else
       Begin
            GrpBoxAttribute.Enabled:=FALSE;
       End;

    Notebook1.PageIndex:=0;

    IF NewEntryFlag Then ClearAll else SetupSettings;

    HasChanged:=FALSE;
    LanguageSettings;

End;

Procedure TNewIPWizard.SaveIPAdresses;
VAR Loop:Byte;
Begin
       // Store IP-Adress
       TRY
          DebugFOrm.LBIpSetupIPAdress.items[EntryIndex]:=AliasBox.Values[1,0];
       Except Raise  EInvalidCast.Create('Exception in NewIPWizard_Unit bei "SaveIPAdresses" Fehler bei Schreibzugriff auf LBIPSetupIPAdress.items[EntryIndex]');Halt;
       End;

       Try
          DebugForm.LBIpSetupSubnetmask.items[EntryIndex]:=AliasBox.Values[2,0];
       Except Raise EInvalidCast.Create('Exception in NewIPWizard_Unit bei "SaveIPAdresses" Fehler bei Schreibzugriff auf LBIPSetupSubnetmask.items[EntryIndex]');HAlt;
       ENd;

       IF AliasBox.Items.count>1 Then
       Begin
            // Store Alias IP's
            For loop:=1 to aliasbox.items.count-1 do
                begin
                     TRY
                     aliasrec.aliasip[entryindex].add(aliasbox.values[1,loop]);
                     Except Raise EInvalidCast.Create('Exception in NewIPWizard_Unit bei "SaveIPAdresses" Fehler bei  Schreibzugriff auf aliasRec.AliasIP[EntryIndex] (Alias IP Speichern)');HAlt;
                     End;

                     TRY
                     aliasrec.aliassubnet[entryindex].add(aliasbox.values[2,loop]);
                     Except Raise EInvalidCast.Create('Exception in NewIPWizard_Unit bei "SaveIPAdresses" Fehler bei  Schreibzugriff auf aliasRec.AliasSubnet[EntryIndex] (Alias IP Speichern)');HAlt;
                     End;
                end;
       End;
ENd;

Procedure TNewIPWizard.AddSettings;
var IndexWiz4,loop:Byte;
Begin
       With DebugForm do
       Begin
       {Store Interface }
       LBIPSetupLanNum.items.add(GetInterfaceName);

       IF RadioIPSelect.ItemIndex=0 Then
        Begin
             LBIpSetupIPAdress.items.add('DHCP-Auto');
             LBIpSetupSubnetmask.items.add('DHCP-Auto');
             LBIpSetupDHCPTime.items.add(ToStr(SpinEditDHCPTime.Value));
             LBIPSetupDHCP.Items.Add('TRUE');
             Exit;
        End;

       //IF ProgramSettings.ConfigLevel=1 Then
       IF Application.ProgramIniFile.ReadInteger('Settings','CONFIG_LEVEL',0)=1 Then
       Begin
            {Set Manualy setup Flag (prevents DHCP)}
            LBIPSetupDHCP.Items.add('FALSE');
            LBIPSetupDHCPTime.items.add('0');
            {Store Broadcast}
            IF EditBroadcast.Text='' then LBIpSetupBroadcast.items.add('Nil') else LBIpSetupBroadcast.items.add(EditBroadcast.Text);
            {Store Targe IP Adress}
            IF EditTargetAdress.Text ='' then LBIpSetupTargetAdress.items.add('Nil') else LBIpSetupTargetAdress.items.add(EditTargetAdress.Text);
            {MTU SIze}
            LBIPSetupMTU.items.add(toStr(SpinMtuSIze.Value));
            {Metric}
            LBIPSetupMetric.items.add(toStr(SpinMetricSize.Value));
            {Token Ring Information}
            IF CheckBox1.checked Then DebugForm.LBSpSettingsALLRS.items.add('true') else DebugForm.LBSpSettingsALLRS.items.add('false');
            IF CheckBox2.checked Then DebugForm.lbSpSettingsARP.items.add('true')   else DebugForm.lbSpSettingsARP.items.add('false');
            IF CheckBox3.checked Then DebugForm.lbSpSettingsICMPRED.items.add('true') else DebugForm.lbSpSettingsICMPRED.items.add('false');
            IF CheckBox4.checked Then DebugForm.lbSpSettingsSNAP.items.add('true') else DebugForm.lbSpSettingsSNAP.items.add('false');
            IF CheckBox5.checked Then DebugForm.lbSpSettingsBRIDGE.items.add('true') else DebugForm.lbSpSettingsBRIDGE.items.add('false');
            IF checkBox6.checked Then DebugForm.lbSpSettingsTRAILERS.items.add('true') else DebugForm.lbSpSettingsTRAILERS.items.add('false');
            If CheckBox7.checked Then DebugForm.lbSpSettings802.items.add('true') else DebugForm.lbSpSettings802.items.add('false');
            IF CheckBox8.checked Then DebugForm.lbSpSettingsCANONICAL.items.add('true') else DebugForm.lbSpSettingsCANONICAL.items.add('false');
       End else
       Begin
             LBIpSetupBroadcast.items.add('Nil');
            LBIpSetupTargetAdress.items.add('Nil');
            LBIPSetupMTU.items.add('1500');
            LBIPSetupMetric.items.add('1');
       End;



       {Alias Information}
       AliasRec.AliasIP[EntryIndex].clear;              // Clear current ALIAS IP field
       AliasRec.AliasSubnet[EntryIndex].clear;          // Clear  current ALias Subnet field
       End;

       // HomeIP in Debug Form Åbertragen
       DebugForm.LBIpSetupIPAdress.items.add(TempALias.HomeIP);
       DebugForm.LBIpSetupSubnetmask.items.add(TempALias.HomeSubnet);
       SaveIPAdresses;
End;


Procedure TNewIPWizard.StoreSettings;

          Procedure DHCP_Settings;
          Begin
               DebugForm.LBIpSetupIPAdress.items[EntryIndex]:='Auto';DebugForm.LBIpSetupSubnetmask.items[EntryIndex]:='Auto';
               DebugForm.LBIpSetupDHCPTime.items[EntryIndex]:=ToStr(SpinEditDHCPTime.Value);
               DebugForm.LBIPSetupDHCP.Items[EntryIndex]:='TRUE';

               DebugForm.LBIpSetupBroadcast.items[EntryIndex]:='Nil';
               DebugForm.LBIpSetupTargetAdress.items[EntryIndex]:='Nil';
               DebugForm.LBIPSetupMTU.items[EntryIndex]:='1500';
               DebugForm.LBIPSetupMetric.items[EntryIndex]:='1';

               DebugForm.LBSpSettingsALLRS.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsARP.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsICMPRED.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsSNAP.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsBRIDGE.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsTRAILERS.items[EntryIndex]:='false';
               DebugForm.lbSpSettings802.items[EntryIndex]:='false';
               DebugForm.lbSpSettingsCANONICAL.items[EntryIndex]:='false';
          End;

      Procedure Manual_Settings;
      Begin

       IF Application.ProgramINiFile.ReadInteger('Settings','CONFIG_LEVEL',0)=1 Then
          Begin
            {Reset DHCP Flag}
            DEBUGForm.LBIPSetupDHCP.Items[EntryIndex]:='FALSE';
            DebugForm.LBIPSetupDHCPTime.items[EntryIndex]:='0';
            {Store Broadcast}
            IF EditBroadcast.Text='' then DebugForm.LBIpSetupBroadcast.items[EntryIndex]:='Nil' else DebugForm.LBIpSetupBroadcast.items[EntryIndex]:=EditBroadcast.Text;
            {Store Target IP Adress}
            IF EditTargetAdress.Text ='' then DebugForm.LBIpSetupTargetAdress.items[EntryIndex]:='Nil' else DebugForm.LBIpSetupTargetAdress.items[EntryIndex]:=EditTargetAdress.Text;
            {MTU SIze}
            DebugForm.LBIPSetupMTU.items[EntryIndex]:=(toStr(SpinMtuSIze.Value));
            {Metric}
            DebugForm.LBIPSetupMetric.items[EntryIndex]:=toStr(SpinMetricSize.Value);
            {Token Ring Information}
            IF CheckBox1.checked Then DebugForm.LBSpSettingsALLRS.items[EntryIndex]:='true' else DebugForm.LBSpSettingsALLRS.items[EntryIndex]:='false';
            IF CheckBox2.checked Then DebugForm.lbSpSettingsARP.items[EntryIndex]:='true'   else DebugForm.lbSpSettingsARP.items[EntryIndex]:='false';
            IF CheckBox3.checked Then DebugForm.lbSpSettingsICMPRED.items[EntryIndex]:='true' else DebugForm.lbSpSettingsICMPRED.items[EntryIndex]:='false';
            IF CheckBox4.checked Then DebugForm.lbSpSettingsSNAP.items[EntryIndex]:='true' else DebugForm.lbSpSettingsSNAP.items[EntryIndex]:='false';
            IF CheckBox5.checked Then DebugForm.lbSpSettingsBRIDGE.items[EntryIndex]:='true' else DebugForm.lbSpSettingsBRIDGE.items[EntryIndex]:='false';
            IF checkBox6.checked Then DebugForm.lbSpSettingsTRAILERS.items[EntryIndex]:='true' else DebugForm.lbSpSettingsTRAILERS.items[EntryIndex]:='false';
            If CheckBox7.checked Then DebugForm.lbSpSettings802.items[EntryIndex]:='true' else DebugForm.lbSpSettings802.items[EntryIndex]:='false';
            IF CheckBox8.checked Then DebugForm.lbSpSettingsCANONICAL.items[EntryIndex]:='true' else DebugForm.lbSpSettingsCANONICAL.items[EntryIndex]:='false';
       End else
       Begin
            DebugForm.LBIpSetupBroadcast.items[EntryIndex]:='Nil';
            DebugForm.LBIpSetupTargetAdress.items[EntryIndex]:='Nil';
            DebugForm.LBIPSetupMTU.items[EntryIndex]:='1500';
            DebugForm.LBIPSetupMetric.items[EntryIndex]:='1';
       End;

       SaveIPAdresses;
   End;


Begin
        {Alias Information}
       AliasRec.AliasIP[EntryIndex].clear;              // Clear current ALIAS IP field
       AliasRec.AliasSubnet[EntryIndex].clear;          // Clear  current ALias Subnet field

       IF DHCP_MODE Then DHCP_Settings
                     else Manual_Settings;

End;

Initialization
  RegisterClasses ([TNewIPWizard, TGroupBox, TButton
   , TNoteBook, TLabel, TEdit,
    TTabbedNotebook,TAliasHelpWizard, TEdit, TGroupBox
   , tMultiColumnList, TPopupMenu, TMenuItem, TImage, TBitBtn, TCheckBox,
    TSpinEdit, TRadioGroup]);
End.




{énderungen :
10.12.2006 : Aufruf von ifconfig wenn paramter (bridge,icmpred usw..) geÑndert wurde
}

