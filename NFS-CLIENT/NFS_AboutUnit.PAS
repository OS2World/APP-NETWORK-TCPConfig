Unit NFS_AboutUnit;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons;

Type
  TAboutForm = Class (TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    Label7: TLabel;
    Procedure AboutFormOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  AboutForm: TAboutForm;

Implementation
{$R NFSResource}
USES NFS_LanguageUnit;

Procedure TAboutForm.AboutFormOnSetupShow (Sender: TObject);
VAR aIcon:TIcon;
Begin
     aIcon.Create;
     aIcon.LoadFromResourceName('ProgIcon');
     Caption:=GetNLSString('ABOUT','Caption');
     Label4.Caption:=GetNLSString('ABOUT','LABEL1');
     Image1.Bitmap:=Aicon;
     aICON.Destroy;
End;

Initialization
  RegisterClasses ([TAboutForm, TImage, TLabel, TBitBtn]);
End.
