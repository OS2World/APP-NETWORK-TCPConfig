Unit Unit2;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons,dialogs,BSeDOS, ComCtrls,uSysClass,MyMessageBox,NFS_UtiltyUnit,NFS_IniFiles,NFS_LanguageUnit,
  INet,NFS_VAR_Unit,NFS_IniFiles;


Type
  TForm2 = Class (TForm)
    Image1: TImage;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    ProgressBar1: TProgressBar;
    FTP1: TFTP;
    TCP1: TTCP;
    Procedure TCP1OnError (Sender: TObject; ErrNumber: LongInt;
      Const Description: String);
    Procedure Form2OnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  Procedure ShowModal(IPAdress:String); Virtual;
  RPC_Result:Boolean;
  End;

Var
  Form2: TForm2;

Implementation
IMPORTS
       Function DllExecNFSProg(ExeName:String;Parameter:String;LogFileName:String):Boolean; 'TCPLIB' NAME 'DllExecNFSProg';
       Function GetProcessList:Boolean; 'TCPLIB' NAME 'GetProcessList';
End;

Type
   TCRCThread = class(TThread)
  private
    FLabel:TLabel;
    FProgress:TProgressBar;
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

VAR StartTime:Integer;
    Adresse:Longword;
    Milisek:longint;
    Hostname:String;
    ReturnCode:TFTPPingResult;


Procedure TForm2.TCP1OnError (Sender: TObject; ErrNumber: LongInt;
  Const Description: String);
Begin

End;

Procedure TForm2.Form2OnSetupShow (Sender: TObject);
VAR aIcon:TIcon;
Begin
     AIcon.Create;
     AIcon.LoadFromResourceName('Network');
     Image1.Bitmap:=aIcon;
     AIcon.Destroy;
     Caption:=GetNLSString(Name,'Caption');
     Label1.Caption:=GetNLSString(Name,'Label1');
     GroupBox1.Caption:=GetNlsString(Name,'GroupBox1');
End;

Constructor TCRcThread.Create;
Begin
     FProgress:=Form2.ProgressBar1;
     FreeOnTerminate:=FALSE;         // Thread nach Beenden zerstîren
     inherited.create(FALSE);       // Thread Erzeugen, und sofort mit der Arbeit beginnen
ENd;

Procedure TCrcThread.Execute;
VAR RC:Byte;PID:String;
Begin
  {Thread Code hier einfÅgen}
    FOr RC:=StartTime Downto 0 do
    Begin
    DosSleep(30);
    GetProcessList;
    IF Terminated then exit;
    FProgress.Position:=RC;
    End;
    PID:=OS2UserIniFile.ReadString('TCPConfig','RPCINFO','Err');
    Beep(100,100);
    MyKillProcess(Pid);
End;

Procedure TForm2.ShowModal(IPAdress:String);
VAR RC:Boolean;FAdeN:TCrcThread;
Begin
     StartTime:=Os2UserIniFile.ReadInteger(UserSection,'SpinTPCInfoTimelimit',-1);
     IF STartTime=-1 Then Begin MyErrorBox('UngÅltige Startzeit');exit;ENd;
     Show;
     IF OS2UserIniFile.ReadBool(UserSection,'cbConditionPortmap',TRUE) Then // PrÅfen ob Ping eingeschalten ist
     Begin
          ReturnCode:=Ftp1.Ping(IPAdress,64,Adresse,Milisek); // Ping auf gewÅnschte IP Adresse ausfÅhren
          IF ReturnCOde=FTPPingOK Then // Ping ok ?
          Begin // Ja, aufrufen von RPCINFO -P (Liste der laufenden Dienste ermitteln)
               RPC_Result:=DllExecNFSProg('rpcinfo.exe','-p '+IPAdress,'RPCInfo.Log');Exit;
          End else Begin RPC_Result:=FALSE;exit;End; // Ping war nicht erfolgreich , server ist offline
     End;
     // Sollte PING nicht ausgeschalten sein, einfach trotzdem versuchen verbindung aufzubauen
     Faden.Create; // einen eigenen Faden (Thread) fÅr edn ZÑhler erzeugen und sofort starten
     RPC_Result:=DllExecNFSProg('rpcinfo.exe','-p '+IPAdress,'RPCInfo.Log'); // Rpcinfo ausfÅhren
     Faden.Terminate; // Faden wieder zerstîren
ENd;

Initialization
  RegisterClasses ([TForm2, TImage, TLabel, TGroupBox, TProgressBar, TFTP, TTCP]);
End.
