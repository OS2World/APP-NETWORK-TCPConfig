Unit TCP_Hostlist;

Interface
Procedure QueryHostList;
Implementation
USES DOS,Dialogs,DebugUnit,Classes,ustring;


Type
                THostListRec=Record
                        IPAdress:TStringList;
                        Hostname:TStringList;
                        AliasName:TStringList;
                        COmment:TStringList;
                End;                
        Type
                THostlist=Class
                Private
                HostFile:Text;
                Function CutLastSpace(StringToCut:String):String;
                Function NextPosInString(VAR POS:Byte):Byte;
                Function  QUeryIPAdress:Boolean;
                Procedure QueryHostName;
                Procedure QueryAliasName;
                Procedure QueryComment;
                Protected
                HostString:String;
                StriPosi:Byte;
                Function ReadString(VAR StartPos:Byte):String;
                Function ReadString2(VAR StartPos:Byte):String;
                Public
                Items:THostListRec;
                CONSTRUCTOR Create;VIRTUAL;
                Procedure ReadFile;
                Procedure Add2DebugForm;
                DESTRUCTOR Destroy;VIRTUAL;
        End;                


 
 
 Function THostList.NextPosInString(VAR POS:Byte):Byte;
 Begin
      REPEAT
        INC(POS);
      Until HostString[POS]<>' ';
      Result:=POS;
        
 End;
 
 Function THostList.CutLastSpace(StringToCut:String):String;
 VAR SpacePos:Byte;
 // PrÅft einen STring, ob sich an dessen Ende ein Leerzeichen befindet, und wenn ja wird es gelîscht.
 Begin
        SPacePos:=Length(StringToCut);
        IF StringToCut[SpacePos]=' ' Then Result:=Copy(StringToCut,1,SpacePos-1)
                                     else Result:=StringToCut;
 End;

 

 Function ThostList.ReadString2(VAR StartPos:Byte):String;
 // Liest einen String ab POS X bis zum vorkommen eines # oder Zeilenende,  und liefert danch den korrekten String zurÅck (Leerzeichen werden mitgeliefrt)
 VAR Output:String;aChar:Char;
 Begin
        Output:='';aChar:=HostString[StartPos];
        IF StartPos>Length(HostSTring) Then Begin Result:='';exit;ENd;
        IF ord(aChar)=9 Then Begin Result:='';Exit;End;
        REPEAT
                Output:=Output+HostString[StartPos];Inc(StartPos);
        UNTIL (HostString[StartPos]='#') or (StartPos=Length(HostString)+1);
        Result:=CutLastSpace(Output);
 End;
 
 
 Function THostList.ReadString(VAR StartPos:Byte):String;
 // Liest einen String ab POS X bis zum vorkommen eines "Leerzeichens" und liefert danch den korrekten String zurÅck
        VAR
            Output:String;

        Begin
                //IF StartPos>length(HostString) Then Begin Result:='#';STartPos:=255;exit;End;
                Output:='';
           REPEAT
                //IF HostString[StartPos]=#0 Then Begin Result:=Output;StartPos:=254;Exit;End; // Zeilenende Erreicht
                IF (HostString[StartPos]<>' ') Then
                Begin
                        IF HostString[StartPos]=#9 Then Begin Result:=Output;Exit;End;
                        OutPut:=Output+HostString[StartPos];
                End else
                Begin
                        Result:=Output;exit;
                End;
                Inc(StartPos);
          UNTIL StartPos>Length(HostString);
          Result:=Output;
        End;


CONSTRUCTOR THostList.Create;
Begin
        {$I-}
        Assign(HostFile,getenv('ETC')+'\HOSTS');Reset(HostFile);IF IOResult<>0 Then Begin ErrorBox('Kann HOST Datei nicht îffenen !');Exit;End;
        With Items do 
        Begin
                IpAdress:=TStringList.Create;
                HostName:=TStringList.Create;
                AliasName:=TStringlist.Create;
                Comment:=TStringlist.Create;
                
        End;
End;


Function THostList.QueryIPAdress:Boolean;
VAR S:String;
Begin
        Result:=True;StriPosi:=1;
        s:=ReadString(StriPosi);
        IF S[1]='#' Then Begin Result:=FALSE;exit;ENd;
        Items.IPAdress.Add(S);
End;

Procedure THostList.QueryHostName;
VAR S:String;
Begin
        StriPosi:=NextPosInString(StriPosi);
        S:=ReadString(StriPosi);
        Items.HostName.Add(S);
        //Inc(StriPosi);
End;

Procedure THostList.QueryAliasName;
VAR S:String;H:char;S2:string;
Begin
   StriPosi:=NextPosInString(StriPosi);
   IF HostString[StriPosi]='#' Then Begin dec(StriPosi);Items.AliasName.add('');exit;End; // Sollte auf dieser Position bereits ein Kommentar erscheinen, diese Routine nicht ausfÅhren
   S:=ReadString2(StriPosi);
   Items.AliasName.add(S);
End;

Procedure THostList.QueryCOmment;
VAR S:String;
Begin
        IF HOSTString[StriPosi]<>'#' Then StriPosi:=NextPosInString(StriPosi);
        IF HostString[StriPosi]='#' Then
        Begin 
           StriPosi:=StriPosi+2;
           S:=ReadString2(StriPosi);
        End
                else
        S:='';

      Items.Comment.add(S);

End;

Procedure THostList.ReadFile;
Begin
    
     While not eof(HostFile) do 
     Begin
        Readln(HostFile,HostString);
        IF QueryIPAdress Then 
        Begin
                QueryHostName;
                QueryAliasName;
                QueryComment;        
        End;        
     End;
End;

DESTRUCTOR THostList.Destroy;
Begin
        SysTem.Close(HostFile);
        With Items do 
        Begin
                IpAdress.Destroy;
                HostName.Destroy;
                AliasName.Destroy;
                Comment.Destroy;
        End;
End;



Procedure THostList.Add2DebugForm;
VAR Loop:Longint;
Begin
     FOr Loop:=0 to items.IpADress.count-1 do
     Begin
          With DebugForm do
          Begin
               LBHostIP.items.add(Items.IPAdress[loop]);
               LBHostName.items.add(Items.Hostname[loop]);
               LBHostAlias.items.add(Items.AliasName[loop]);
               LBHostComment.items.add(Items.Comment[loop]);
          End;
     End;
End;

Procedure QueryHostList;
VAR
   HostList:THostList;

Begin
        HostList:=THostList.Create;
        HostList.ReadFile;
        HostList.Add2DebugForm;
        HostList.Destroy;
End;


Initialization

End.
