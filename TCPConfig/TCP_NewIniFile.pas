Unit TCP_NewIniFile;

Interface
Uses UString,Classes, Forms, Graphics, StdCtrls, Buttons,Dialogs;

 CONST MaxIniIdents=100;


         Type
             TNewAsciiIniFIle=Class(TObject)
             Protected
             AIniFIle:Text;
             AIniString:String;
             SectionList:TStringlist;
             IdentList:Array[0..MaxIniIDents] of TStringList;
             ValueList:Array[0..MaxIniIdents] of TSTringList;
             Procedure GetSections;
             IniFilename:String;
             Function MyIndexof(S:String):Longint;
             PUBLIC
             Constructor Create(aFileName:String);
             Destructor Destroy;Override;
             Procedure ReadSections(VAR Sections:TStrings);
             Function ReadSection(Section:String;VAR Return:TStrings):Boolean;
             Function ReadString(Section,IDENT:String;VAR Return:String):Boolean;
             ErrorString:String;

         End;
VAR
   NLSIni:TNewAscIIIniFile;
   IniFileOpened:Boolean;
Implementation

USES MyMessageBox,SysUtils,DOS;

VAR LastSection:String;
    D1,d2,d3:String;
    Looper:Longint;

Function TNewAscIIIniFile.MyIndexof(S:String):Longint;
// for debug purpose only
Begin
     For Looper:=0 to IdentList[1].count-1 do
     Begin
          D1:=Uppercase(S);
          D2:=Uppercase(Identlist[1].Strings[looper]);
          IF D1=D2 Then
          Begin
               Result:=Looper;exit;
           End;
     End;
     Result:=-1;
End;

Function FileSplit(S:String;Mode:Byte):String;
var dirstr,namestr,extstr:String;
{
MODE Schalter : 1=Nur Verzeichniss Name wird zurÅcggeliefert
                2=Nur Name+Extension des Dateinamens wird zurÅckgelifert
}

begin
     Fsplit(S,dirstr,namestr,extstr);
     IF length(dirstr)=3 Then DirStr:=DirStr+'\';
     setlength(dirstr,length(dirstr)-1);
     Case mode of
     1:Result:=dirStr;
     2:Result:=NameStr+ExtStr;
     End;
End;


Function InFrontSpaceCut(aStr:String):String;
{
  Schneided alle Leerzeichen am Anfang eines Strings aus Z.b. '    TEST' = 'Test'
  Leerzeichen am Ende eines Strings werden nicht abgeschnitten
  Version 1 05.11.2005
}

VAR 
        StrCount:Byte;
        WorkStr:String;
        SpaceCount:Byte;
Begin
        Result:='';SpaceCount:=0;
        For StrCount:=1 to length(aStr) do
        Begin
                IF aStr[StrCount]=' ' then inc(SpaceCOunt) else break;

        End;
    
        Delete(aStr,1,SpaceCount);
        Result:=aStr;
End;


Function ValidEntry(S:String):Boolean;
// öberprÅfen, ob der Eintrag gÅltig ist oder nicht
Begin
     Result:=TRUE;
     // 1.öberprÅfen auf Leerzeichen am Anfang des Strings - wenn ja nicht gÅltig
    // IF S[1]=' ' Then Begin Result:=FALSE;Exit;End;
     IF Length( InFrontSpaceCut(S) )=0 Then Begin Result:=FALSE;Exit;End;
     IF length(S)=0 Then Begin Result:=FALSE;Exit;END;
     IF S[1]=#9 Then Result:=FALSE;
End;


Function CutStr(S:String):String;
VAR
   Counter:Byte;
Begin
     Result:=copy(S,2,Length(S)-2);
End;


Procedure SplitIniString(S:String;VAR Ident,Value:String);
VAR
   PosI:Byte;
   TmpValue:String;
