Unit DirChangeDlg;

Interface

Uses
  Classes, Forms, Graphics, BmpList, FileCtrl, StdCtrls, Buttons,Dialogs,Messages;

Type
  TDirChangeDialog = Class (TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Label1: TLabel;
    Label2: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    Edit1: TEdit;
    Procedure DirChangeDialogOnSetupShow (Sender: TObject);
    Procedure DirectoryListBox1OnItemFocus (Sender: TObject; Index: LongInt);
    Procedure OKButtonOnClick (Sender: TObject);
    Directory : String;
    Function Execute :Boolean;
    Procedure ShowModal; VIRTUAL;
    Constructor Create; VIRTUAL;
    Destructor Destroy;    VIRTUAL;
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

VAR
   DirDialog : TDirChangeDialog;

IMPLEMENTATION
USES TCP_LanguageUnit;
VAR isCreated:Boolean;


Procedure TDirChangeDialog.DirChangeDialogOnSetupShow (Sender: TObject);
Begin
     Caption:=GetNLSString('DIRBROWSER','CAPTION');
     Label1.Caption:=GetNLSString('DIRBROWSER','LABEL#1');
     Label2.Caption:=GetNLSString('DIRBROWSER','LABEL#2');
     OKButton.Caption:=GetNLSString('DIRBROWSER','OKButton');
     CancelButton.Caption:=GetNLSString('DIRBROWSER','CancelButton');
End;

Procedure TDirChangeDialog.DirectoryListBox1OnItemFocus (Sender: TObject;
  Index: LongInt);
Begin
   Edit1.Text:=DirectoryListBox1.Items[Index];
   OkButton.Enabled:=True;
End;

Procedure TDirChangeDialog.OKButtonOnClick (Sender: TObject);
Begin

End;

Function TDirChangeDialog.Execute:Boolean;
Begin
     IF not ISCreated Then Begin ShowMessage('TDirChangeDialog wurde noch nicht erzeugt !');Halt;End;
     inherited.ShowModal;
     Directory:=Edit1.Text;
     IF ModalResult<>CmOK Then Result:=FALSE else Result:=TRUE;
End;

Procedure TDirChangeDialog.ShowModal;
Begin
     IF not ISCreated Then Begin ShowMessage('TDirChangeDialog wurde noch nicht erzeugt !');Halt;End;
     SHowMessage('Hinweis : Routine muss Åber DirDialog.Execute gestartet werden !');
     Halt;
End;

Constructor TDirChangeDialog.Create;
Begin
     Inherited.Create(Nil);
     IsCreated:=True;
End;

Destructor TDirChangeDialog.Destroy;
Begin
     Inherited.Destroy;
     ISCreated:=FALSE;
End;

Initialization
  RegisterClasses ([TDirChangeDialog, TDirectoryListBox, TDriveComboBox,
    TLabel, TButton, TEdit]);
ISCreated:=FALSE;
End.
