Unit TCPUtilityUnit;

Interface
USES TCP_VAR_UNIT,STDCTRLS,MyMessageBox,Classes,SysUtils,BSEDOS,UString,BSEDOS,TCP_LanguageUnit,process,EAZusatzUnit;

         Const
              FlAlpha  =1; {Alphanumeric valid signs are 0-9 and "A" until "Z"}
              FlNumeric =2; {numeric only (0-9 and "."}
              QueryDate =1;
              QueryTime =2;

              FSplit_FilenameExtension=2;
              FSplit_FilenameOnly=4;

         Type
              MultiIp=record
              IpAdress:Array[1..2] of string;
              End;
         Type
         TDateTimeRec=Record
         TimeStr:String[10]; // Contains the Time in String format
         DateStr:String[10]; // Contains the Date in String format
         End;

          Type
             TFileInfoRec=Record
             FileSizeStr:String[10];
             FileSizeInt:Longword;
             FileExists :Boolean;
             FileDate   :String[10];
             FileTime   :String[8];
         End;
         Function MyUpcaseStr(st:string):string;
         Function ToInt(S:String):LongInt;
         Function  FindWordinStri(StringtoFind:String;StringToSearch:String;):Integer;
         Function GetIPAdressfromString(S:String;StartPos:Byte):String;
         Function GetIPAdressfromString2(S:String):MultiIp;
         Function FillStr(S:String;FillLength:Byte):String;
         Function IsIpAdressValid(IP:String;ZeroStr:Boolean):IPError;
         Function IsHostNameValid(aHostName:String):IPError;
         Function QuerySelectedListBoxIndex(LB:TListBox):longint;
         Function FileSplit(S:String;Mode:Byte):String;
         Function Prozent(CONST Current:Longint;CONST Maximum:Longint):integer;
         Function GetHostNameString(S:String;StartPos:Byte):String;
         Function GetFileInfo(AFileName:String):TFileInfoRec;
         Function NLSFilename(AFileName:String):String;
         Procedure ProcessQueMessage;
         Procedure SocksString(VAR START:Byte;VAR Output:String);
         Procedure SocksString2(VAR START:Byte;VAR Output:String);
         Function MyToStr(i:LONGINT):String;
         Function Space(amount:byte):String;
         Function BackupFolder:String;
         Function SignsInString(aChar:Char;StringToSearch:string):Byte;
         Procedure Directory_Scan(Dir_to_Scan:String;VAR DirList:TStringList);
         Function ParamString(Input:String;Val1,Val2:Longint):String;
         Function QueryBootDrive: char;
         Function MultiValueString(Const S:String;aStringList:TSTringList;CompareChar:Char):Boolean;
         Function GetEnvString(S:String):String;
         Function MultiValueToString(const aStringList:TStrings):String;
         Function FileExistinPath(aFilename:String):Boolean;
         FUNCTION Hex2Dec(Hex:STRING):LongInt;
         Procedure MultiSocksString(Const S:String;aStringList:TSTrings;CompareChar:Char);
         Function QuotationMarkCut(S:String):String;
         Function ProtValueString(Const S:String;aStringList:TSTringList):ShortInt;
         Function NewProtValueString(Const S:String;aStringList:TSTringList):ShortInt;
         Procedure MyKillProcess(PID:String);
         Function MakeRestoreFileName(S:String):String;
         Procedure GetCurrentDateTime(VAR DateTime:TDateTimeRec;DateFormat:Byte);
         Function FileCopy(Source,Destination:CString):Boolean;
         Procedure MakeAliasMultiString(InterfaceNo:Longint;VAR MultiColString:TStrings);
         Function GetTCPIPDosPath(InputStr:String):String;
         Procedure IncIniCounter(IniSection:String);
         Function GetMultiValueString(MCStr:String;Col:Byte):String;
         Function FindMultiValueListItem(S:String;MV_Field:TStrings):Longint;
         Function NewQueryProcess(S:String;Dummy:Byte):String;
         Function  FindWordinStri3(StringtoFind:String;StringToSearch:String;):integer;
VAR
   MyFileInfoRec:TFileInfoRec;
Implementation

USES DIalogs,DOS,Forms,Sysutils,OS2DEF,PMWIN,MyMessageBox,TCP_StdIOError;

VAR ZZ:String;


Procedure MyKillProcess(Pid:String);
Begin
//DosError:=DosKillProcess(1,Hex2Dec(PID));
DOSError:=DosKillProcess(1,StrtoInt(Pid));
IF DOsError<>0 Then MYErrorBox('failed to kill PID '+PID);
End;


{Function NlsString(Section:String;Key:String):String;
     VAR
        MyNLSFile:TAsciiIniFIle;
        aString:TStringList;
     Begin
                Astring:=TStringlist.Create;
                MyNLSFile.Create(PathRec.BootPath+PathRec.LanguageFile);
                If not MyNLSFile.NewReadString(Section,Key,aString) then
                Begin
                     MyErrorBox('Requested NLS String could not be found in the NLS File '+PathRec.LanguageFile+#13+'Requested was : '+#13+'Section :'+Section+#13+'Key : '+Key+#13+'Return Message : '+astring.Strings[0]);
                     Halt;
                End else
                Begin
                     //Result:=ParamString(aString.Strings[0]+' '+Param1);
                     Result:=aString.Strings[0];
                ENd;
                MyNLSFIle.Destroy;
                aString.Destroy;
     End;}


Function Space(amount:byte):String;
VAR S:String;
    localloop:Byte;
Begin
     S:='';
     For LocalLoop:=1 to amount do S:=S+' ';
     Result:=S;
     
End;

Function GetFileInfo(AFileName:String):TFileInfoRec;
VAR MySearchRec:SearchRec;
    DateTime   :TdateTime;
Begin
     IF DOS.FindFirst(Afilename,anyfile,MySearchrec)=0 Then
     Begin
          Result.FileSizeStr:=ToStr(MySearchRec.Size);
          Result.FileSizeInt:=MySearchRec.Size;
          Result.FileExists:=True;
          DateTime:=FileDateToDateTime(FileAge(AFileName));
          Result.FileDate:=DateToStr(DateTime);
          Result.FileTime:=TimeToStr(DateTime);
     End else Result.FileExists:=FALSE;
     DOS.FindClose(MySearchRec);

End;

Function FileExistinPath(aFilename:String):Boolean;
VAR
   RC:LongInt;
   S:String;
   ResultBuffer:CString;
   ENVVarName:Cstring;
   Filename:CString;

Begin
          ENVVarName:='PATH';
          FileName:=aFilename;
          rc:=DosSearchPath(SEARCH_CUR_DIRECTORY OR   /* Search control
                                                        vector */
                           SEARCH_ENVIRONMENT,
                           ENVVARNAME,              /* Search path reference
                                                       string */
                           FILENAME,                /* File name string */
                           ResultBuffer,            /* Search result
                                                            (returned) */
                           sizeof(ResultBuffer));    /* Length of search
                                                       result */

         IF rc=0 THEN
         BEGIN
              s:=ResultBuffer;
              //ShowMessage('Found desired file -- '+#13+S);Result:=True;
              Result:=True;
         END else
         Begin
              //ShowMessage('Nicht gefunden');Result:=FALSE;
               Result:=FALSE;
         End;
End;

Function MyUpcaseStr(st:string):string;
  var i : longword;new :String;
 BEGIN
      new:='';for i := 1 to length(st) do
      Begin
           new:=new+ upcase (ST[i]);
           IF ST[i]='Ñ' Then new[i]:='é';
           IF st[i]='Å' Then new[i]:='ö';
           if St[i]='î' Then new[i]:='ô';
      End;
      Result:=new;
End;

Function Prozent(CONST Current:Longint;CONST Maximum:Longint):Integer;
VAR Proz_Summe:Integer;
begin
     Proz_Summe:=Current*100 div Maximum;
     IF Proz_Summe<0 then Proz_Summe:=0;
     Prozent:=Proz_Summe;
End;

Function ToInt(S:String):LongInt; {Convert a String into a integer value}
 VAR E1:Integer;L:Longint;
   Begin
        VAL(S,L,E1);IF E1<>0 Then
        Begin
             //ErrorBox('Umwandlungs Fehler "ToLongint" bei String '+S+' bei Pos : '+ToStr(E1));
             L:=-32767
             End;
        Result:=L;
   End;

Function  FindWordinStri3(StringtoFind:String;StringToSearch:String;):integer;
{Returns Position in string where the word was found}
VAr loop:Byte;
    UpCaseSearchStr:String;
    HelpStr:String;
    Success:Boolean;
Begin

     Success:=FALSE;
     For loop:=1 to length(StringtoSearch) do
     begin
          //helpStr:=copy(StringToSearch,loop+7,7);
          HelpStr:=Copy(StringToSearch,loop+length(StringtoFind),length(StringToFind));
          if HelpStr=StringtoFind then Begin result:=loop+length(StringToFind);Success:=TRUE;Break;end;
     End;
     if not success then
     Begin
          Result:=-1;
          //ErrorBox('Fehler TCPUtility Unit: angegebner String konnte nicht gefunden werden'+#13+'Such String :'+StringToFind);
     End;
End;




Function GetIPAdressfromString(S:String;StartPos:Byte):String;
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


Function GetIPAdressfromString2(S:String):MultiIp;
// returns a correct IP Adress
LABEL START;
VAR Loop:Byte;loop2:Byte;ReturnStr:String;IPCount:Byte;
Begin
     IpCount:=0;loop2:=1;
     START:
     ReturnStr:='';
     For Loop:=loop2 to length(S) do
     begin
          IF (S[loop] in ['0'..'9']) Then ReturnStr:=ReturnStr+S[Loop];
          IF S[Loop] = '.' Then ReturnStr:=ReturnStr+'.';
          IF S[Loop] = ' ' Then Begin inc(IPCount);break;End;
     End;
     Result.IpAdress[IPCount]:=ReturnStr;
     Loop2:=Loop+1;
     IF IpCount=2 Then exit else goto start;
End;

Function FillStr(S:String;FillLength:Byte):String;
VAR
    SourceLength:Byte;
    Loop:Byte;
    Start:Byte;
Begin
     SourceLength:=Length(S);
     //IF SourceLength>FillLength then begin ErrorBox('AuffÅll Menge zu klein , String is grîsser !');exit;End;
     IF SourceLength>FillLength then begin Result:=Copy(S,1,fillLength);Exit;End;
     IF SourceLength=FillLength Then Begin result:=S;Exit;ENd;//ErrorBox('AuffÅll Menge und String sind gleich gross');exit;End;
     Start:=FillLength-SourceLength;
      Repeat
            S:=S+' ';
       Until length(S)=FillLength;
          Result:=S;
          Start:=length(S);
End;

Function HostStr(S:String;FillLength:Byte):String;
VAR
    SourceLength:Byte;
    Loop:Byte;
    Start:Byte;
Begin
     SourceLength:=Length(S);
     IF SourceLength>FillLength then begin Result:=Copy(S,1,fillLength);Exit;End;
     IF SourceLength=FillLength Then Begin result:=S;Exit;ENd;//ErrorBox('AuffÅll Menge und String sind gleich gross');exit;End;
     Start:=FillLength-SourceLength;
      Repeat
            S:=S+' ';
       Until length(S)=FillLength;
          Result:=S;
          Start:=length(S);
End;

Function IsIpAdressValid(IP:String;ZeroStr:Boolean):IPError;
// check if there are a "." after each value
VAR loop:Byte;
    HelpChar:char;
    PointCounter:Byte;
    PointArray:Array[1..3] of Byte;
    DebugByte:Byte;
    IPStr1:String;
    IpStr2:String;
    IpStr3:String;
    IpStr4:String;
    StartPos,EndPos:Byte;

    Procedure ReSetErrorType;
    Begin
     Result.InvalidNumber:=FALSE;
     Result.NumberofPoints:=PointCounter;
     Result.PointOverflow:=FALSE;
     Result.MissingPoint:=FALSE;
     Result.MissingNumber:=FALSE;
     Result.InValidSigns:=FALSE;
     Result.Valid:=FALSE;
    End;

    Procedure NumberCheck(Param:byte);
    VAR IP_Str:String;
    Begin
    IF Param=1 Then IP_Str:=IpStr1;
    IF Param=2 Then IP_Str:=IpStr2;
    IF Param=3 Then IP_Str:=IpStr3;
    IF Param=4 Then IP_Str:=IPStr4;

    Result.Valid:=FALSE;
    For Loop:=1 to length(Ip_Str) do
     begin
          Case Ip_Str[loop] of
          '0'..'9':Result.Valid:=TRUE;
          else
              Begin
                   Result.VALID:=FALSE;
                   Exit;
              ENd;
          End;
    End;
    Result.InvalidSigns:=True;
    IF ToInt(IP_Str)>255 Then Begin Result.InvalidNumber:=TRUE;Result.Valid:=FALSE;Exit;End;
    //Result.Valid:=TRUE;
End;

Begin
     IF ZeroStr Then
     Begin
          IF IP='' then Begin Result.Valid:=TRUE;Exit;End;
     End;
     ReSetErrorType;PointCounter:=0;
     For loop:=1 to length(IP) do
     begin
          HelpChar:=IP[loop];
          Case HelpChar of
          '.' : Begin inc(PointCounter);PointArray[PointCounter]:=loop;End;
          ' ' : Begin Result.InValidSigns:=TRUE;Exit;End;
          'a'..'z':Begin Result.InvalidSigns:=TRUE;Exit;End;
          'A'..'Z':Begin Result.InvalidSigns:=TRUE;Exit;End;
          End;
     End;
     IF POintCounter>3 Then Begin Result.PointOverflow:=True;Exit;End;
     IF PointCounter<3 Then Begin Result.MissingPoint:=TRUE;Exit;End;
     DebugByte:=PointArray[3]+1;
     HelpChar:=IP[PointArray[3]+1];
     IF not (HelpChar in ['0'..'9']) Then Begin Result.MissingNumber:=True;exit;end;

     StartPos:=1;EndPos:=PointArray[1]-StartPos;
     IpStr1:=Copy(IP,StartPos,EndPos);

     StartPos:=PointArray[1]+1;EndPos:=PointArray[2]-StartPos;
     IpStr2:=Copy(IP,STartPos,EndPos);

     StartPos:=PointArray[2]+1;EndPos:=PointArray[3]-StartPos;
     IpStr3:=Copy(IP,StartPos,EndPos);

     StartPos:=PointArray[3]+1;EndPos:=length(IP)-startpos+1;
     IpStr4:=Copy(IP,StartPos,EndPos);


     Numbercheck(1);IF not Result.Valid Then exit;
     Numbercheck(2);IF not result.Valid Then Exit;
     Numbercheck(3);IF not result.Valid Then exit;
     Numbercheck(4);IF Not result.Valid then exit;
End;

Function QuerySelectedListBoxIndex(LB:TListBox):longint;
VAR TEST:Byte;
Begin
     For Test:=1 to LB.items.count do
     Begin
          IF LB.selected[Test-1] Then Begin Result:=Test-1;exit;End;
     End;
     Result:=-1;
End;

Function IsHostNameValid(aHostName:String):IPError;
Begin
     IF ( POS(' ',aHostName)<>0 )  or (aHostName='') Then Result.Valid:=FALSE else Result.Valid:=TRUE;
     IF AHostname='' Then Result.Valid:=FALSE;
End;

Function FileSplit(S:String;Mode:Byte):String;
var dirstr,namestr,extstr:String;
{
MODE Schalter : 1=Nur Verzeichniss Name wird zurÅcggeliefert
                2=Nur Name+Extension des Dateinamens wird zurÅckgelifert (ohne Pfad)
                3=Nur die Extension
                4=Nur den Dateinamen
}

begin
     Fsplit(S,dirstr,namestr,extstr);
     IF length(dirstr)=3 Then DirStr:=DirStr+'\';
     setlength(dirstr,length(dirstr)-1);
     Case mode of
     1:Result:=dirStr;
     2:Result:=NameStr+ExtStr;
     3:Begin Result:=MyUpCaseStr(ExtStr);End;
     4:Result:=NameStr;
     End;
End;

Function GetHostNameString(S:String;StartPos:Byte):String;
// returns a correct HOSTName
VAR Loop:Byte;ReturnStr:String;Upper:String;
Begin
     ReturnStr:='';Upper:=MyUpcaseStr(S);
     For Loop:=StartPos to length(S) do
     begin
          IF ( Upper[loop] in ['A'..'Z'] ) Then ReturnStr:=ReturnStr+S[Loop];
          IF (S[loop] in ['0'..'9']) Then ReturnStr:=ReturnStr+S[Loop];
          IF S[Loop] = '.' Then ReturnStr:=ReturnStr+'.';
          IF S[Loop] = ' ' Then break;
          IF S[Loop] = '-' then ReturnStr:=ReturnStr+'-';
          IF S[Loop] = '_' then ReturnStr:=ReturnStr+'_';
     End;
     Result:=ReturnStr;
End;

Function NLSFilename(AFileName:String):String;
Begin
     Result:=FileSplit(AFileName,4);
     //Result:=Copy(S,1,POS('.',AFilename)-1);
End;

Procedure ProcessQueMessage;
VAr Que       :Qmsg;
    Ahab      :HAB;
{
 Versendet Nachrichten, soda· wÑhrend einer REPEAT UNTIL Schleife auf Diverse MAUS Abfragen Reagiert werden kann
 Erstellt am 02.09.96
 }
Begin
     While WinPeekMsg(ahab,Que,0,0,0,PM_REMOVE) do WinDispatchMsg(Ahab,Que);
End;


     Procedure SocksString(VAR START:Byte;VAR Output:String);
     Begin
     End;

    Procedure SocksString2(VAR START:Byte;VAR Output:String);
   VAR LocalLoop:Byte;AString:String;
   Begin
               AString:='';
               For LocalLoop:=Start to length(ConfigStr) do
               begin
                    IF ConfigStr[localLoop]<>' ' then aString:=aString+CONFIGStr[LocalLoop] else break;
               End;
               Start:=LocalLoop;
               Output:=aString;
   End;

   Function MyToStr(i:LONGINT):String;
   Begin
        result:=System.Tostr(i);
        If System.length(result)<2 Then result:='0'+result;
   End;

Function BackupFolder:String;
VAR IOError:integer;
Begin
     {Result:=ProgramSettings.BackupPath+'\BKP#'+MyToStr(ProgramSettings.BackupCounter);}
     Result:=Application.ProgramIniFile.ReadString('Settings','BACKUP_PATH','')+'\BKP#'+MyToStr(Application.ProgramIniFile.ReadInteger('Settings','BACKUP_COUNTER',0));
     {$I-}
     MKDir(Result);IOError:=IoResult;
     Case IOError of
     5:exit; // Folder already exists
     0:exit; // Folder does exists and was successfuly created
     else  {MyErrorBox(NlsString('ERRORS','NewDir_Failed'+#13+'Errorcode : '+ToStr(IoError)));}
     End;
End;


Function SignsInString(aChar:Char;StringToSearch:string):Byte;
// Returns how many times a string contains a char (e.g. "#")
VAR Value,Loop:Byte;
Begin
     Value:=0;
     {While POS(aChar,StringToSearch)>0 do inc(Value);} // This BP routine does not work in Sybyl - creates endless loop in sybyl ??
     For loop:=1 to length(StringToSearch) do
     begin
          IF StringToSearch[loop]=aChar Then inc(Value);
     End;
     Result:=Value;
End;

 Procedure Directory_Scan(Dir_to_Scan:String;VAR DirList:TStringList);
 VAR
    DirInfo:TSearchRec;
    DosError:LongInt;

 {Scans a given Directory , and returns all subdirectorys in it}
 Begin
      Dir_To_Scan:=Dir_To_Scan+'\*.*';
      DosError:=SysUtils.Findfirst(Dir_To_scan,Anyfile,DirInfo);

      While DosError=0 do
      Begin
           IF DirInfo.Attr=faDirectory then
           Begin
                SHowMessage(DirInfo.Name+' /  '+ToStr(DirInfo.Attr));
                IF (DirInfo.Name <> '.') and (DirInfo.Name <>'..') Then
                   Begin
                        DirList.Add(DirInfo.Name);
                    End;
           End;
           DosError:=Sysutils.FindNext(DirInfo);
      End;
      IF DOSError<>0 Then
      Begin
           IF DOsError<>-18 Then MyErrorBox('Warning DOS Error appeart !'+ToStr(DosError));
      End;
      SysUtils.FindCLose(DirInfo);
      //DirList.Delete(0);
      //DirList.Delete(0);
 End;
        Function ParamString(Input:String;Val1,Val2:Longint):String;
        VAR Output:String;
            loop:Byte;
            s2:String;    
        Begin
                Output:=Input;
                For Loop:=1 to length(Input) do
                begin
                        IF copy(Input,loop,2)='%1' Then
                        Begin
                                delete(output,loop,1);
                                delete(output,loop,1);
                                insert(ToStr(Val1),Output,loop);
                        End;
               ENd;
               For Loop:=1 to length(output) do
               Begin
                        IF copy(output,loop,2)='%2' Then
                        Begin
                                delete(output,loop,1);
                                delete(output,loop,1);
                                insert(ToStr(Val2),Output,loop);
                        End;
                End;
                Result:=Output;
        End;


Function QueryBootDrive: char;
var
  buffer: longword;
begin
  DosQuerySysInfo( QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,buffer,sizeof( buffer ) );
  Result := chr( ord( 'A' ) + buffer - 1 );
end;

Function MultiValueToString(const aStringList:TStrings):String;
var counter:Longint;
    aStr:String;
Begin
     IF aStringList.count=0 Then Begin Result:='';Exit;End;
     aStr:='';
     For Counter:=0 to astringlist.count-1 do
     Begin
          aStr:=aStr+astringlist[counter]+' ';
     End;
     Result:=aStr;
End;

Function MultiValueString(Const S:String;aStringList:TSTringList;CompareChar:Char):Boolean;

Label Weiter;

VAr Loop:Byte;
    List2:TStringlist;

          Procedure CompareString(compChar:Char);
          VAR
             Counter,Posi:Integer;
             AString,Test:String;

          Begin
           counter:=-1;AString:='';
           For Posi:=1 to length(S) do
           begin
                IF S[Posi]<>CompCHar then aString:=AString+S[Posi] else
                Begin
                     inc(counter);
                     Test:=aString;
                     IF Test<>'' Then  aStringlist.add(aString);
                     aString:='';
                End;
            End;
          astringlist.add(astring);
          End;


Begin
    Result:=FALSE;
    aStringList.Clear;
    IF POS(ComPareChar,S)<>0 Then Begin COmpareString(CompareChar);Result:=True;exit;End;
End;



Function GetEnvString(S:String):String;
// Input = SET LPR_SERVER=MY.Own.Server Output = My.Own.Server
VAR Posi:Byte;
Begin
     Posi:=POS('=',S);
     Result:=Copy(S,posi+1,length(S));
End;


FUNCTION Power(X,Y:Word):LongInt;

VAR Temp,Teller : LongInt;

BEGIN
  TEMP:=1;
  FOR Teller:=1 TO Y DO TEMP:=TEMP*X;
  Power:=Temp;
END; { Power }

FUNCTION Hex2Dec(Hex:STRING):LongInt;

VAR   T1,T2,Dec   :       LongInt;
      Error       :       Boolean;

BEGIN
  Error:=False;
  T1:=0;T2:=0;DEC:=0;
  FOR T1:=1 TO LENGTH(Hex) DO
  BEGIN
   T2:=Length(Hex)-T1;
   CASE Hex[T1] OF
   '0'  : DEC:=DEC+0;
   '1'  : DEC:=DEC+Power(16,T2);
   '2'  : DEC:=DEC+2*Power(16,T2);
   '3'  : DEC:=DEC+3*Power(16,T2);
   '4'  : DEC:=DEC+4*Power(16,T2);
   '5'  : DEC:=DEC+5*Power(16,T2);
   '6'  : DEC:=DEC+6*Power(16,T2);
   '7'  : DEC:=DEC+7*Power(16,T2);
   '8'  : DEC:=DEC+8*Power(16,T2);
   '9'  : DEC:=DEC+9*Power(16,T2);
   'A','a' : DEC:=DEC+10*Power(16,T2);
   'B','b' : DEC:=DEC+11*Power(16,T2);
   'C','c' : DEC:=DEC+12*Power(16,T2);
   'D','d' : DEC:=DEC+13*Power(16,T2);
   'E','e' : DEC:=DEC+14*Power(16,T2);
   'F','f' : DEC:=DEC+15*Power(16,T2);
   ELSE Error:=True;
   END;
  END;
  Hex2Dec:=Dec;
  IF Error THEN Hex2Dec:=0;
END; { Hex2Dec }


Procedure MultiSocksString(Const S:String;aStringList:TSTrings;CompareChar:Char);

Label Weiter;

VAr Loop:Byte;

          Procedure CompareString(compChar:Char);
          VAR
             Counter,Posi:Integer;
             AString,Test:String;

          Begin
           counter:=-1;AString:='';
           For Posi:=1 to length(S) do
           begin
                IF S[Posi]<>CompCHar then 
                Begin 
                        IF S[POSI]<>' ' Then aString:=AString+S[Posi];
                END 
                        else
                Begin
                     inc(counter);
                     Test:=aString;
                     IF Test<>'' Then  aStringlist.add(aString);
                     aString:='';
                End;
            End;
          astringlist.add(astring);
          End;


Begin
    aStringList.Clear;
    COmpareString(CompareChar);
End;

Function QuotationMarkCut(S:String):String;
{ Entfernt das AnfÅhrungszeichen am ende oder anfang eines Strings}
VAR Posi:Byte;
Begin
     IF S[1]='"' Then delete(S,1,1);
     IF S[length(S)]='"' Then delete(S,length(S),1);
     Result:=S;
End;


Function NewProtValueString(Const S:String;aStringList:TSTringlist):ShortInt;
VAR 
        Loop:Byte;
        ProtName:String;
{
Version 2 : 20.10.2006
}
Begin
            aStringList.Clear;
            ProtName:='';

        // Suche die gesammte zeichenkette nach Beistrichen "," ab.
        For Loop:=1 to Length(S) do 
        Begin
                
                IF S[loop]<>',' Then ProtName:=ProtName+S[Loop]  // keine Beistrich , dann Protokollnamen um Zeichen erweiteren
                                else Begin 
                                        {
                                        Beistrich gefunden, Protokollnamen nur hinzufÅgen wenn nicht "Protname" nicht leer ist
                                        dies verhindert, das wenn mehrere Beistriche am Ende stehen (z.b. EL90XIO2_NIF,,,  diese 
                                        auch hinzugefÅgt werden
                                        }
                                        IF ProtName<>'' Then  aStringlist.add(ProtName);
                                        ProtName:='';
                                     End;
        End;

        // Wenn ProtName ungleich Leer, dann ProtokollNamen in Stringliste hinzufÅgen.
        If ProtName<>'' Then  aStringlist.add(ProtName);
        Result:=aStringList.Count;
End;


Function  ProtValueString(Const S:String;aStringList:TSTringList):ShortInt;
{
Query the amount of stored Protocols inside the  entry "BINDINGS" in protocol.ini
e.g.
#1
input : EL90XIO2_NIF,,,
output in aStringlist : EL90XIO2_NIF
#2
input : EL90XIO2_NIF,ABC_NIF,,
output in aStringlist :
                      EL90XIO2_NIF
                      ABC_NIF
The functions returns how many items are stored inside the "astringlist" field
}
VAr aByte:Longint;

          Procedure CompareString(compChar:Char);
          VAR                                                          
             Counter,Posi:Integer;                                     
             AString,Test:String;                                      
                                                                       
          Begin                                                        
           counter:=-1;AString:='';                                    
           For Posi:=1 to length(S) do                                 
           begin                                                      
                IF S[Posi]<>CompCHar then
                Begin
                     aString:=AString+S[Posi];
                End
                else
                Begin                                                                
                     inc(counter);                                             
                     Test:=aString;
                     IF Test<>'' Then
                        Begin
                             aStringlist.add(aString);
                             result:=aStringlist.count;
                        End;
                     aString:='';                                             
                End;                                                          
            End;                                                               
          astringlist.add(astring);
          End;

Begin

    aStringList.Clear;aByte:=aStringlist.count;

    IF POS(' ',S)<>0 Then
    Begin
         CompareString(' ');
         Exit;
    End;
    IF POS(',',S)<>0 Then
    Begin
         COmpareString(',');
         Exit;
    End;
    aStringList.add(S);
End;
        
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

Function MakeRestoreFileName(S:String):String;
{Version 1 06.12.2005
Input  = BKP#49 : 11.11.2005 19:18:00
Output = BKP#49
}
VAR P:Byte;
Begin
     P:=Pos(':',S);
     Result:=Copy(S,1,P-2);
End;

{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
 ∫                                                                          ∫
 ∫     Procedure GetCurrentDateTime                                         ∫
 ∫                                                                          ∫
 ∫     Query current system date / time and stores them in a TDateTime Rec  ∫
 ∫     Version 1 : 24.10.2006                                               ∫
 »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}
Procedure GetCurrentDateTime(var DateTime:TDateTimeRec;DateFormat:Byte);
{DateFormat:
        1=European Date format (Year / Month / Day)
        2=U.S. Date Format (Year / Day / Month)
        3=Day / Month / Year
}
VAR 
        Year,Month,Day,Weekday:Word;
        Hour,Minute,Second,Sec100: Word;
        YearStr,MonthStr,DayStr,WeekDayStr:String[4];
        HourStr,MinuteStr,SecondStr:String[2];

        Procedure Convert;
        Begin
                YearStr:=toStr(Year);
                IF Month<10 then MonthStr:='0'+toStr(Month) else MonthStr:=toStr(Month);
                IF Day<10 Then DayStr:='0'+toStr(Day) else DayStr:=toStr(day);
                IF Hour<10 Then HourStr:='0'+toStr(Hour) else HourStr:=toStr(Hour);
                IF Minute<10 Then MinuteStr:='0'+toStr(Minute) else MinuteStr:=toStr(Minute);
                IF Second<10 Then Secondstr:='0'+toStr(Second) else SecondStr:=toStr(Second);
        End;
Begin
        
        GetDate( Year, Month, Day, Weekday );
        GetTime( Hour, Minute, Second, Sec100 );
        Convert;
        IF DateFormat=1 Then DateTime.DateStr:=YearStr+'.'+MonthStr+'.'+DayStr;
        IF DateFormat=2 Then DateTime.DateStr:=YearStr+'.'+DayStr+'.'+MonthStr;
        IF DateFormat=3 Then DateTime.DateStr:=DayStr+'.'+MonthStr+'.'+YearStr;
        DateTime.TimeStr:=HourStr+':'+MinuteStr+':'+SecondStr;
End;


Function FileCopy(Source,Destination:CString):Boolean;
VAR RC:Longint;aString:String;
Begin
     RC:=DOSCOpy(Source,Destination,DCPY_EXISTING);
     IF RC<>0 Then
     Begin
          ErrorBox2(GetNLSString('ERRORS','CPY_BACKUP_FAILED')+#13+GetNLSString('ERRORS','CPY_FILENAME')+' '+Source+' '+GetNLSString('ERRORS','CPY_ERRORMESSAGE')+#13+SysErrorMessage(RC) );
          Result:=FALSE;
     End else Result:=TRUE;
End;

Procedure MakeAliasMultiString(InterfaceNo:Longint;VAR MultiColString:TStrings);
VAR aLoop:Byte;
Begin
     {IF AliasRec[InterfaceNo].AliasIP.Count=0 Then Begin MultiColString.Clear;exit;ENd;
     For aLoop:=0 to AliasRec[InterfaceNo].AliasIP.count-1 do
     Begin
          TRY
          MultiColString.Add(AliasRec[InterfaceNo].AliasIP[aLoop]+'|'+AliasRec[InterfaceNo].AliasSubnet[aLoop]);
          Except Raise Exception.Create('Schutzverletzung in TCPUtilityUnit ->Funktion MakeAliasMultiString');Halt;
          End;
     End;  }
End;

Function GetTCPIPDosPath(InputStr:String):String;
// Extract the TCPIP\BIN Path into only "TCPIP" and adds the string \DOS\ETC to it
VAR I:Byte;
Begin
        For I:=length(InputStr) downto 4 do
        Begin
                IF InputStr[I]='\' Then 
                Begin 
                        Delete(InputStr,i,Length(InputStr));
                        Result:=InputStr+'\DOS\ETC';
                        Break;
                End;
        ENd;

End;

Procedure IncIniCounter(IniSection:String);
// Valid Sections : PROFIL_COUNTER , BACKUP_COUNTER
// Note : Must be uppercase !
VAR TMP:Byte;

Begin
     // Read value from INI
     Tmp:=Application.ProgramIniFile.ReadInteger('Settings',IniSection,-1);IF Tmp= -1 Then Begin ErrorBox('Fehler in IncIniCounter !'+#13+'Section : '+IniSection+' nicht gefunden !');Halt;End;
     // check if not greater 254 else set it to 0
     IF TMP+1<254 then inc(Tmp) else Tmp:=0;
     // write back value to INI
     Application.ProgramIniFile.WriteInteger('Settings',IniSection,TMP);
End;

Function IsFtpdIBM(Filename:string):Boolean;
{
This will search the FTPD.EXE for the signs "IBM TCP/IP"
Returns TRUE if the FTPD.EXE is the IBM FTPD Server
Returns FALSE if the FTPD.EXE is not the IBM FTPD Server
Version 1 22.11.2006

}
VAR aFile:FIle;
    Data:Array[0..255] of Byte;
    loop:Byte;
    Stri:String;
    Readed:Longword;
    IOError:Longint;


Begin
                Result:=FALSE;FileMode:=FMInput;
                {$I-}
                Assign(aFile,FileName);
                Reset(aFile,1);IoError:=IOResult;FileMode:=FMInout;
                 IF IOError<>0 Then
                 Begin
                      ErrorBox2(Filename+#13+SysErrorMessage(IoError));Exit;
                 End;
                 REPEAT
                       STRI:='';BlockRead(afile,Data,Sizeof(Data),Readed);IOError:=IOResult;
                       IF IOError<>0 Then Begin FileReadError(IOError,'FTPD.EXE');CLose(aFile);Exit;End;
                       For Loop:=0 to 255 do
                       Begin
                            Stri:=Stri+Chr(Data[Loop]);
                       End;
                       IF FindWordInStri3('IBM TCP/IP',Stri)<>-1 Then
                       Begin
                            Close(aFile);Result:=True;
                            exit;
                       End;
                Until Readed=0;
                Close(aFile);
                {$I+}
End;

Function GetMultiValueString(MCStr:String;Col:Byte):String;
VAR
        Counter:Byte;
        WorkStr:String;
        ColumCount:ShortInt;
        OutputStr:String;
Begin
        WorkStr:='|'+MCStr+'|';ColumCount:=-1;OutputStr:='';
        For Counter:=1 to length(WorkStr) do
        Begin
                IF WorkStr[Counter]='|' Then inc(columCount);
                IF ColumCount=Col Then
                Begin
                        REPEAT
                                Inc(Counter);
                                OutPutStr:=OutPutStr+WorkStr[Counter];
                        Until WorkStr[Counter]='|';
                        Delete(OutputStr,length(outputStr),1);
                        Result:=OutputStr;
                        exit;
                End;
        End;
        ErrorBox('Fehler bei GetMultiValueString : Angeforderte Zeile ('+toStr(COL)+') ist nicht vorhanden !');
ENd;

Function FindMultiValueListItem(S:String;MV_Field:TStrings):Longint;
VAR
   Loop:Longint;
   Name:String;
   DummyS:String;
Begin
     For Loop:=0 to MV_Field.count-1 do
         Begin
              Name:=FileSplit( GetMultiValueString(MV_Field[loop],1),FSplit_FileNameOnly);
              IF Uppercase(S)=Uppercase(Name) Then
              Begin
                   IF uppercase(Name)='FTPD' Then
                   Begin
                        {IF GetFileEaData(Name,FALSE,DUMMYS)='IBM FTPD' Then
                        Begin
                             Result:=loop;
                             Exit;
                        End;}
                        IF IsFtpdIBM(GetMultiValueString(MV_Field[loop],1)) Then
                                     Begin
                                          Result:=loop;exit;
                                     End;
                   End else
                   Begin
                        Result:=loop;
                        Exit;
                   End;
              End;
         End;
         Result:=-1;
End;



Function NewQueryProcess(S:String;Dummy:Byte):String;
VAR
   PList:TStringlist;
   Index:Longint;
Begin
     Plist.Create;
     GetProcessList(PList); // Get the processlist and store it into Plist
     Index:=FindMultiValueListItem(S,Plist);
     IF Index<>-1 Then
     Begin
          Result:=GetMultiValueString(Plist[Index],0);
     End else result:='-1';

     Plist.Destroy;
End;


End.


{1.11.2006 Umstellung auf OS/2 INI Dateiformat
           - Unit GetBacupFolder
 1.11.2006 Neue Funktion GetTCPIPDosPath hinzugeÅgt
 1.11.2006 Neue Prozedure : IncIniCounter
 20.11.2006 Neue Prozedure : NewQueryProcess
 22.11.2006 Neue Function : ISFTPDIBM hinzugefÅgt
}