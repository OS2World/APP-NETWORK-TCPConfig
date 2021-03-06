Unit NFS_CheckFileSystemUnit;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls,BSEDOS, Buttons,Dialogs, ComCtrls,SysUtils,NFS_UtiltyUnit,NFS_VAR_Unit,uSysClass,Messages,NFS_LanguageUnit;

Type
  TAnimateThread = Class(TThread)
  Private
    {Private Deklarationen hier einf�gen}
  Protected
    Procedure Execute; Override;
  End;

  Type
  TExecThread = Class(TThread)
  Private
    {Private Deklarationen hier einf�gen}
  Protected
    Procedure Execute; Override;
  End;

Type
  TFormActivateConfig = Class (TForm)
    Title: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    ProgressBar1: TProgressBar;
    Procedure Timer1OnTimer (Sender: TObject);
    Procedure Form4OnSetupShow (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einf�gen}
  Public
    {�ffentliche Deklarationen hier einf�gen}
  Procedure ShowModal; Virtual;
  End;

Var
  FormActivateConfig: TFormActivateConfig;
  AnimateThread:TAnimateThread;
  ExecThread:TExecThread;
  Test:Byte;
Implementation
Imports
Function GetFSInfo(aDrive:String;VAR FSName:String;VAR USerInfo:String):Boolean; 'TCPLIB' NAME 'GetFSInfo';
Function DLLResultStr:String; 'TCPLIB' NAME 'DllReturnString';
End;

Procedure TFormActivateConfig.Timer1OnTimer (Sender: TObject);
Begin
     ImageList1.GetBitmap(Test,Image1.Bitmap);
     Inc(Test);
     If Test=4 Then Test:=0;
     Update;
     Beep(100,100);
     Show;
End;


Procedure TFormActivateConfig.Form4OnSetupShow (Sender: TObject);
VAR I:TIcon;Loop:Byte;RC:Longint;
Begin
     Caption:=GetNlsString(Name,'caption');
     Title.Caption:=GetNLSString(Name,'Title');
End;

Procedure TFormActivateConfig.Button1OnClick (Sender: TObject);
Begin
     ShowMessage('!');
End;

VAR
   FSName:String;
   UInfo:String;

  Procedure Execute;
 var
    loop:Byte;RC:Longint;Drives:Longint;
    DriveChar:CHar;
 Begin
      NFSDriveList.Clear;
      Drives:=GetPhysicalDrives;
      For loop:=0 to 25 do
         Begin
            Inc(Test);IF Test=4 Then Test:=0;
            FormActivateConfig.Update;
            FormActivateCOnfig.ImageList1.GetBitmap(Test,FormActivateConfig.Image1.Bitmap);

            If Drives And (1 Shl loop)<>0 Then
            Begin
                 DriveCHar:=chr(loop+65);
                 GetFSInfo(DriveChar+':',FSName,UInfo);
                 IF DLLResultStr='0' then
                 Begin
                      IF FSName='NFS' then
                      Begin
                           NFSDriveList.add(DriveChar+':');
                           NFSDriveList_Info.add(UInfo);
                      End;
                 End;
            End;
            FormActivateConfig.ProgressBar1.Position:=Prozent(loop,25);
         End;
 End;

 Procedure TExecThread.Execute;
 var loop:Byte;RC:Longint;
 Begin
      {For loop:=0 to DebugExecForm.ListBoxProg.items.count-1 do
         Begin
            //ShowMessage('Executing Command :'+#13+DebugExecForm.ListBoxProg.items[loop]+' '+DebugExecForm.ListBoxParam.items[loop]);
            //RC:=TestDll(DebugExecForm.ListBoxProg.items[loop],DebugExecForm.ListBoxParam.items[loop]);
            IF RC<>0 Then
            Begin
                 MyErrorBox(GetNlsString('ERRORS','EXEC_Error')+#13+SysErrorMessage(RC));Halt;
            End;
            FormActivateConfig.ProgressBar1.Position:=Prozent(loop,DebugExecForm.ListBoxProg.items.count-1);
         End;}
 End;

 Procedure TAnimateThread.Execute;
 Var
    Test:Byte;
 Begin
{     Test:=0;
     REPEAT
      FormActivateConfig.ImageList1.GetBitmap(Test, FormActivateConfig.Image1.Bitmap);
      FormActivateConfig.Update;
     Inc(Test);
     If Test=4 Then Test:=0;
     DosSleep(200);
     UNTIL Terminated;

 }
 End;

Procedure TFormActivateConfig.ShowModal;
Begin
     Cursor:=crHourGlass;
     Test:=0;
     ImageList1.GetBitmap(0,Image1.Bitmap);
     Show;
     //Timer1.Start;
     //AnimateThread.Create(False);
     Execute;
     //ExecThread.Create(False);

     //ExecThread.WaitFor;
     //AnimateThread.terminate;
     DisMissDlg(CMOK);
     Cursor:=CrDefault;
End;

Initialization
  RegisterClasses ([TFormActivateConfig, TLabel, TImageList, TTimer, TImage, TProgressBar]);
End.
