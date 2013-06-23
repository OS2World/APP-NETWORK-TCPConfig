{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    DNS Wizard                                                            บ
 บ                                                                          บ
 บ    Version 2 09.10.2006                                                  บ
 บ    Zulest gendert 09.10.2006                                            บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit TCP_DNSWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons, TabCtrls,Messages, ExtCtrls,Dialogs;

Type
  TDNSWizard = Class (TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Image1: TImage;
    Procedure DNSWizardOnDestroy (Sender: TObject);
    Procedure DNSWizardOnCreate (Sender: TObject);
    Procedure ButtonOKOnClick (Sender: TObject);
    Procedure DNSWizardOnSetupShow (Sender: TObject);
    ModeByte:Byte;
  Private
    {Private Deklarationen hier einfgen}
  Public
    {ffentliche Deklarationen hier einfgen}
  Constructor Create(aOwner:TComponent;Mode:Byte); VIRTUAL;
  End;

Const
     Mode_DNS=0;
     Mode_Domain=1;
     Mode_SocksDNS=2;
     Mode_SocksDomain=3;
Var
  DNSWizard: TDNSWizard;
  ICO_SYSTEM:TICON;
  ICO_Hostname:TIcon;

{$R FORMWizard}

Implementation
USES TCP_LanguageUnit,DebugUnit,TCP_Check_IP_Unit;

Procedure TDNSWizard.DNSWizardOnDestroy (Sender: TObject);
Begin
     ICO_System.Destroy;
End;

Procedure TDNSWizard.DNSWizardOnCreate (Sender: TObject);
Begin
     ICO_System.Create;
     ICO_Hostname.Create;
     ICO_System.LoadFromResourceName('System');
     ICO_Hostname.LoadFromResourceName('Hostname');
End;

Constructor TDNSWizard.Create(aOwner:TComponent;Mode:Byte);
Begin
     ModeByte:=Mode;
     Inherited.Create(aOwner);
End;



Procedure TDNSWizard.ButtonOKOnClick (Sender: TObject);
Begin
          ButtonOK.ModalResult:=CmNull;

          Case ModeByte of
          Mode_DNS,Mode_SocksDNS:Begin
                        IF ValidIPAdress(Edit1.Text,ChkOpt_ZeroNotAllowed,'INVALID_IP_Address') Then
                        Begin
                             ButtonOK.ModalResult:=CmOK;DisMissDlg(CMOK);
                        End;
                    End;

          Mode_Domain,Mode_SocksDomain:
             Begin
                  IF  ValidHostName(Edit1.Text,'') Then
                  Begin
                       ButtonOK.ModalResult:=cmOK;DisMissDlg(CMOK);
                  End;
             End;

          End;

        Edit1.Focus;
End;





Procedure TDNSWizard.DNSWizardOnSetupShow (Sender: TObject);
Begin
     Image1.Bitmap:=ICO_System;
     Case ModeByte of

          Mode_DNS:
                    Begin
                          IF ModeByte=Mode_DNS Then Caption:=GetNlsString(Name,'Caption1');
                          IF ModeByte=Mode_SocksDNS Then Caption:=GetNlsString(Name,'Caption3');
                          Label1.Caption:=GetNlsString(Name,'LabelDNS#1');
                          Label2.Caption:=GetNlsString(Name,'LabelDNS#2');
                          Label3.Caption:=GetNlsString(Name,'LabelDNS#3');
                     End;

        Mode_Domain:Begin
                         Image1.Bitmap:=ICO_Hostname;

                         IF ModeByte=Mode_Domain Then Caption:=GetNlsString(Name,'Caption2');
                         IF ModeByte=Mode_SocksDomain Then Caption:=GetNlsString(Name,'Caption4');
                         Label1.Caption:=GetNlsString(Name,'LabelDomain#1');
                         Label2.Caption:=GetNlsString(Name,'LabelDomain#2');
                         Label3.Caption:=GetNlsString(Name,'LabelDomain#3');
                    End;
      Mode_SocksDNS:
                    Begin
                          Caption:=GetNlsString(Name,'Caption3');
                          Label1.Caption:=GetNlsString(Name,'LabelSocksDNS#1');
                          Label2.Caption:=GetNlsString(Name,'LabelSocksDNS#2');
                          Label3.Caption:=GetNlsString(Name,'LabelSocksDNS#3');
                    End;
      Mode_SocksDomain:
                    Begin
                          Image1.Bitmap:=ICO_Hostname;
                          Caption:=GetNlsString(Name,'Caption4');
                          Label1.Caption:=GetNlsString(Name,'LabelSocksDomain#1');
                          Label2.Caption:=GetNlsString(Name,'LabelSocksDomain#2');
                          Label3.Caption:=GetNlsString(Name,'LabelSocksDomain#3');
                    End;
     End;
     ButtonOK.Caption:=GetNlsString(Name,'ButtonOK');
     ButtonCancel.Caption:=GetNlsString(Name,'ButtonCancel');
     Edit1.Focus;
End;

Initialization
  RegisterClasses ([TDNSWizard, TGroupBox, TLabel, TButton
   , TEdit, TImage]);
End.
