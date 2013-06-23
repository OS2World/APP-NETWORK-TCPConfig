
(****************************************************************)
(*                     DATABASE TOOLBOX 4.0                     *)
(****************************************************************)
Unit NFS_Toolbox;
interface

uses dos,nfs_Var_Unit;

const FileHeaderSize=14;
      MinDataRecSize=FileHeaderSize;

type DataFile=record
               F:file;
               FirstFree,NumberFree,Int1:LongInt;
               ItemSize:word;
               NumRec:LongInt;
              end;

     TaKeyStr=string[MaxKeyLen];

     TaItem=record
             DataRef,PageRef:LongInt;
             Key:TaKeyStr;
            end;

     TaPage=record
             ItemsOnPage:0..PageSize;
             BckwPageRef:LongInt;
             ItemArray:array[1..PageSize] of TaItem;
            end;

     TaPagePtr=^TaPage;

     TaSearchStep=record
                   PageRef,ItemArrIndex:LongInt;
                  end;

     TaPath=array [1..MaxHeight] of TaSearchStep;

     IndexFile=record
                DataF:DataFile;
                AllowDuplKeys:Boolean;
                KeyL:byte;
                RR,PP:LongInt;
                Path:TaPath;
               end;

     IndexFilePtr=^IndexFile;

     TaStackRec=record
                 Page:TaPage;
                 IndexFPtr:IndexFilePtr;
                 PageRef:LongInt;
                 Updated:Boolean;
                end;

     TaStackRecPtr=^TaStackRec;

     TaPageStack=array [1..PageStackSize] of TaStackRec;

     TaPageStackPtr=^TaPageStack;

     TaPageMap=array [1..PageStackSize] of word;

     TaPageMapPtr=^TaPageMap;

     TaRecordBuffer=record
                     case Integer of
                      0:(Page : TaStackRec);
                      1:(R : array[1..MaxDataRecSize] of Byte);
                      2:(I : LongInt);
                    end;

     TaRecordBufPtr=^TaRecordBuffer;

     FileAsciiZ=array [1..64] of char;

     FileName=string[66];

const ItemOverhead=9;
      PageOverhead=5;
      NoDuplicates=0;
      Duplicates=1;

      RecTooLarge    =1000;
      RecTooSmall    =1001;
      KeyTooLarge    =1002;
      RecSizeMismatch=1003;
      KeySizeMismatch=1004;
      MemOverflow    =1005;

type ProcPtr=^byte;

var TAStatus:word;
    OK:Boolean;
    TAErrorProc:ProcPtr;
    InHandler:boolean;

procedure AddKey(var IdxF       : IndexFile;
                 var DataRecNum : LongInt;
                 var ProcKey                );

procedure AddRec(var DatF  : DataFile;
                 var R     : LongInt;
                 var Buffer           );

procedure ClearKey(var IdxF : IndexFile);

procedure CloseFile(var DatF : DataFile);

procedure CloseIndex(var IdxF : IndexFile);

procedure DeleteKey(var IdxF       : IndexFile;
                    var DataRecNum : LongInt;
                    var ProcKey              );

procedure DeleteRec(var DatF : DataFile;
                        R    : LongInt);

function FileLen(var DatF : DataFile) : LongInt;

procedure FindKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );

procedure GetRec(var DatF   : DataFile;
                     R      : LongInt;
                 var Buffer           );

procedure MakeFile(var DatF   : DataFile;
                       FName  : FileName;
                       RecLen : word);

procedure MakeIndex(var IdxF   : IndexFile;
                        FName  : FileName;
                        KeyLen,
                        S      : byte);

procedure NextKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );

procedure OpenFile(var DatF   : DataFile;
                       FName  : FileName;
                       RecLen : word);

procedure OpenIndex(var IdxF   : IndexFile;
                        FName  : FileName;
                        KeyLen,
                        S      : byte);

procedure PrevKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );

procedure PutRec(var DatF   : DataFile;
                     R      : LongInt;
                 var Buffer           );

procedure SearchKey(var IdxF : IndexFile;
                    var DataRecNum : LongInt;
                    var ProcKey);

function UsedRecs(var DatF : DataFile) : LongInt;

type ErrorString = String[80];


implementation
USES Dialogs;
{$I-,R-}
var TaRecBuf  : TaRecordBufPtr;
    TaPageStk : TaPageStackPtr;
    TaPgMap   : TaPageMapPtr;


