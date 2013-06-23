Unit NFS_MountErrorUnit;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons,Messages,NFS_LanguageUnit;

Type
  TFormMountError = Class (TForm)
    Image1: TImage;
    Label1: TLabel;
    Bevel1: TBevel;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Procedure BitBtn1OnClick (Sender: TObject);
    Procedure FormMountErrorOnSetupShow (Sender: TObject);
    Mode:Boolean;
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  Procedure ShowModal(MountOrUnmountMode:Byte);Virtual;
  Procedure DisplayModal;
  End;

Var
  FormMountError: TFormMountError;

CONST
  Mode_Mount=0;
  Mode_Unmount=1;

Implementation
{$R MyOwnMessagebox}
VAR aFile:Text;
    fileText:String;

Procedure TFormMountError.BitBtn1OnClick (Sender: TObject);
Begin
  DisMissDlg(CmCancel);
End;

Procedure TFormMountError.FormMountErrorOnSetupShow (Sender: TObject);
VAR aIcon:TIcon;
Begin
        aIcon.Create;
        AIcon.LoadFromResourceName('ERROR_ICO');
        Image1.Bitmap:=AIcon;
        AIcon.Destroy;
End;

Procedure TFormMountError.DisplayModal;
Begin
     inherited.showModal;
End;

Procedure TFormMountError.ShowModal(MountOrUnmountMode:Byte);
VAR FileName:String;
Begin
    IF MountorUnMountMode=Mode_Mount Then
    Begin
         Label1.Caption:=GetNlsString(Self.Name,'LabelMount');FileName:='Mount.log';
    End else
    Begin
         Label1.Caption:=GetNLSString(Self.Name,'LabelUnMount');FileName:='UMount.LOG';
    End;

    Caption:=GetNLSString(Self.Name,'Caption');

    System.Assign(aFile,FileName);
    Reset(aFile);
        While not eof(aFile) do
        Begin
             Readln(aFile,FileText);
             Memo1.Lines.add(filetext);
        End;
        system.Close(AFile);
    inherited.showModal;
End;

Initialization
  RegisterClasses ([TFormMountError, TImage, TLabel, TBevel, TMemo, TBitBtn]);
End.
