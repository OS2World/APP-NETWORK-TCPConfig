Unit NFS_OptionsUnit;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, Buttons, StdCtrls, Spin,Dialogs,uString,SPIN,NFS_LanguageUnit,
  INet;

Type
  TFormNFSOption = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    GroupBoxAttribute: TGroupBox;
    GroupBoxFileCache: TGroupBox;
    rbAttributeCacheS: TRadioButton;
    rbAttributeCacheM: TRadioButton;
    rbAttributeCacheL: TRadioButton;
    rbFileCacheS: TRadioButton;
    rbFileCacheM: TRadioButton;
    rbFileCacheL: TRadioButton;
    GroupBoxAttributeTimeout: TGroupBox;
    spinAttributeTimeout: TSpinEdit;
    GroupBoxFileCacheTimelimit: TGroupBox;
    SpinFileCacheTimeout: TSpinEdit;
    GroupBoxRPCTimelimit: TGroupBox;
    SpinRPCTimeout: TSpinEdit;
    GroupBoxDataBuffer: TGroupBox;
    SpinTransmitBuffer: TSpinEdit;
    Label1: TLabel;
    cbLockManager: TCheckBox;
    cbArchive: TCheckBox;
    cbCRLF1: TCheckBox;
    spinRPCretry: TSpinEdit;
    SPINBIODSRead: TSpinEdit;
    OKButton: TButton;
    CancelButton: TButton;
    ButtonDefault: TButton;
    LabelRPCretry: TLabel;
    LabelBIODSread: TLabel;
    LabelBIODSwrite: TLabel;
    cbtrace: TCheckBox;
    SpinTPCInfoTimelimit: TSpinEdit;
    GroupBoxRPCINFOTimeLimit: TGroupBox;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpinBIODSwrite: TSpinEdit;
    Procedure ButtonDefaultOnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
    Procedure FormNFSOptionOnCreate (Sender: TObject);
    Procedure FormNFSOptionOnSetupShow (Sender: TObject);
    Procedure LanguageSettings;
  Private
    {Private Deklarationen hier einfgen}
  Public
    {™ffentliche Deklarationen hier einfgen}
  Procedure CreateAdvancedOptions;
  Procedure CreateDefaultOptions;
  End;

Var
  FormNFSOption: TFormNFSOption;

Implementation

USES NFS_IniFiles,NFS_VAR_Unit,MyMessageBox,NFS_LanguageUnit;

CONST Advanced=0;
      Normal  =1;

Procedure TFormNFSOption.ButtonDefaultOnClick (Sender: TObject);
Begin
     Case NLSDialog('DLG_Default') of
     TRUE:Begin
               spinAttributeTimeout.Value:=15;
               SpinFileCacheTimeout.Value:=15;
               SpinRPCTimeout.Value:=1;
               SpinTPCInfoTimelimit.Value:=10;
               rbAttributeCacheM.Checked:=True;
               rbFileCacheM.CHecked:=TRUE;
               SpinTransmitBuffer.Value:=8192;
               //cbWriteCreate.checked:=FALSE;
               //cblowercase.checked:=FALSE;
               //cbUpperLowercase.checked:=FALSE;
               spinRPCretry.Value:=1;
               SPINBIODSRead.Value:=4;
               SpinBIODSwrite.Value:=0;
               cbArchive.Checked:=FALSE;
               cbCRLF1.checked:=FALSE;
               cbLockManager.checked:=FALSE;
               cbtrace.checked:=FALSE;
          End;
     FALSE:Begin END;

     End;
End;