procedure TACrash(FileNm:FileName;R:LongInt);
var ErrorStr:ErrorString;ERR:String;ERR_NUM:String;
 begin
  if InHandler then Halt;Str(R,ERR);STR(TAStatus,ERR_NUM);
   ErrorBox('TURBO-DATABASE FEHLER in DATEI: '+FileNm+' Auf Eintrag Nr. :'+ERR+' Fehlernummer : '+ERR_NUM);
  Halt;
 end;

procedure TAIOCheck(var DatF : DataFile;
                    R : LongInt);
var
  i : byte;
  FileNm : FileName;
begin
  if TAStatus <> 0 then
    with DatF do
    begin
      i := 0;
      FileNm := '';
      with FileRec(F) do
        while (Ord(Name[i]) <> 0) and (i <= 80) do
        begin
          FileNm := FileNm + Name[i];
          i := Succ(i);
        end;
        TACrash(FileNm, R);
     end;
end; { TAIOCheck }

procedure GetRec(var DatF   : DataFile;
                     R      : Longint;
                 var Buffer           );
var
  BlocksRead : LongWord;
begin
  Seek(DatF.F,R);
  TAStatus := IOresult;
  TaIOcheck(DatF,R);
  BlockRead(DatF.F,Buffer, 1, BlocksRead);
  if BlocksRead = 0 then
    TAStatus := 100;
  TaIOcheck(DatF, R);
end; { GetRec }

procedure PutRec(var DatF   : DataFile;
                     R      : LongInt;
                 var Buffer           );
var
  BlocksWritten : Longword;

begin
  Seek(DatF.F,R);
  TAStatus := IOresult;
  TaIOcheck(DatF,R);
  BlockWrite(DatF.F,Buffer,1, BlocksWritten);
  if BlocksWritten = 0 then
    TAStatus := 101;
  TaIOcheck(DatF,R);
end; { PutRec }

procedure WriteHeader(var DatF   : DataFile; RecLen : word);
begin
  with DatF do
  begin
    FillChar(TaRecBuf^, SizeOf(TaRecBuf^), 0);
    FirstFree := -1;
    ItemSize := RecLen;
    Move(DatF.FirstFree,TaRecBuf^,FileHeaderSize);
    PutRec(DatF,0,TaRecBuf^);
    TaIOCheck(DatF, 0);
    DatF.NumRec := 1;
    OK := true;
  end;
end; { WriteHeader }

procedure MakeFile(var DatF   : DataFile;
                       FName  : FileName;
                       RecLen : word);
begin
  TAStatus := 0;
  FillChar(DatF, SizeOf(DatF), 0);
  Assign(DatF.F, FName);
  Rewrite(DatF.F,RecLen);
  Ok := IOResult = 0;
  if Ok then
  begin
    if RecLen > MaxDataRecSize then
      TAStatus := RecTooLarge;
    if RecLen < MinDataRecSize then
      TAStatus := RecTooSmall;
    TAIOCheck(DatF, 0);
    WriteHeader(DatF, RecLen);
  end;
end; { MakeFile }

procedure ReadHeader(var DatF   : DataFile);
begin
  with DatF do
  begin
    GetRec(DatF,0,TaRecBuf^);
    Move(TaRecBuf^,DatF.FirstFree,FileHeaderSize);
    DatF.NumRec := FileSize(DatF.F);
  end;
end; { ReadHeader }

procedure OpenFile(var DatF   : DataFile;
                       FName  : FileName;
                       RecLen : word);
begin
  IF FName='' Then Begin ErrorBox('Turbo Database Fehler : Kein Filename bei Procedure "OpenFile"');Halt;End;
  FillChar(DatF, SizeOf(DatF), 0);
  Assign(DatF.F,FName);{$I-}
  Reset(DatF.F,RecLen);
  TAStatus := IOResult;
  Ok := TAStatus = 0;
  if Ok then
  begin
    if RecLen > MaxDataRecSize then
      TAStatus := RecTooLarge;
    if RecLen < MinDataRecSize then
      TAStatus := RecTooSmall;
    TAIOCheck(DatF, 0);
    ReadHeader(DatF);
    if RecLen <> DatF.ItemSize then
    begin
      TAStatus := RecSizeMismatch;
      TAIOCheck(DatF, 0);
    end;
  end;
end; { OpenFile }

procedure PutFileHeader(var DatF : DataFile);
begin
  FillChar(TaRecBuf^, SizeOf(TaRecBuf^), 0);
  Move(DatF.FirstFree,TaRecBuf^,FileHeaderSize);
  PutRec(DatF,0,TaRecBuf^);
end; { PutFileHeader }

procedure CloseFile(var DatF : DataFile);
begin
  IF FileMode<>FMINPUT THEN PutFileHeader(DatF);
  Close(DatF.F);
  TAStatus := IOresult;
  TaIOcheck(DatF,0);
