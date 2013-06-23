Unit TCP_FinalNoteDialog;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons,PMWIN,Color;

Type
  TFormFinalNote = Class (TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    OkButton: TButton;
    Image1: TImage;
    Button1: TButton;
    Label2: TLabel;
    Procedure OkButtonOnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
    Procedure Form3OnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  FormFinalNote: TFormFinalNote;

Implementation
{$R MyOwnMessageBox}
USES TCP_VAR_Unit,tCP_LanguageUnit,DebugUnit;

Procedure TFormFinalNote.OkButtonOnClick (Sender: TObject);
Begin

End;

Procedure TFormFinalNote.Button1OnClick (Sender: TObject);
Begin
    DebugForm.ShowModal;
End;

Procedure TFormFinalNote.Form3OnSetupShow (Sender: TObject);
VAR aIcon:TIcon;
Begin
     Height:=216;
     aIcon.Create;
     aIcon.LoadFromResourceName('INFO_ICO');
     Image1.Bitmap:=aIcon;
     aIcon.Destroy;
     Caption:=GetNlsString(Name,'Caption');
     GroupBox1.Caption:=GetNlsString(Name,'GrpBox');
     OKButton.Caption:=GetNlsString(Name,'OKButton');

     IF ChangeRec.DHCP Then
     Begin
          ChangeRec.Reboot:=True;
     End;

     IF ChangeRec.Reboot Then
     Begin
          Label1.Caption:=GetNlsString(Name,'Finish_Reboot');
          WinAlarm(HWND_Desktop,wa_Note);
          Label1.PenColor:=clRed;
     End
                         else
                          Begin
                               Label1.Caption:=GetNlsString(Name,'Finish_NoReboot');
                               Label1.PenColor:=clWindowText;
                               {IF ChangeRec.LanInterface Then Begin Label1.Caption:=GetNlsString(Name,'Finish_NoReboot');exit;End;
                               IF ChangeRec.Hosts Then Begin Label1.Caption:=GetNlsString(Name,'Finish_NoReboot');Exit;ENd;
                               IF ChangeRec.LoopBack Then Begin Label1.Caption:=GetNlsString(Name,'Finish_NoReboot');Exit;End;}

                          End;
     IF ChangeRec.IFAliasError Then
     begin
          Height:=300;
          Label2.Caption:=GetNlsString(Name,'FInish_Error');
     End else Label2.Visible:=FALSE;
End;

Initialization
  RegisterClasses ([TFormFinalNote, TGroupBox, TLabel, TButton, TImage]);
End.
