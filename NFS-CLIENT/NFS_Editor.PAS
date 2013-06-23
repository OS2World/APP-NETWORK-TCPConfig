Unit NFS_Editor;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls,DOS,MyMessageBox,Messages;

Type
  TForm3 = Class (TForm)
    Memo1: TMemo;
    Procedure Memo1OnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    Function ShowModal:Longint;Virtual;
  End;

Var
  Form3: TForm3;

Implementation

Function TForm3.ShowModal:Longint;
var s:string;
Begin
     s:=GetEnv('ETC')+'\MOUNT.TRC';
     try
     Memo1.Lines.LoadFromFile(s);
     except
     MyErrorBox('ôffnen von MOUNT.TRC fehlgeschlagen'+#13+GetEnv('ETC')+'\MOUNT.TRC');
     DismissDLG(CMOK);exit;
     End;
     inherited.showModal;
End;

Procedure TForm3.Memo1OnSetupShow (Sender: TObject);
Begin

End;

Initialization
  RegisterClasses ([TForm3, TMemo]);
End.
