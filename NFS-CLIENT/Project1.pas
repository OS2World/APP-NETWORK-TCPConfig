Program Project1;

Uses
  Forms, Graphics, NFS_Unit1, NFS_AdressWizard, NFS_DEBUGUnit, NFS_LogViewUnit,
  NFS_MountInfoDlg, NFS_CheckFileSystemUnit, NFS_OptionsUnit, NFS_MountErrorUnit,
  Unit2, NFS_AdressBookV2, ProgramOptions, NFS_Editor, NFS_AboutUnit;

{$r Project1.scu}

Begin
  Application.Create;
  Application.FormInfoIni:=fiNone;
  Application.CreateForm (TForm1, Form1);
  Application.Run;
  Application.Destroy;
End.