end; { CloseFile }

function DupHandle(Handle: Word): Word;
begin
end;{ DupHandle }

procedure CloseFileHandle(Handle : Word);
begin
end;

procedure FlushDOSFile(var F : File);
var
  CloneHandle : Word;
begin
  CloneHandle := DupHandle(FileRec(F).Handle);
  if TAStatus = 0 then
    CloseFileHandle (CloneHandle);
end;  { FlushDOSFile }

procedure FlushFile(var DatF : DataFile);
begin
  PutFileHeader(DatF);
  FlushDOSFile(DatF.F);
  TAIOCheck(DatF, 0);
end; { FlushFile }

procedure NewRec(var DatF  : DataFile;
                 var R     : LongInt  );
begin
  if DatF.FirstFree = -1 then
  begin
    R := DatF.NumRec;
    DatF.NumRec := Succ(DatF.NumRec)
  end
  else
  begin
    R := DatF.FirstFree;
    GetRec(DatF,R,TaRecBuf^);
    DatF.FirstFree := TaRecBuf^.I;
    DatF.NumberFree := pred(DatF.NumberFree);
  end;
end; { NewRec }

procedure AddRec(var DatF  : DataFile;
                 var R     : LongInt;
                 var Buffer           );
begin
  NewRec(DatF,R);
  PutRec(DatF,R,Buffer);
end; { AddRec }

procedure DeleteRec(var DatF : DataFile;
                        R    : LongInt);
begin
  { GetRec(DatF, R, TARecBuf^); }
  TaRecBuf^.I := DatF.FirstFree;
  PutRec(DatF,R,TaRecBuf^);
  DatF.FirstFree := R;
  DatF.NumberFree := succ(DatF.NumberFree);
end; { DeleteRec }

function FileLen(var DatF : DataFile) : LongInt;
begin
  FileLen := DatF.NumRec;
end; { FileLen }

function UsedRecs(var DatF : DataFile) : LongInt;
begin
  UsedRecs := DatF.NumRec - DatF.NumberFree - 1;
end; { UsedRecs }


Type
  PageBlock = array[0..MaxInt] of Byte;

procedure TaPack(var Page : TaPage;
                     KeyL : byte);
var
  I : word;
  P : ^PageBlock;
begin
  P := @Page;
  if KeyL <> MaxKeyLen then
    for I := 1 to PageSize do
      Move(Page.ItemArray[I], P^[(I - 1) * (KeyL + ItemOverhead)
                                 + PageOverhead],KeyL + ItemOverhead);
end; { TaPack }

procedure TaUnpack(var Page : TaPage;
                       KeyL : byte);
var
  I : word;
  P : ^PageBlock;
begin
  P := @Page;
  if KeyL <> MaxKeyLen then
    for I := PageSize downto 1 do
      Move(P^[(I - 1) * (KeyL + ItemOverhead) + PageOverhead],
           Page.ItemArray[I],KeyL + ItemOverhead);
end; { TaUnpack }

procedure MakeIndex(var IdxF   : IndexFile;
                        FName  : FileName;
                        KeyLen,
                        S      : byte);
var
  K : word;
begin
  FillChar(IdxF, SizeOf(IdxF), 0);
  K := (KeyLen + ItemOverhead) * PageSize + PageOverhead;
  with IdxF,IdxF.DataF do
  begin
    Assign(F, FName);
    Rewrite(F, K);
    TAStatus :=IOResult;
    if KeyLen > MaxKeyLen then
      TAStatus := KeyTooLarge;
    TAIOcheck(DataF, 0);
    WriteHeader(IdxF.DataF, K);
    IdxF.AllowDuplKeys := S <> NoDuplicates;
    IdxF.KeyL := KeyLen;
  end;
end; { MakeIndex }

procedure OpenIndex(var IdxF   : IndexFile;
                        FName  : FileName;
                        KeyLen,
                        S      : byte);
var
  K : word;
begin
  K := (KeyLen + ItemOverhead) * PageSize + PageOverhead;
  FillChar(IdxF, SizeOf(IdxF), 0);
  with IdxF, DataF do
  begin
    Assign(F, FName);{$I-}
    Reset(F, K);
  end;
  TAStatus := IOResult;
  Ok := TAStatus = 0;
  if Ok then
  begin
    if KeyLen > MaxKeyLen then
    begin
      TAStatus := KeyTooLarge;
      TAIOCheck(IdxF.DataF, 0);
    end;
    ReadHeader(IdxF.DataF);
    if K <> IdxF.DataF.ItemSize then
    begin
      TAStatus := KeySizeMismatch;
      TAIOCheck(IdxF.DataF, 0);
    end;
    IdxF.AllowDuplKeys := S <> NoDuplicates;
    IdxF.KeyL := KeyLen;
    IdxF.RR := IdxF.DataF.Int1;
    IdxF.PP := 0;
  end;
