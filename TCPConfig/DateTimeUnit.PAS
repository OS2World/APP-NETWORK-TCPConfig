{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Date Time Unit  - Version 1 24.09.2006                                    บ
บ                                                                           บ
บ Unit zum Abfragen von Datum und Uhrzeit                                   บ
บ                                                                           บ
บ Das DateandTime Object bercksichtigt nationale Einstellungen von OS/2    บ
บ fr Datum und Uhrzeit.                                                    บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ


  Prozeduren :

  GetDateTime : Zum einholen des aktuellen Datums, ergebniss wird in "DateStr" und "TimeStr" gesichert.
  GetFileDateTime : Zum einholen des nderungs Datums einer Datei. Zustzlich wird auch noch die Gr”แe der Datei in 
                    2 verschiedenen Strings gesichert.

                    FileSizeStr1 : Enthlt die Dateigr”e in Bytes
                    FileSizeStr2 : Unterteilung in Bytes,Megabytes,Kilobytes,Gigabyte
}



Unit DateTimeUnit;

INTERFACE
USES DOS,SYSUTILS;

        
        Type    
                TDateAndTime =Class
                Private
                Decimal:String[2];                // Deciaml sign for values (e.g. "1,23" or "1.23")
                DateMode:Integer;               // Mode for Dateformat (0-3)
                TimeFormat:Integer;             // Mode for Timeformat (0-3)
                TrennzeichenD:String[2];     // Seperator Sign for Date ( \ or . )
                TrennZeichenT:String[2];     // Seperator Sign for Time ( : or . )
                AM           :String[20];    // Describtor for AM Text
                PM           :String[20];     // Describtor for PM Text
                Year,Month,Day,Weekday   :Word;  // Date variable
                Hour,Minute,Second,Sec100:Word;  // Time Variable
                YearStr,MonthStr,DayStr,WeekDayStr:String[4]; // String variables for Date
                HourStr,MinuteStr,SecondStr:String[2];         // String variables for Time
                amPM_Mode:Boolean;                              // TRUE=12h Mode , FALSE=24h MODE
                Procedure  MakeResult;
                Procedure  ConvertDateTime;        
                Function   AMPMString:String;
                Public
                TimeStr:String;
                DateStr:String;
                FileSizeStr1:String;                    // the Filesize in bytes ( 50000 )
                FileSizeStr2:String;                    // the Filesize either in Bytes,Kilobytes,Megabytes or Gigabytes
                CONSTRUCTOR Create; VIRTUAL;
                DESTRUCTOR Destroy; VIRTUAL;
                Procedure GetDateTime;
                Procedure GetFileDateTime(SearchInfo:TSearchRec);
                End;
VAR DateAndTime:TDateAndTime;
    DateAndTime1:TDateAndTime;
IMPLEMENTATION

{$IFDEF OS2}
Uses PMSHL; { OS/2 profile functions }
{$ENDIF}
{$IFDEF Win32}
Uses WinBase;
{$ENDIF}



Function ReadString(Const section, Ident, Default: String): String;
Var
  OutBuf: cstring;
