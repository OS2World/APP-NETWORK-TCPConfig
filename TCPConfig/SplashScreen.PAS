Unit SplashScreen;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, ExtCtrls, ComCtrls;

Type
  TSplashScreenForm = Class (TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ImageList1: TImageList;
    Procedure SplashScreenFormOnSetupShow (Sender: TObject);
    Procedure SplashScreenFormOnShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  SplashScreenForm: TSplashScreenForm;

Implementation
USES TCP_LanguageUnit;


Procedure TSplashScreenForm.SplashScreenFormOnSetupShow (Sender: TObject);
Begin
    Caption:=GetNlsString('StartUP','Caption');
    Label1.Caption:=GetNlsString('STartup','Label#1');
    Label2.Caption:=GetNLSString('Startup','Label#2');
End;

Procedure TSplashScreenForm.SplashScreenFormOnShow (Sender: TObject);
Begin

End;

Initialization
  RegisterClasses ([TSplashScreenForm, TImage, TLabel, TImageList]);
End.