end; { OpenIndex }

procedure StoreIndexHeader(var IdxF : IndexFile);
var
  I : Integer;
begin
  for I := 1 to PageStackSize do
    with TaPageStk^[I] do
      if IndexFPtr = @IdxF then
      begin
        IndexFPtr := nil;
        if Updated then
        begin
          TaPack(Page,IdxF.KeyL);
          PutRec(IdxF.DataF,PageRef,Page);
          Updated := false;
        end;
      end;
  IdxF.DataF.Int1 := IdxF.RR;
end; { StoreIndexHeader }

procedure CloseIndex(var IdxF : IndexFile);
begin
  StoreIndexHeader(IdxF);
  CloseFile(IdxF.DataF);
end; { CloseIndex }

procedure FlushIndex(var IdxF       : IndexFile);
begin
  StoreIndexHeader(IdxF);
  FlushFile(IdxF.DataF);
end; { FlushIndex }

procedure EraseFile(var DatF : DataFile);
begin
  CloseFile(DatF);
  Erase(DatF.F);
end; { EraseFile }

procedure EraseIndex(var IdxF : IndexFile);
begin
  CloseIndex(IdxF);
  Erase(IdxF.DataF.F);
end; { EraseIndex }

procedure TaLast(I : LongInt);
var
  J,K : Integer;
begin
  J := 1;
  while (TaPgMap^[J] <> I) and (J < PageStackSize) do
    J := succ(J);
  for K := J to pred(PageStackSize)do
    TaPgMap^[K] := TaPgMap^[succ(K)];
  TaPgMap^[PageStackSize] := I;
end; { TaLast }

procedure TaGetPage(var IdxF  : IndexFile;
                        R     : Integer;
                    var PgPtr : TaPagePtr);
var
  I     : Integer;
  Found : Boolean;
begin
  I := 0;
  repeat
    I := succ(I);
    with TaPageStk^[I] do
      Found := (IndexFPtr = @IdxF) and (PageRef = R);
  until Found or (I = PageStackSize);

  if not Found then
  begin
    I := TaPgMap^[1];
    with TaPageStk^[I] do
    begin
      if Updated then
      begin
        TaPack(Page,IndexFPtr^.KeyL);
        PutRec(IndexFPtr^.DataF,PageRef,Page);
      end;
      GetRec(IdxF.DataF,R,Page);
      TaUnpack(Page,IdxF.KeyL);
      IndexFPtr := @IdxF;
      PageRef := R;
      Updated := false;
    end;
  end;
  TaLast(I);
  PgPtr := @TaPageStk^[I];
end; { TaGetPage }

procedure TaNewPage(var IdxF  : IndexFile;
                    var R     : LongInt;
                    var PgPtr : TaPagePtr);
var
  I : Integer;
begin
  I := TaPgMap^[1];
  with TaPageStk^[I] do
  begin
    if Updated then
    begin
      TaPack(Page,IndexFPtr^.KeyL);
      PutRec(IndexFPtr^.DataF,PageRef,Page);
    end;
    NewRec(IdxF.DataF,R);
    IndexFPtr := @IdxF;
    PageRef := R;
    Updated := false;
  end;
  TaLast(I);
  PgPtr := @TaPageStk^[I];
end; { TANewPage }

procedure TaUpdatePage(PgPtr : TaPagePtr);
begin
  TAStackRecPtr(PgPtr)^.Updated := true;
end; { TAUpdatePage }

procedure TaReturnPage(var PgPtr : TaPagePtr);
begin
  with TaStackRecPtr(PgPtr)^ do
  begin
    DeleteRec(IndexFPtr^.DataF,PageRef);
    IndexFPtr := nil;
    Updated := false;
  end;
end; { TAReturnPage }

procedure TaXKey(var K;
                 KeyL : byte);
begin
  if Length(TaKeyStr(K)) > KeyL then
    TaKeyStr(K)[0] := Chr(KeyL);
end; { TaXKey }

function TaCompKeys(var K1,
                        K2;
                        DR1,
                        DR2 : LongInt;
                        Dup : Boolean ) : Integer;
begin
  if TaKeyStr(K1) = TaKeyStr(K2) then
    if Dup then
      TaCompKeys := DR1 - DR2
    else TaCompKeys := 0
  else
    if TaKeyStr(K1) > TaKeyStr(K2) then
      TaCompKeys := 1
    else TaCompKeys :=  - 1;