Begin
  {$IFDEF OS2}
  Fillchar(OutBuf, 255, 0); {sometimes the #0 character is not copied (cdp.ini)}
  PrfQueryProfileString(HINI_USERPROFILE, Section, Ident, Default, OutBuf, 255);
  Result := OutBuf;
  {$ENDIF}
  {$IFDEF Win32}
  SetLength(Result,GetPrivateProfileString(
    Section,Ident,Default,cstring(Result[1]),255,FileName));
  {$ENDIF}
End;

Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;
Begin
  {$IFDEF OS2}
  Result := PrfQueryProfileInt(HINI_UserProfile, section, Ident, Default);
  {$ENDIF}
  {$IFDEF Win32}
  Result := GetPrivateProfileInt(section,Ident,Default,FileName);
  {$ENDIF}
End;


Function FillStr(S:String):String;
{
Fllt den angegeben String - welcher Nummerische Werte enthlt - auf eine fixe Position auf,
damit dieser korret in der Listbox untereinander dargestellt wird
Z.b. aus '110.20' wird '   110.20'
}
         Function counter:Byte;
         VAR Loop,counter1:Byte;
         Begin
              COunter1:=0;
              For Loop:=1 to length(S) do If S[loop]=' ' Then
              Begin
                   INC(COunter1);
               ENd;
               Result:=COunter1;
         End;

         Function expandstr(Value:Byte):String;
         VAR Loop:Byte;S:String;
         Begin
              S:='';FOr Loop:=1 to Value do S:=S+' ';Result:=S;
         End;

  VAR H:Byte;
Begin
    h:=counter;Delete(S,1,h);
    Case length(S) of
     4:BEgin
            Result:=ExpandStr(5)+S;
       End;
     5:Begin
            Result:=ExpandStr(3)+S;
       End;
     6:Begin
            Result:=ExpandStr(1)+S;
       End;
     End;
End;



Function CalcBytes(Size:Longint):String;
     VAR Ergebnis:Real;B:String;
     Begin
        Ergebnis:=Size;
        Str(Ergebnis:8:2,B);
        Result:=FillStr(B);
        
        End;

     Function CalcKiloByte(Size:Longint):String;
      VAR Ergebnis:Real;KB:String;
      Begin
        Ergebnis:=Size / 1024;
        str(Ergebnis:8:2,KB);
        Result:=FillStr(KB);
      End;

        Function CalcMegaByte(Size:Longint):String;
        Var Ergebnis:Real;Ergebnis2:Real;MB:String;
        Begin
                Ergebnis:=Size / 1024;
                Ergebnis2:=Ergebnis / 1024;
                str(Ergebnis2:8:2,MB);
                Result:=FillStr(MB);
        End;

        Function CalcGigaByte(Size:Longint):String;
        Var Ergebnis,ergebnis2,ergebnis3:Real;GB:String;
        Begin
                Ergebnis:=Size / 1024;
                Ergebnis2:=Ergebnis / 1024;
                Ergebnis3:=Ergebnis2 / 1024;
                Str(Ergebnis3:8:2,GB);
                Result:=FillStr(GB);
        End;



        Constructor TDateAndTime.Create;
        Begin
                
                DateMode:=ReadInteger('PM_National','iDate',-1);
                IF DateMode=-1 Then
                Begin
                        raise Exception.Create('** Fehler : Keine OS/2 Lndercode Unterstzung ! **');Halt;
                End;

                TrennZeichenD:=ReadString('PM_National','sDate','-1');
                IF TrennzeichenD='-1' Then
                Begin
                        raise Exception.Create('** Fehler : Trennzeichen "iDate" nicht gefunden !');Halt;
                End;

                TrennZeichenT:=ReadString('PM_National','sTime','-1');
                IF TrennzeichenT='-1' Then
                Begin
                        Raise Exception.Create('** Fehler : Trennzeichen "sTime" nicht gefunden !');Halt;
                End;

                TimeFormat:=ReadInteger('PM_National','iTime',-1);
                IF TimeFormat=-1 Then
                Begin
                        Raise Exception.Create('** Fehler : Zeitformart "iTime" nicht gefunden !');Halt;
                End;

                am:=ReadString('PM_National','s1159','-1');
                IF am='-1' Then
                Begin
                        Raise Exception.Create('** Fehler : Zeitformart "s1159" (am String) nicht gefunden !');Halt;
                End;

                pm:=ReadString('PM_National','s2359','-1');
                IF pm='-1' Then
                Begin
                        Raise Exception.Create('** Fehler : Zeitformart "s2359" (pm String) nicht gefunden !');Halt;
                End;
                Decimal:=ReadString('PM_National','sDecimal','-1');
                IF Decimal='-1' Then
                Begin
                        Raise Exception.Create('** Fehler : Decimalwert "sDecimal" nicht gefunden !');Halt;
                End;

        End;
        
        Destructor TDateAndTime.Destroy;
        Begin

        End;
        
        Function TDateAndTime.AMPMString:String;
        Begin
                IF amPM_Mode Then Result:=AM else Result:=PM;
        End;
        
        Procedure TDateAndTime.MakeResult;
        Begin
        
        Case DateMode of
        0:DateStr:=MonthStr+TrennZeichenD+DayStr+TrennZeichenD+YearStr;
        1:DateStr:=DayStr+TrennZeichenD+MonthStr+TrennZeichenD+YearStr;
        2:DateStr:=YearStr+TrennZeichenD+MonthStr+TrennZeichenD+DayStr;
        3:DateStr:=YearStr+TrennZeichenD+DayStr+TrennZeichenD+MonthStr;
        Else DateStr:=DayStr+TrennZeichenD+MonthStr+TrennZeichenD+YearStr;
        End;

        Case TimeFOrmat of
        0:TimeStr:=HourStr+TrennzeichenT+MinuteStr+TrennZeichenT+SecondStr+' '+AMPMString;
        1:TimeStr:=HourStr+TrennzeichenT+MinuteStr+TrennZeichenT+SecondStr;
        End;
End;

        Procedure TDateAndTime.ConvertDateTime;
        Begin
                YearStr:=ToStr(Year);
                IF Month<10 then MonthStr:='0'+ToStr(Month) else MonthStr:=ToStr(Month);
                IF Day<10 Then DayStr:='0'+ToStr(Day) else DayStr:=ToStr(day);

                IF TimeFOrmat=1 Then // 24 h Mode
                Begin
                        IF Hour<10 Then HourStr:='0'+ToStr(Hour) else HourStr:=ToStr(Hour);
                End;

                IF TimeFOrmat=0 Then // 12 h Mode
                // ABfrage erfolgt immer in 24H Modus !
                Begin
                        IF Hour in [1..11] Then AMPM_Mode:=TRUE;
                        IF Hour=12 Then AMPM_Mode:=FALSE;
                        IF Hour=0 Then Begin Hour:=12;AMPM_Mode:=TRUE;End;
                        IF Hour>12 Then Begin Hour:=Hour-12;AMPM_MODE:=FALSE;End;
                        IF Hour<10 Then HourStr:='0'+ToStr(Hour) else HourStr:=ToStr(Hour);

                End;
                IF Minute<10 Then MinuteStr:='0'+ToStr(Minute) else MinuteStr:=ToStr(Minute);
                IF Second<10 Then Secondstr:='0'+ToStr(Second) else SecondStr:=ToStr(Second);
        End;

        

        Procedure TDateAndTime.GetDateTime;
        Begin
                DOS.GetDate( YEAR, Month, Day, Weekday );
                GetTime( Hour, Minute, Second, Sec100 );
                ConvertDateTime;
                MakeResult;    
        End;        

        Procedure TDateAndTime.GetFileDateTime(SearchInfo:TSearchRec);
        Label Ausgang;
        VAR
           DT:DateTime;
           DecimalPos:Byte;

        Begin
                UnpackTime(SearchInfo.Time,DT);
                Year:=DT.Year;
                Month:=DT.Month;
                Day:=DT.Day;
                Hour:=Dt.Hour;
                Minute:=Dt.min;
                Second:=DT.Sec;
                ConvertDateTime;
                MakeResult;
                FileSizeStr1:=ToStr(SearchInfo.Size);
        IF SearchInfo.Size<1023 Then Begin FileSizeStr2:=CalcBytes(SearchInfo.Size)+' Byte(s)';goto Ausgang;End;
        IF SearchInfo.Size<1048575 Then Begin FileSizeStr2:=CalcKiloByte(SearchInfo.Size)+' Kilobyte';Goto Ausgang;End;
        IF SearchInfo.Size<1073741823 Then Begin FileSizeStr2:=CalcMegaByte(SearchInfo.Size)+' Megabyte';goto Ausgang;End;
        IF SearchInfo.Size>1073741823 Then Begin FileSizeStr2:=CalcGigaByte(SearchInfo.Size)+' Gigabyte';goto Ausgang;ENd;
Ausgang:
        DecimalPos:=POS('.',FileSizeStr2);
        IF DecimalPos<>0 Then FileSizeStr2[DecimalPos]:=Decimal[1];
        End;
End.