Begin
  // Caption                 = TCP/IP - Server-Dienste Assistent

  Posi:=Pos('=',S);IF Posi=0 Then
  Begin
       MyErrorBox('Wrong INI File format, IDENT must contain a = to assign a value to the ident.'+#13+'String : '+#13+S+#13+'Last Section : '+LastSection);Halt;
  End;
  Ident:=Copy(S,1,Posi-1);
  TmpValue:=Copy(S,Posi+1,Length(S));
  Value:=InFrontSpaceCut(TmpValue);

  // Rmove chr(9) signs inside the sting
  While
  pos(chr(9),Ident)<>0 do Delete(ident,pos(chr(9),ident),1);

  While
  pos(' ',Ident)<>0 do Delete(ident,pos(' ',ident),1);
End;



Function SpaceCut(SpaceStr:String):String;
VAR
   Counter:Byte;
Begin

     FOr Counter:=Length(SpaceStr) downto 1 do    // vom Ende des Strings herunterzÑhlen bis 1
     Begin
          IF SpaceStr[counter]=' ' Then delete(SpaceStr,counter,1);
          If SpaceStr[Counter]=#9 Then Delete (SpaceStr,counter,1);
     End;
 Result:=SpaceStr;
End;




Procedure TNewAscIIIniFile.GetSections;
VAR
   IOError:Longint;
   Ident,Value:String;
Begin
   //  Result:=FALSE;
     While not Eof(aIniFile) do
     Begin
          {$I-}
               Readln(aIniFile,aIniString);IOError:=IOResult;
               IF IOError<>0 Then
                                 Begin
                                      MyErrorBox('Read Error on INI-File : '+#13+IniFileName+#13+SysErrorMessage(IOError));
                                      Close(aIniFIle);exit;
                                 End;
               IF   (aIniString[1])='[' Then
               Begin
                    IF Length(aIniString)<>0 Then SectionList.add(CutStr(aIniString));LastSection:=aIniString;
               End else
               Begin
                   IF ValidEntry(aIniString) Then
                   Begin
                          IF SectionList.count=MaxIniIdents Then begin MyErrorBox('INI File Error : Maximum amount of Idents reached !)');Halt;End;
                          SplitIniString(aIniString,Ident,Value);
                          IdentList[SectionList.Count-1].add( Ident );
                          ValueList[SectionList.count-1].add( Value );
                   End;
               End;

          {$I+}
     End;
//Result:=TRUE;
End;

Constructor TNewAscIIIniFile.Create;
VAR IOError:Longint;loop:Byte;
Begin
     IF aFilename='' Then Begin MyErrorBox('Illegal INI Filename specified');Halt;End;
     Assign(aIniFile,aFileName);IniFIlename:=FileSplit(aFilename,2);
{$I-}
     ReSet(aIniFIle);IOError:=IOResult;
{$I+}
IF IOError<>0 Then
   Begin
        //MyErrorBox('INI File I/O Error : Unable to open requested ini file : '+#13+aFilename+#13+SysErrorMessage(IOError));Halt;
        MyErrorBox('Failed to open the file : '+filesplit(aFilename,2)+#13+SysErrorMessage(IOError));
        Halt;
   ENd;

   SectionList.Create;
   FOr loop:=0 to MaxIniIdents do
   Begin
        IdentList[loop].create;
        ValueList[Loop].Create;
   End;
   GetSections;
   CLose(aIniFIle);
   INiFileOpened:=TRUE;

End;

Procedure  TNewAscIIIniFile.ReadSections;
Begin
    Sections:=SectionList;
End;


Function TNewAscIIIniFile.ReadSection(Section:String;VAR Return:TStrings):Boolean;
VAR
   Index:Longint;
   Value:String;
Begin
     SectionList.CaseSensitive:=TRUE;
     Index:=SectionList.IndexOf(Section);
     IF Index=-1 Then
                     Begin
                          Result:=FALSE;
                          ErrorString:=FileSplit(IniFileName,2)+#13+'Section "['+Section+']" was not found';
                          exit;
                     End
                 else
                 Begin
                      Return:=IdentList[index];Result:=True;
                      ErrorString:='';
                 End;
End;




Destructor TNewAscIIIniFile.Destroy;
VAR Loop:Byte;
Begin
     SectionList.Destroy;
     FOr Loop:=0 to MaxIniIdents do Begin IdentList[loop].Destroy;ValueList[Loop].Destroy;End;
End;




Function TnewAscIIIniFile.ReadString(Section,IDENT:String;VAR Return:String):Boolean;
VAR
   SectionIndex:Longint;
   IdentIndex:Longint;
   IdentStr:String;
   ValueStr:String;

Begin
    Result:=FALSE;
    SectionIndex:=SectionList.IndexOF(Section);
    IF SectionIndex=-1 Then
    Begin Result:=FALSE;ErrorString:=FileSplit(IniFileName,2)+#13+'Section "['+Section+']" was not found';Exit;End
                       else
                 Begin
                      IdentIndex:=IdentList[SectionIndex].IndexOf(Ident);
                      IF IdentIndex=-1 Then
                      Begin
                           Result:=FALSE;
                           ErrorString:='LanguageFile : '+IniFIleName+#13+'Section '+#13+'['+Section+']'+#13+' does not contain Ident entry '+#13+Ident;
                           Exit;
                           //ErrorString:='IDENT "'+Ident+'" was not found in Section : '+Section+#13+'INI Filename : '+INiFilename;exit;
                      End else
                      Begin
                           Result:=True;Return:=ValueList[SectionIndex].Strings[IdentIndex];
                      End;
                 End;
End;

Initialization
INIFileOpened:=FALSE;
End.