end;

procedure ClearKey(var IdxF : IndexFile);
begin
  IdxF.PP := 0;
end;

procedure NextKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );
var
  R      : LongInt;
  PagPtr : TaPagePtr;
begin
  with IdxF do
  begin
    if PP = 0 then
      R := RR
    else
    with Path[PP] do
    begin
      TaGetPage(IdxF,PageRef,PagPtr);
      R := PagPtr^.ItemArray[ItemArrIndex].PageRef;
    end;
    while R <> 0 do
    begin
      PP := PP + 1;
      with Path[PP] do
      begin
        PageRef := R;
        ItemArrIndex := 0;
      end;
      TaGetPage(IdxF,R,PagPtr);
      R := PagPtr^.BckwPageRef;
    end;
    if PP <> 0 then
    begin
      while (PP > 1) and
            (Path[PP].ItemArrIndex = PagPtr^.ItemsOnPage) do
      begin
        PP := PP - 1;
        TaGetPage(IdxF,Path[PP].PageRef,PagPtr);
      end;
      if Path[PP].ItemArrIndex < PagPtr^.ItemsOnPage then
        with Path[PP] do
        begin
          ItemArrIndex := ItemArrIndex + 1;
          with PagPtr^.ItemArray[ItemArrIndex] do
          begin
            TaKeyStr(ProcKey) := Key;
            DataRecNum := DataRef;
          end;
        end
      else PP := 0;
    end;
    OK := PP <> 0;
  end;
end; { NextKey }

procedure PrevKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );
var
  R      : LongInt;
  PagPtr : TaPagePtr;
begin
  with IdxF do
  begin
    if PP = 0 then
      R := RR
    else
      with Path[PP] do
      begin
        TaGetPage(IdxF,PageRef,PagPtr);
        ItemArrIndex := ItemArrIndex - 1;
        if ItemArrIndex = 0 then
          R := PagPtr^.BckwPageRef
        else R := PagPtr^.ItemArray[ItemArrIndex].PageRef;
      end;
    while R <> 0 do
    begin
      TaGetPage(IdxF,R,PagPtr);
      PP := PP + 1;
      with Path[PP] do
      begin
        PageRef := R;
        ItemArrIndex := PagPtr^.ItemsOnPage;
      end;
      with PagPtr^ do
        R := ItemArray[ItemsOnPage].PageRef;
    end;
    if PP <> 0 then
    begin
      while (PP > 1) and (Path[PP].ItemArrIndex = 0) do
      begin
        PP := PP - 1;
        TaGetPage(IdxF,Path[PP].PageRef,PagPtr);
      end;
      if Path[PP].ItemArrIndex > 0 then
        with PagPtr^.ItemArray[Path[PP].ItemArrIndex] do
        begin
          TaKeyStr(ProcKey) := Key;
          DataRecNum := DataRef;
        end
      else PP := 0;
    end;
    OK := PP <> 0;
  end;
end; { PrevKey }

procedure TaFindKey(var IdxF       : IndexFile;
                    var DataRecNum : LongInt;
                    var ProcKey                );
var
  PrPgRef : LongInt;
  C,K,L,R : Integer;
  RKey    : TaKeyStr;
  PagPtr  : TaPagePtr;
begin
  with IdxF do
  begin
    TaXKey(TaKeyStr(ProcKey),KeyL);
    OK := false;
    PP := 0;
    PrPgRef := RR;
    while (PrPgRef <> 0) and not OK do
    begin
      PP := PP + 1;
      Path[PP].PageRef := PrPgRef;
      TaGetPage(IdxF,PrPgRef,PagPtr);
      with PagPtr^ do
      begin
        L := 1;
        R := ItemsOnPage;
        repeat
          K := (L + R) div 2;
          C := TaCompKeys(TaKeyStr(ProcKey),
                          ItemArray[K].Key,
                          0,
                          ItemArray[K].DataRef,
                          AllowDuplKeys        );
          if C <= 0 then
            R := K - 1;
          if C >= 0 then
            L := K + 1;
        until R < L;
        if L - R > 1 then
        begin
          DataRecNum := ItemArray[K].DataRef;
          R := K;
          OK := true;
        end;
        if R = 0 then
          PrPgRef := BckwPageRef
        else PrPgRef := ItemArray[R].PageRef;
      end;
      Path[PP].ItemArrIndex := R;
    end;
    if not OK and (PP > 0) then
    begin
      while (PP > 1) and (Path[PP].ItemArrIndex = 0) do
        PP := PP - 1;
      if Path[PP].ItemArrIndex = 0 then
        PP := 0;
    end;
  end;