Procedure TFormNFSOption.LanguageSettings;
VAR Section:String;
Begin
     TabbedNotebook1.Pages[0]:=GetNLSString(Self.Name,'TAB0');
     TabbedNotebook1.Pages[1]:=GetNLSString(Self.Name,'TAB1');
     TabbedNotebook1.Pages[2]:=GetNLSString(Self.Name,'TAB2');
     GroupBoxAttribute.Caption:=GetNLSString(Self.Name,'GroupBoxAttribute');
     GroupBoxFileCache.Caption:=GetNLSString(Self.Name,'GroupBoxFileCache');
     GroupBoxDataBuffer.caption:=GetNLSString(Self.Name,'GroupBoxDataBuffer');
     GroupBoxAttributeTimeout.Caption:=GetNLSString(Self.Name,'GroupBoxAttributeTimeout');
     GroupBoxFileCacheTimelimit.Caption:=GetNLSString(Self.Name,'GroupBoxFileCacheTimelimit');
     GroupBoxRPCTimelimit.Caption:=GetNLSString(Self.Name,'GroupBoxRPCTimelimit');
     GroupBoxRPCINFOTimeLimit.Caption:=GetNLSString(Self.Name,'GroupBoxRPCINFOTimeLimit');
     rbAttributeCacheS.Caption:=GetNLSString(Self.Name,'CacheSmall');
     rbAttributeCacheM.Caption:=GetNLSString(Self.Name,'CacheMedium');
     rbAttributeCacheL.Caption:=GetNLSString(Self.Name,'CacheLarge');
     rbFileCacheS.Caption:=GetNLSString(Self.Name,'CacheSmall');
     rbFileCacheM.Caption:=GetNLSString(Self.Name,'CacheMedium');
     rbFileCacheL.Caption:=GetNLSString(Self.Name,'CacheLarge');
     cbArchive.Caption:=GetNLSString(Self.Name,'cbArchive');
     cbCRLF1.Caption:=GetNLSString(Self.Name,'cbCRLF1');
     cbLockManager.Caption:=GetNLSString(Self.Name,'cbLockManager');
     cbtrace.Caption:=GetNLSString(Self.Name,'cbtrace');
     LabelRPCretry.Caption:=GetNLSString(Self.Name,'LabelRPCretry');
     LabelBIODSread.Caption:=GetNLSString(Self.Name,'LabelBIODSread');
     LabelBIODSwrite.Caption:=GetNLSString(Self.Name,'LabelBIODSwrite');
     OKButton.Caption:=GetNLSString(Self.Name,'ButtonOK');
     CancelButton.Caption:=GetNLSString(Self.Name,'ButtonCancel');

End;
          
Procedure TFormNFSOption.Button1OnClick (Sender: TObject);
Begin
    With Os2UserIniFile do
    Begin
     // Zeitlimit fr Attribute
     WriteInteger(AdvancedSection,'spinAttributeTimeout',spinAttributeTimeout.Value);

     // File Cache Timeout
     WriteInteger(AdvancedSection,'SpinFileCacheTimeout',SpinFileCacheTimeout.Value);

     //RPC Timeout
     WriteInteger(AdvancedSection,'SpinRPCTimeout',SpinRPCTimeout.Value);

     WriteBool(AdvancedSection,'rbAttributeCacheS',rbAttributeCacheS.checked);
     WriteBool(AdvancedSection,'rbAttributeCacheM',rbAttributeCacheM.checked);
     WriteBool(AdvancedSection,'rbAttributeCacheL',rbAttributeCacheL.checked);
     WriteBool(AdvancedSection,'rbFileCacheS',rbFileCacheS.checked);
     WriteBool(AdvancedSection,'rbFileCacheM',rbFileCacheM.checked);
     WriteBool(AdvancedSection,'rbFileCacheL',rbFileCacheL.checked);
     WriteInteger(AdvancedSection,'SpinTransmitBuffer',SpinTransmitBuffer.value);
     WriteBool(AdvancedSection,'cbLockManager',cbLockManager.checked);
     WriteBool(AdvancedSection,'cbArchive',cbArchive.checked);
     WriteBool(AdvancedSection,'cbCRLF1',cbCRLF1.checked);
     WriteBool(AdvancedSection,'cbtrace',cbtrace.checked);
     WriteInteger(AdvancedSection,'spinRPCretry',spinRPCretry.Value);
     WriteInteger(AdvancedSection,'SPINBIODSRead',SPINBIODSRead.Value);
     WriteInteger(AdvancedSection,'SPINBIODSWrite',SPINBIODSWrite.Value);
     WriteInteger(UserSection,'SpinTPCInfoTimelimit',SpinTPCInfoTimelimit.Value);
     End;
