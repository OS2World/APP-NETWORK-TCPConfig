Unit TCPLIB_UtilityUnit;

INTERFACE
USES SysUtils;
Function FindWordinStri(StringToFind:String;StringToSearch:String):integer;
Function GetIPAdressfromString(StartPos:Byte;S:String):String;
IMPLEMENTATION

Function FindWordinStri(StringToFind:String;StringToSearch:String):integer;
{Version 1 15.10.2005 - Update damit "TFTPD" und "FTPD" nicht gleich sind am 24.11.2005

 Sucht nach dem vorkommen eines Strings innerhalb eines andern strings
 Gross und Kleinschreibung wird ignoriert (Kein unterscheid)
 RÅckgabe  Wert ist die Position an der das Wort im String "StringToFInd" (Suchstring) gefunden wurde.
 Wurde der Wert/String nicht gefunden, wird -1 ZurÅckgeliefert.
 }

VAR Found:Boolean;
          DebugStr:String;
          Loop:Byte;
      Begin
           Found:=FALSE;DebugStr:='';

          For Loop:=1 to length(StringToSearch) do
              Begin
                   DebugStr:=Copy(StringToSearch,loop,length(StringToFind));
                 IF UpperCase(DebugStr)=Uppercase(StringToFind) Then
                        Begin
                                IF Upcase(StringToSearch[loop-1])='T' Then Begin result:=-1;exit;END;
                                Found:=TRUE;Break;
                        End;
              End;
              IF Found Then Result:=Loop else Result:=-1;
      End;


Function GetIPAdressfromString(StartPos:Byte;S:String):String;
// returns a correct IP Adress
VAR Loop:Byte;ReturnStr:String;
Begin
     ReturnStr:='';
     For Loop:=StartPos to length(S) do
     begin
          IF (S[loop] in ['0'..'9']) Then ReturnStr:=ReturnStr+S[Loop];
          IF S[Loop] = '.' Then ReturnStr:=ReturnStr+'.';
          IF S[Loop] = ' ' Then break;
     End;
     Result:=ReturnStr;
End;

End.