end; { TAFindKey }

procedure FindKey(var IdxF       : IndexFile;
                  var DataRecNum : LongInt;
                  var ProcKey                );
var
  TempKey : TaKeyStr;
begin
  TaFindKey(IdxF,DataRecNum,TaKeyStr(ProcKey));
  if not OK and IdxF.AllowDuplKeys then
  begin
    TempKey := TaKeyStr(ProcKey);
    NextKey(IdxF,DataRecNum,TaKeyStr(ProcKey));
    OK := OK and (TaKeyStr(ProcKey) = TempKey);
  end;
end; { FindKey }

procedure SearchKey(var IdxF : IndexFile;
                    var DataRecNum : LongInt;
                    var ProcKey);
begin
  TaFindKey(IdxF,DataRecNum,TaKeyStr(ProcKey));
  if not OK then
   NextKey(IdxF,DataRecNum,TaKeyStr(ProcKey));
end; { SearchKey }

procedure AddKey(var IdxF       : IndexFile;
                 var DataRecNum : LongInt;
                 var ProcKey                );
var
  PrPgRef1,
  PrPgRef2  : LongInt;
  C,I,K,L   : Integer;
  PassUp    : Boolean;
  PagePtr1,
  PagePtr2  : TaPagePtr;
  ProcItem1,
  ProcItem2 : TaItem;


procedure Search(PrPgRef1 : LongInt);
var
  R : Integer;

procedure Insert;
var
  i : integer;
begin
  TaGetPage(IdxF,PrPgRef1,PagePtr1);
  with PagePtr1^ do
  begin
    if ItemsOnPage < PageSize then
    begin
      ItemsOnPage := ItemsOnPage + 1;
      for I := ItemsOnPage downto R + 2 do
        ItemArray[I] := ItemArray[I - 1];
      ItemArray[R + 1] := ProcItem1;
      PassUp := false;
    end
    else
    begin
      TaNewPage(IdxF,PrPgRef2,PagePtr2);
      if R <= Order then
      begin
        if R = Order then
          ProcItem2 := ProcItem1
        else
        begin
          ProcItem2 := ItemArray[Order];
          for I := Order downto R + 2 do
            ItemArray[I] := ItemArray[I - 1];
          ItemArray[R + 1] := ProcItem1;
        end;
        for I := 1 to Order do
          PagePtr2^.ItemArray[I] := ItemArray[I + Order];
      end
      else
      begin
        R := R - Order;
        ProcItem2 := ItemArray[Order + 1];
        for I := 1 to R - 1 do
          PagePtr2^.ItemArray[I] := ItemArray[I + Order + 1];
        PagePtr2^.ItemArray[R] := ProcItem1;
        for I := R + 1 to Order do
          PagePtr2^.ItemArray[I] := ItemArray[I + Order];
      end;
      ItemsOnPage := Order;
      PagePtr2^.ItemsOnPage := Order;
      PagePtr2^.BckwPageRef := ProcItem2.PageRef;
      ProcItem2.PageRef := PrPgRef2;
      ProcItem1 := ProcItem2;
      TaUpdatePage(PagePtr2);
    end;
  end;
  TaUpdatePage(PagePtr1);
end; { Insert }

begin { Search }
  if PrPgRef1 = 0 then
  begin
    PassUp := true;
    with ProcItem1 do
    begin
      Key := TaKeyStr(ProcKey);
      DataRef := DataRecNum;
      PageRef := 0;
    end;
  end
  else
  begin
    TaGetPage(IdxF,PrPgRef1,PagePtr1);
    with PagePtr1^ do
    begin
      L := 1;
      R := ItemsOnPage;
      repeat
        K := (L + R) div 2;
          C := TaCompKeys(TaKeyStr(ProcKey),
                        ItemArray[K].Key,
                        DataRecNum,
                        ItemArray[K].DataRef,
                        IdxF.AllowDuplKeys   );
        if C <= 0 then
          R := K - 1;
        if C >= 0 then
          L := K + 1;
      until R < L;
      if L - R > 1 then
      begin
        OK := false;
        PassUp := false;
      end
      else
      begin
        if R = 0 then
          Search(BckwPageRef)
        else Search(ItemArray[R].PageRef);
        if PassUp then
          Insert;
      end;
    end;
  end;
end; { Search }