End;

Procedure TFormNFSOption.FormNFSOptionOnCreate (Sender: TObject);
VAR
   SectionList:TStringlist;
Begin
    // Prfen ob das OS2User File eine Sektion der Variable "UserSection" enth„lt ->siehe NFS_VAR_Unit

    OS2UserIniFIle.Create;
    SectionList.Create;
    OS2UserIniFile.ReadSections(SectionList);
    IF SectionList.Indexof(AdvancedSection)=-1 Then CreateAdvancedOptions;
    IF SectionList.Indexof(UserSection)=-1 Then CreateDefaultOptions;
    SectionList.Destroy;
End;

Procedure TFormNFSOption.FormNFSOptionOnSetupShow (Sender: TObject);
VAR RC:String;
Begin
    With OS2UserIniFile do
    Begin


      cbLockManager.checked:=ReadBool(AdvancedSection,'cbLockManager',FALSE);
      cbArchive.checked:=ReadBool(AdvancedSection,'cbArchive',FALSE);
      cbCRLF1.checked:=ReadBool(AdvancedSection,'cbCRLF1',FALSE);
      cbtrace.checked:=ReadBool(AdvancedSection,'cbtrace',FALSE);
      spinRPCretry.Value:=ReadInteger(AdvancedSection,'spinRPCretry',99);
      SPINBIODSRead.Value:=ReadInteger(AdvancedSection,'SPINBIODSRead',99);
      SpinBIODSwrite.Value:=ReadInteger(AdvancedSection,'SPINBIODSWrite',99);
      spinAttributeTimeout.Value:=ReadInteger(AdvancedSection,'spinAttributeTimeout',99);
      SpinFileCacheTimeout.Value:=ReadInteger(AdvancedSection,'SpinFileCacheTimeout',99);
      SpinRPCTimeout.Value:=ReadInteger(AdvancedSection,'SpinRPCTimeout',99);
      rbAttributeCacheS.Checked:=ReadBool(AdvancedSection,'rbAttributeCacheS',FALSE);
      rbAttributeCacheM.checked:=ReadBool(AdvancedSection,'rbAttributeCacheM',FALSE);
      rbAttributeCacheL.checked:=ReadBool(AdvancedSection,'rbAttributeCacheL',FALSE);
      rbFileCacheS.checked:=ReadBool(AdvancedSection,'rbFileCacheS',FALSE);
      rbFileCacheM.checked:=ReadBool(AdvancedSection,'rbFileCacheM',FALSE);
      rbFileCacheL.checked:=ReadBool(AdvancedSection,'rbFileCacheL',FALSE);
      SpinTransmitBuffer.Value:=ReadInteger(AdvancedSection,'SpinTransmitBuffer',-99);
      SpinTPCInfoTimelimit.Value:=ReadInteger(UserSection,'SpinTPCInfoTimelimit',99);
    End;
    LanguageSettings;
End;

Procedure  TFormNFSOption.CreateAdvancedOptions;
Begin
         IF Paramstr(1)='\ADVANCED' Then Button1OnClick(Self);
End;

Procedure TFormNFSOption.CreateDefaultOptions;
Begin
     OS2USerIniFIle.WriteBool(UserSection,'cbWarningNLOCK',TRUE);
     OS2UserIniFile.WriteBool(UserSection,'cbConditionPortmap',TRUE);
     OS2UserIniFile.WriteBool(UserSection,'cbWarningStatus',TRUE);
     OS2USerIniFile.WriteInteger(UserSection,'SpinTPCInfoTimelimit',10);
     //MyInfoBox('Options successfully done');
End;


Initialization
  RegisterClasses ([TFormNFSOption, TTabbedNotebook, TGroupBox, TRadioButton, TCheckBox,
    TSpinEdit, TLabel, TButton]);
End.
