Unit NFS_MountInfoDlg;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls;

Type
  TFormMountInfo = Class (TForm)
    Image1: TImage;
    Label1: TLabel;
    Procedure FormMountInfoOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  FormMountInfo: TFormMountInfo;

Implementation

{$R NFSResource}
Procedure TFormMountInfo.FormMountInfoOnSetupShow (Sender: TObject);
VAR ICO:TIcon;
Begin
     ICO.Create;
     ICO.loadFromResourceName('NetDrive32');
     Image1.Bitmap:=ICO;
     ICO.Destroy;
End;

Initialization
  RegisterClasses ([TFormMountInfo, TImage, TLabel]);
End.