begin { AddKey }
  with IdxF do
  begin
    TaXKey(TaKeyStr(ProcKey),KeyL);
    OK := true;
    Search(RR);
    if PassUp then
    begin
      PrPgRef1 := RR;
      TaNewPage(IdxF,RR,PagePtr1);
      with PagePtr1^ do
      begin
        ItemsOnPage := 1;
        BckwPageRef := PrPgRef1;
        ItemArray[1] := ProcItem1;
      end;
      TaUpdatePage(PagePtr1);
    end;
    PP := 0;
  end;
end; { AddKey }

procedure DeleteKey(var IdxF       : IndexFile;
                    var DataRecNum : LongInt;
                    var ProcKey              );
var
  PageTooSmall : Boolean;
  PagPtr       : TaPagePtr;

procedure DelB(PrPgRef : LongInt);
var
  C,I,K,L,R,
  XPageRef  : LongInt;
  PagPtr    : TaPagePtr;

procedure UnderFlow(PrPgRef,
                    PrPgRef2 : LongInt;
                    R        : Integer);
var
  I,K,
  LItem : Integer;
  LPageRef : LongInt;
  PagPtr,
  PagePtr2,
  L        : TaPagePtr;
begin
  TaGetPage(IdxF,PrPgRef,PagPtr);
  TaGetPage(IdxF,PrPgRef2,PagePtr2);
  if R < PagPtr^.ItemsOnPage then
  begin
    R := R + 1;
    LPageRef := PagPtr^.ItemArray[R].PageRef;
    TaGetPage(IdxF,LPageRef,L);
    K := (L^.ItemsOnPage - Order + 1) div 2;
    PagePtr2^.ItemArray[Order] := PagPtr^.ItemArray[R];
    PagePtr2^.ItemArray[Order].PageRef := L^.BckwPageRef;
    if K > 0 then
    begin
      for I := 1 to K - 1 do
        PagePtr2^.ItemArray[I + Order] := L^.ItemArray[I];
      PagPtr^.ItemArray[R] := L^.ItemArray[K];
      PagPtr^.ItemArray[R].PageRef := LPageRef;
      L^.BckwPageRef := L^.ItemArray[K].PageRef;
      L^.ItemsOnPage := L^.ItemsOnPage - K;
      for I := 1 to L^.ItemsOnPage do
        L^.ItemArray[I] := L^.ItemArray[I + K];
      PagePtr2^.ItemsOnPage := Order - 1 + K;
      PageTooSmall := false;
      TaUpdatePage(L);
    end
    else
    begin
      for I := 1 to Order do
        PagePtr2^.ItemArray[I + Order] := L^.ItemArray[I];
      for I := R to PagPtr^.ItemsOnPage - 1 do
        PagPtr^.ItemArray[I] := PagPtr^.ItemArray[I + 1];
      PagePtr2^.ItemsOnPage := PageSize;
      PagPtr^.ItemsOnPage := PagPtr^.ItemsOnPage - 1;
      TaReturnPage(L);
      PageTooSmall := PagPtr^.ItemsOnPage < Order;
    end;
    TaUpdatePage(PagePtr2);
  end
  else
  begin
    if R = 1 then
      LPageRef := PagPtr^.BckwPageRef
    else LPageRef := PagPtr^.ItemArray[R - 1].PageRef;
    TaGetPage(IdxF,LPageRef,L);
    LItem := L^.ItemsOnPage + 1;
    K := (LItem - Order) div 2;
    if K > 0 then
    begin
      for I := Order - 1 downto 1 do
        PagePtr2^.ItemArray[I + K] := PagePtr2^.ItemArray[I];
      PagePtr2^.ItemArray[K] := PagPtr^.ItemArray[R];
      PagePtr2^.ItemArray[K].PageRef := PagePtr2^.BckwPageRef;
      LItem := LItem - K;
      for I := K - 1 downto 1 do
        PagePtr2^.ItemArray[I] := L^.ItemArray[I + LItem];
      PagePtr2^.BckwPageRef := L^.ItemArray[LItem].PageRef;
      PagPtr^.ItemArray[R] := L^.ItemArray[LItem];
      PagPtr^.ItemArray[R].PageRef := PrPgRef2;
      L^.ItemsOnPage := LItem - 1;
      PagePtr2^.ItemsOnPage := Order - 1 + K;
      PageTooSmall := false;
      TaUpdatePage(PagePtr2);
    end
    else
    begin
      L^.ItemArray[LItem] := PagPtr^.ItemArray[R];
      L^.ItemArray[LItem].PageRef := PagePtr2^.BckwPageRef;
      for I := 1 to Order - 1 do
        L^.ItemArray[I + LItem] := PagePtr2^.ItemArray[I];
      L^.ItemsOnPage := PageSize;
      PagPtr^.ItemsOnPage := PagPtr^.ItemsOnPage - 1;
      TaReturnPage(PagePtr2);
      PageTooSmall := PagPtr^.ItemsOnPage < Order;
    end;
    TaUpdatePage(L);
  end;
  TaUpdatePage(PagPtr);
