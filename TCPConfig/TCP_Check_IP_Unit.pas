Unit TCP_Check_IP_Unit;


Interface
         CONST
              ChkOpt_ZeroAllowed=1;              // Allow ZEro ('') IP Adress as valid
              ChkOpt_ZeroNotAllowed=0;           // Zero ('') IP is not allowed to be valid

Function ValidIPAdress(IPString:String;CHeckOptions:Byte;EntryFieldName:String):Boolean;
Function ValidHostname(HostStr:String;NLSSection:String):Boolean;
Implementation

USES TCP_LanguageUnit,MyMessageBox,TCP_VAR_Unit;

VAR IP_INFO_REC:IPError;


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


Function IsIpAdressValid(IP:String;Option:Byte):IPError;
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
    //Result.InvalidSigns:=True;
    IF ToInt(IP_Str)>255 Then Begin Result.InvalidNumber:=TRUE;Result.Valid:=FALSE;Exit;End;
    //Result.Valid:=TRUE;
End;

Begin
     IF Option=ChkOpt_ZeroAllowed Then
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


Function ValidIPAdress(IPString:String;CHeckOptions:Byte;EntryFieldName:String):Boolean;
Begin
      IP_INFO_REC:=IsIPAdressValid(IPString,checkOptions);
      Result:=IP_Info_Rec.Valid;
      IF not IP_Info_Rec.Valid then
      Begin
       IF IP_Info_Rec.MissingPoint Then Begin MyInfoBOX(GetNLSString('MESSAGE',EntryFieldName)+#13+GetNLSString('MESSAGE','MISS_IP_POINT'));Exit;End;
       IF IP_Info_Rec.MissingNumber Then Begin MyInfoBOX(GetNLSString('MESSAGE',EntryFieldName)+#13+GetNLSString('MESSAGE','MISS_IP_NUMBER'));Exit;ENd;
       IF IP_Info_Rec.PointOverflow Then Begin MyInfoBOX(GetNLSString('MESSAGE',EntryFieldName)+#13+GetNLSString('Message','TOO_MUCH_POINTS'));Exit;End;
       IF IP_Info_Rec.InValidSigns Then Begin MyInfoBOX(GetNLSString('MESSAGE',EntryFieldName)+#13+GetNlsString('Message','ILLEGAL_CHAR'));Exit;End;
       IF IP_Info_Rec.InvalidNumber Then begin MyInfoBOX(GetNLSString('MESSAGE',EntryFieldName)+#13+GetNLSString('Message','IP_OUT_OF_RANGE'));Exit;End;
      End;
End;

Function ValidHostname(HostStr:String;NLSSection:String):Boolean;
  VAR Loop:Byte;
  
        Procedure DisplayError;
        Begin
             MyInfoBox(GetNlsString('MESSAGE','INVALID_Hostname'));
        End;
  Begin
      For loop:=1 to length(HostStr) do 
      Begin
                IF (HostStr[loop] in ['A'..'Z']) or (HostStr[loop] in ['a'..'z']) or (HostStr[loop] in ['.','-']) or (Hoststr[loop] in ['0'..'9']) Then Result:=True
                                                                                                                else Begin Result:=FALSE;DisplayError;Exit;END;
      End;
  End;

End.
