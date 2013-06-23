Unit EAZusatzUnit;

Interface
Procedure WriteFileEAData(FileName:String;Text:String);
Function GetFileEaData(FileName:String;ErrorDisplay:Boolean;VAR DateiTyp:String):String;
Implementation

USES system,Dialogs,sysutils;


Procedure WriteFileEaData;
VAR Z:byte;F:File of Byte;Info:PHoldFea;IOError:Longword;
Begin
       Filemode:=FMInout;
       {$I-}
       Assign(F,FileName);ReSet(F);IOError:=IOResult;
       IF IoError<>0 Then
          Begin
               ErrorBox('Error opening file'+#13+filename+#13+SysErrorMessage(IOError));
               Exit;
          End;

               NEW(INFO);                          // create Pointer to New EAInfo field
               INFO^.FEA:=0;
               Info^.CBName:=Length('.TYPE FTPD');  // the length of the type field
               INFO^.SZName:='.TYPE FTPD';          // the name of the type field
               INFO^.Deleted:=FALSE;               // mark this entry as not deleted
                                                   // create pointer to value record
               NEW(INFO^.AVALUE);

                INFO^.Avalue^[1]:=255;
                Info^.Avalue^[2]:=0;
                Info^.Avalue^[3]:=0;
                Info^.Avalue^[4]:=1;
                Info^.Avalue^[5]:=0;
                Info^.Avalue^[6]:=253;
                Info^.Avalue^[7]:=255;

                For Z:=1 to Length(Text) do
                Begin
                     INFO^.Avalue^[9+Z]:=ORD(TEXT[Z]); // copy the String "text" into a byte record
                End;

                INFO^.Avalue^[8]:=length(Text); // amount bytes in .avalue rec (length of the string "Text")
                INFO^.Avalue^[9]:=0;            // ??
                INFO^.CBValue:=Length(text)+10;  // ??
                // Abschluss Kennung ???
                //Info^.Avalue^[Length(Text)+10]:=0;
                //Info^.Avalue^[Length(Text)+11]:=76;
                For Z:=Length(Text)+10 to 255 do
                begin
                     INFO^.Avalue^[Z]:=0;
                End;
                INFO^.Avalue^[32]:=$FF;
                INFO^.NEXT:=NIL;         // No more records

                SetEadata(F,INFO); // INFO Feld in SP/2 FIlerecord Åbergeben

                //WriteEaData(F);    // Attribute in die Datei schreiben (API aufruf von unit SYSTEM)
                //EraseEaData(F);    // interne Zeiger wieder freigeben
               CLOSE(F);             // Write the EA Data
       Dispose(Info);
End;

Function GetFileEaData(FileName:String;ErrorDisplay:Boolean;VAR DateiTyp:String):String;{ VERSION 2.0 fÅr SIBYL , letzte énderung am 30.05.1998 wegen Fixpack #3
{
Achtung ! diese Routine funktioniert NICHT mit dem Orig.SIBYL RELASE sowie den Fixpack #1 !!!!
Sucht einen Eintrag "".TYPE AUDIO" in den EAÔS einer Datei
ErrorDisplay : TRUE zeigt Fehler an (wie nicht gefunden oder Keine EAÔS / FALSE = Keine Fehler anzeigen
}
VAR STRI:String;Z:Word;EAHilfeSTr:String;F:File of Byte;INFO:PHoldFea;Error:Integer;



        Procedure Make_String;
        Begin
             EAHilfeStr:='';
             //ShowMessage(ToStr(Info^.Avalue^[8]));
             For Z:=1 to INFO^.Avalue^[8] do
             Begin
                  INSERT(CHR(INFO^.Avalue^[9+Z]),EAHilfeStr,Z);
             End;
             //ShowMessage(Dummy);
             IF (Paramstr(1)='\EADEBUG') or (Paramstr(2)='\EADEBUG') Then ShowMessage('INhalt von ".TYPE AUDIO" :' +#13+EAHilfeStr);
        End;

        Function IstFehlerAufgetreten:Boolean;
        Begin
             IF Error=0 Then Begin Result:=FALSE;Exit;END;
             IF ErrorDisplay Then
             ErrorBox('Error on try reading EA-File'+#13+'Filename : '+FileName+#13+SysErrorMessage(Error));
             Result:=TRUE;
        End;

      Procedure NoEaData;
      Begin
           IF ErrorDisplay Then
           ShowMessage('There are no Extended Attributes in '+#13+'File :'+Filename);
      End;

      Procedure DEBUGEA;
      Begin
           ShowMessage('SzName : '+Stri+#13+'CBVALUE '+ToStr(Info^.cbvalue)+' '+'CBName :'+ToStr(Info^.cbname));
      End;

   Begin
     {$I-}
     FileMode:=FMInput;
     Assign(F,FileName);ReSet(F);Error:=IoResult;IF IstFehlerAufgetreten Then Begin Result:='Error';Exit;End;
     FileMode:=FMInout;
     INFO:=GetEaData(F); // EA Data Einholen (diese werden bei Aufruf RESET aus Unit SYSTEM eingelesen}
     IF INFO=NIL Then
     Begin
                 Result:='Empty';NoEaData;
                 Close(F);
                 Exit;
     End;
     While Info<>NIL do
     Begin
          Stri:=Info^.SZName;DateiTyp:=Stri;
          IF (Paramstr(1)='\EADEBUG') or (Paramstr(2)='\EADEBUG') Then DEBUGEA;
          IF STRI='.TYPE FTPD' Then Begin Make_String;Result:=EAHilfeStr;Close(f);exit;end;
          INFO:=Info^.NEXT;
     End;
     Result:=EAHilfeSTr;
    close(F);
   End;


End.