end; { UnderFlow }


procedure DelA(PrPgRef2 : LongInt);
var
  C : Integer;
  XPageRef : LongInt;
  PagePtr2 : TaPagePtr;
begin
  TaGetPage(IdxF,PrPgRef2,PagePtr2);
  with PagePtr2^ do
  begin
    XPageRef := ItemArray[ItemsOnPage].PageRef;
    if XPageRef <> 0 then
    begin
      C := ItemsOnPage;
      DelA(XPageRef);
      if PageTooSmall then UnderFlow(PrPgRef2,XPageRef,C);
    end
    else
    begin
      TaGetPage(IdxF,PrPgRef,PagPtr);
      ItemArray[ItemsOnPage].PageRef := PagPtr^.ItemArray[K].PageRef;
      PagPtr^.ItemArray[K] := ItemArray[ItemsOnPage];
      ItemsOnPage := ItemsOnPage - 1;
      PageTooSmall := ItemsOnPage < Order;
      TaUpdatePage(PagPtr);
      TaUpdatePage(PagePtr2);
    end;
  end;
end; { DelA }

begin { DelB }
  if PrPgRef = 0 then
  begin
    OK := false;
    PageTooSmall := false;
  end
  else
  begin
    TaGetPage(IdxF,PrPgRef,PagPtr);
    with PagPtr^ do
    begin
      L := 1;
      R := ItemsOnPage;
      repeat
        K := (L + R) div 2;
          C := TaCompKeys(TaKeyStr(ProcKey),
                        ItemArray[K].Key,
                        DataRecNum,
                        ItemArray[K].DataRef,
                        IdxF.AllowDuplKeys   );
        if C <= 0 then
          R := K - 1;
        if C >= 0 then
          L := K + 1;
      until L > R;
      if R = 0 then
        XPageRef := BckwPageRef
      else XPageRef := ItemArray[R].PageRef;
      if L - R > 1 then
      begin
        DataRecNum := ItemArray[K].DataRef;
        if XPageRef = 0 then
        begin
          ItemsOnPage := ItemsOnPage - 1;
          PageTooSmall := ItemsOnPage < Order;
          for I := K to ItemsOnPage do
            ItemArray[I] := ItemArray[I + 1];
          TaUpdatePage(PagPtr);
        end
        else
        begin
          DelA(XPageRef);
          if PageTooSmall then
            UnderFlow(PrPgRef,XPageRef,R);
        end;
      end
      else
      begin
        DelB(XPageRef);
        if PageTooSmall then
          UnderFlow(PrPgRef,XPageRef,R);
      end;
    end;
  end;
end; { DelB }

begin { DeleteKey }
  with IdxF do
  begin
    TaXKey(TaKeyStr(ProcKey),KeyL);
    OK := true;
    DelB(RR);
    if PageTooSmall then
    begin
      TaGetPage(IdxF,RR,PagPtr);
      if PagPtr^.ItemsOnPage = 0 then
      begin
        RR := PagPtr^.BckwPageRef;
        TaReturnPage(PagPtr);
      end;
    end;
    PP := 0;
  end;
end; { DeleteKey }

procedure InitTAccess;
{ Initialization routine called by the "main procedure" of this unit. }

procedure InitPages;
{ Allocate space for the page stack, the page map and the record
  buffer. }
var
  i : word;T:Longword;S:Longint;
begin
  S:=(SizeOf(TaRecordBuffer) +
                 SizeOf(TaPageMap) +
                 SizeOf(TaPageStack));
  //ShowMessage('Gr”áe des records : '+ToStr(S));
  if MemAvail < (SizeOf(TaRecordBuffer) +
                 SizeOf(TaPageMap) +
                 SizeOf(TaPageStack)) then
 begin
   TAStatus := MemOverflow;
   ErrorBox('Error in ToolBox : Memory Overflow Error');
 end;
  new(TaPageStk);
  FillChar(TaPageStk^, SizeOf(TaPageStk^), 0);
  new(TaPgMap);
  for i := 1 to PageStackSize do
    TaPgMap^[i] := i;
  new(TaRecBuf);
end; { InitPages }

begin { InitTAccess }
  Ok := true;
  TAStatus := 0;
  TAErrorProc := nil;
  InHandler := false;
  InitPages;
end; { InitTAccess }

begin
  InitTAccess;
end.
