{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ FileDialog Unit Version 2.0                                               บ
บ                                                                           บ
บ Erstellt : 25.08.2006 - Letzte nderung : 16.09.2006                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Unit FileDialog;
Interface

Uses
  Classes, Forms, Graphics, ComCtrls, StdCtrls, Buttons,dialogs, FileCtrl,ustream,Sysutils,ustring,
  ExtCtrls,GetDrvs2, Menus, GlyphBtn,DOS,MyMessagebox,messages,DateTimeUnit;


{Konstanzen fr Funktion QueryEntryType}
CONST
     Entry_is_Directory=1;
     Entry_is_File=2;
     Entry_is_Drive=3;

Type    TDateTimeRec=Record
        DateString:String[10];
        TimeString:String[10];
End;

{Benutzer Record fr Datum Darstellung}
Type TDateTimeOptions=Record
        DisplaySec:Boolean;
        YearMonthDay:Boolean;
        DayMonthYear:Boolean;
        MonthDayYear:Boolean;
End;


Type
  TCreateRenameDialog = Class (TDialog)
    GroupBox1: TGroupBox;
    Image1: TImage;
    Edit1: TEdit;
    OKButton: TButton;
    Button2: TButton;
    Procedure CreateRenameDialogOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfgen}
  Public
    {ffentliche Deklarationen hier einfgen}
  Function Execute(VAR aMessage:String):Boolean; Virtual;
  End;



Type
  TFileDialogWork = Class (TForm)
    LabelCurrentPath: TLabel;
    ButtonFolderUp: TBitBtn;
    ButtonFolderNew: TBitBtn;
    MultiC: tMultiColumnList;
    ComboBox1: TComboBox;
    FilterComboBox1: TFilterComboBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ButtonDriveView: TBitBtn;
    PopupMenu1: TPopupMenu;
    MenuItemRename: TMenuItem;
    MenuItemDelete: TMenuItem;
    CurrentDirectory:String;
    Procedure FileDialogWorkOnResize (Sender: TObject);
    Procedure FileDialogWorkOnDestroy (Sender: TObject);
    Procedure MenuItemDeleteOnClick (Sender: TObject);
    Procedure MenuItemRenameOnClick (Sender: TObject);
    Procedure MultiCOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure Button1OnClick (Sender: TObject);
    Procedure MultiCOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure ComboBox1OnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure FilterComboBox1OnChange (Sender: TObject);
    Procedure ButtonDriveViewOnClick (Sender: TObject);
    Procedure ButtonFolderNewOnClick (Sender: TObject);
    Procedure ButtonFolderUpOnClick (Sender: TObject);
    Function SearchString:String;
    Function MyCurrentDir:String;
    Function  QueryEntryType(Index:Longint):Byte;       // Ermittelt den Typ des gewhlten Eintrages (Directory/File/Disk)
    Procedure Form1OnCreate (Sender: TObject);
    Procedure Form1OnSetupShow (Sender: TObject);
    Function ReadCurrentDirectory:Boolean;
    Procedure DisplayDrives;
    Procedure FilterFileEntry(aSearchRec:TSearchRec);
    Procedure LoadIconsFromResource;
    Test:TMultiColumnList;
    BackupItemList:TStringlist;
    // DISK Icons
    IconHardDisk:TIcon;
    IconCDROM:TIcon;
    IconRemote:TIcon;
    IconFloppy:TIcon;
    IconRamDrive:TIcon;
    // File Icons
    IconDirectory:TIcon;
    IconDefaultFile:TIcon;
    IconExeFile:TIcon;
    IconTextFile:TIcon;
    IconArchive:TIcon;
    IconImage:TICON;
    IconCMD:TIcon;
    IconFont:TIcon;
    IconDos:TIcon;
    IconCRCFile:Ticon;
    IconAudio:TIcon;
    BitmapDriveBtn:TBitmap;
    BitmapFileBtn:TBitmap;
    Status:Byte;
    CurrentFilterMask:String;  // Enthlt die gegenwrtige Suchmaske (z.b. *.*)
    DateTime:TDateTimeRec;
    DateTimeOptions:TDateTimeOptions;
    RefreshDir:Boolean;
  Private
    {Private Deklarationen hier einfgen}

  Public
    {ffentliche Deklarationen hier einfgen}
    Filter :String;             // Enthlt die Filterliste dure Pipe's getrennt z.b. *.SFV|SFV Dateien oder *.PAS|Pascal Dateien'
    ExeType:String;
    TextType:String;
    ArchiveType:String;
    ImageType:String;
    CMDType:String;
    FOntType:String;
    DosType:String;
    DefaultType:String;
    DirectoryType:String;
    FileName:String; // Enthlt den ausgewhlten Dateibamen
    CheckSumType:String;
    AudioType:String;
    ERROR_DIRChangeFailed:String;
    ButtonDriveCaptionDrive:String;
    ButtonDriveCaptionFiles:String;
    RenameDlgCaption:String;            // Caption (berschrift) des Rename Dialogs
    RenameDlgMessage:String;            // Nachricht des REname Dialogs
    DeleteDlgCaption:String;            // Caption des L”sch Dialoges
    DeleteDlgMessage:String;            // Nachricht des L”schDialoges
    Function Execute:Boolean;           // Startet den FileDialog, Rckwerte=True bei "OK" , FALSE wenn "Abbruch gedrckt wurde
    Function DriveReady:Boolean; // Prft ob ein Laufwerk bereit ist bzw. ob von diesen gelesen werden kann
    FilterIndex:Byte;                 // Index des Filtereintrages (welcher filter voreingestellt ist
  End;
Var
  FileDialogWork: TFileDialogWork;
   CreateRenameDialog: TCreateRenameDialog;
   MYDOsError:Longint;
{$R FILEDIALOG}
Implementation

Function TFileDialogWork.DriveReady:boolean;
LABEL AUSGANG;
{
Testet ob das angegebene Laufwerk bereit ist oder nicht.
Anders als bei einen wechsel auf das Laufwerk wird versucht von diesen Laufwerk auch zu lesen
}

VAR DummyRec:SearchRec;S:String;
Begin
        Result:=TRUE;
        {$I-}
        S:=MyCurrentDir; // Hole aktuelles Laufwerk ein
        MyDOSError:=DOS.FindFirst(S[1]+':\*.*',Anyfile,DummyRec); // Versuche irgendwelche Daten zu lesen
        {$I+}        
        Case MyDosError of
        0,18:Goto Ausgang;
        6:MyDosError:=26; // Wegen Fehler in WDSIBYL'S findfirst (wes wird bei nicht bereiten Laufwerk 6 zurckgeliefrt anstatt 26)
        End;

        Result:=FALSE;
         MyErrorBox(SysErrorMessage(MyDosError));
          Chdir(labelCurrentPath.Caption); // Zum vorherigen Laufwerk/Verzeichniss wechseln
Ausgang:
        DOS.FindClose(DummyRec);
End;


Function ChangeDirectory(Dir:String):Boolean;
{
  Wechselt in das jeweilige durch Dir angegebene Verzeichniss,
  Rckwerte: TRUE = Kein Fehler, Verzeichniss wurde gendert
             FALSE = Fehler aufgetreten, Verzeichniss NICHT gendert
}
VAR IOError:Longint;
Begin
     {$I-}
          CHdir(Dir);IOError:=IOResult;
     {$I+}
     IF IOError<>0 Then
     Begin
          {Wieder auf altes Verzeichniss wechseln}
          ChDir(FileDialogWork.LabelCurrentPath.Caption);IF IOREsult<>0 Then Begin MyErrorBOX('FATAL Error ! - Kann CurrentDir nicht setzen !');Halt;End;
          {Sibyl verndert den IOError 21 (SYS0021) in IOError 152 (PASCAL 7 / MSDOS STIL}
          IF IOError=152 Then Begin MyErrorBox(SysErrorMessage(21));Result:=FALSE;Exit;End;
          MyErrorBox(FileDialogWork.ERROR_DIRChangeFailed+#13+SysErrorMessage(IOError)+#13+Dir);
          Result:=FALSE;
     End else Result:=TRUE;
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

Procedure TCreateRenameDialog.CreateRenameDialogOnSetupShow (Sender: TObject);
Begin
     Edit1.Focus;
End;

Function TCreateRenameDialog.Execute(var aMessage:String):Boolean;
Begin
     Edit1.Text:=aMessage;
     Result:=inherited.Execute;
     IF Result Then aMessage:=Edit1.Text;
End;

Function GetMultiValueStr(MCStr:String;Col:Byte):String;
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
        ErrorBox('** Fehler in Funktion MultiColumStringToString (Unit NFS_Utilits) !!  Angeforderte Zeile ( '+ToStr(COL)+' ) wurde nicht gefunden bzw ist nicht vorhanden !');
ENd;

Function FileSizeStr(aSearchRec:TSearchRec):String;

    Function CalcBytes:String;
     VAR Ergebnis:Real;B:String;
     Begin
        Ergebnis:=aSearchRec.Size;
        Str(Ergebnis:8:2,B);
        Result:=FillStr(B);
     End;

      Function CalcKiloByte:String;
      VAR Ergebnis:Real;KB:String;
      Begin
        Ergebnis:=aSearchRec.Size / 1024;
        str(Ergebnis:8:2,KB);
        Result:=FIllStr(KB);

      End;

        Function CalcMegaByte:String;
        Var Ergebnis:Real;Ergebnis2:Real;MB:STring;
        Begin
                Ergebnis:=aSearchRec.Size / 1024;
                Ergebnis2:=Ergebnis / 1024;
                str(Ergebnis2:8:2,MB);
                Result:=FillStr(MB);
        End;

        Function CalcGigaByte:String;
        Var Ergebnis,ergebnis2,ergebnis3:Real;GB:String;
        Begin
                Ergebnis:=aSearchRec.Size / 1024;
                Ergebnis2:=Ergebnis / 1024;
                Ergebnis3:=Ergebnis2 / 1024;
                str(Ergebnis3:8:2,GB);
                Result:=FillStr(GB);
        End;

VAR U:STring;
Begin
        IF aSearchRec.Size<1023 Then Begin Result:=CalcBytes+' Byte(s)';Exit;End;
        IF aSearchRec.Size<1048575 Then Begin Result:=CalcKiloByte+' Kilobyte';Exit;End;
        IF aSearchRec.Size<1073741823 Then Begin Result:=CalcMegaByte+' Megabyte';Exit;End;
        IF aSearchRec.Size>1073741823 Then Begin Result:=CalcGigaByte+' Gigabyte';Exit;ENd;
End;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Function UnpackTime                                                  บ
 บ                                                                          บ
 บ     Entpacken der Zeitinformationen aus dem TSearchRec und in ein        บ
 บ     "TDateTimeRec" Record als String ablegen                             บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Function UnpackDateTime(aSearchRec:TSearchRec;Mode:TDateTimeOptions):TDateTimeRec;
        VAR 
                YY,MM,DD,WW,HH,MI,SEK,HSEC:String[4];
                DT:DateTime;                
                
                Function Zero(Value:String):String;
                Begin
                        IF Length(Value)=1 Then Result:='0'+Value 
                                           else Result:=Value;
                End;
        Begin
                UnpackTime(aSearchRec.Time,DT);
                With DT do 
                        Begin
                                YY:=IntToStr(Year);MM:=IntToStr(Month);DD:=IntToStr(Day);
                                HH:=IntToStr(Hour);Mi:=IntToStr(Min);Sek:=IntToStr(Sec);
                                IF Mode.YearMonthDay Then Result.DateString:=YY+'.'+Zero(MM)+'.'+Zero(DD);
                                IF Mode.DayMonthYear Then Result.DateString:=Zero(DD)+'.'+Zero(MM)+'.'+YY;
                                IF Mode.MonthDayYear Then Result.DateString:=Zero(MM)+'.'+Zero(DD)+'.'+YY;
        

                                IF Mode.DisplaySec Then Result.TimeString:=Zero(HH)+':'+Zero(Mi)+':'+Zero(SEK)
                                                     else Result.TimeString:=Zero(HH)+':'+Zero(Mi);
                        End;            
        End;



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Utilitys                                                              บ
 บ                                                                          บ
 บ                                                                          บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Function FileSplit(S:String;Mode:Byte):String;
var dirstr,namestr,extstr,TMP:String;
{
MODE Schalter : 1=Nur Verzeichniss Name wird zurcggeliefert
                2=Nur Name+Extension des Dateinamens wird zurckgelifert (ohne Punkt!)
                3=Nur die Extension in Grแbuchstbaen mit Punkt am Ende (.EXE)
                4=Nur den Dateinamen
                5= Nur die Extension in Grแbuchstbaen, JEDOCH OHNE Punkt am Ende (EXE)
}

begin
     Fsplit(S,dirstr,namestr,extstr);
     IF length(dirstr)=3 Then DirStr:=DirStr+'\';
     setlength(dirstr,length(dirstr)-1);
     Case mode of
     1:Result:=dirStr;
     2:Result:=NameStr+ExtStr;
     3:Begin Result:=UpperCase(ExtStr);End;
     4:Result:=NameStr;
     5:Begin TMP:=Copy(ExtStr,2,length(ExtStr));Result:=UpperCase(TMP);End;
     End;
End;




Procedure TFileDialogWork.FileDialogWorkOnResize (Sender: TObject);
Begin
{      IF Self.Left<=61 Then self.left:=61;
      IF Self.Right<=341 Then Self.right:=341;
      IF Self.height<=382 then self.height:=382;
      IF Self.width<=622 Then Self.width:=622;}
End;

Function TFileDialogWork.QueryEntryType(Index:Longint):Byte;
VAR Attr:Longint;
Begin
     {Feststellen ob Eintrag ein Laufwerk ist}
     IF MultiC.Values[0,Index]='DRIVE' Then Begin Result:=Entry_Is_Drive;Exit;End;
     Attr:=FileGetAttr(MultiC.Values[1,Index]);
     IF Attr and faDirectory<>0 Then Begin Result:=Entry_is_Directory;Exit;End
                                else Result:=Entry_is_File;

End;

Procedure TFileDialogWork.MenuItemDeleteOnClick (Sender: TObject);
Begin
     IF COnfirmDialog(DeleteDlgCaption,DeleteDlgMessage,'~Ok','~Cancel') Then
     Begin
          IF QueryEntryType(MultiC.ItemIndex)=Entry_Is_Directory Then Deltree(MultiC.Values[1,MultiC.ItemIndex]);
          IF QueryEntryType(MultiC.ItemIndex)=Entry_IS_File Then DeleteFile(MultiC.Values[1,MultiC.ItemIndex]);
          Status:=1;
          ReadCUrrentDirectory;
     End;
End;

Procedure TFileDialogWork.MenuItemRenameOnClick (Sender: TObject);
VAR F:File;S:String;IOError:Longint;
Begin
     S:=MultiC.Values[1,MultiC.ItemIndex];
     CreateRenameDialog.Caption:=RenameDLGCaption;
     CreateRenameDialog.GroupBox1.Caption:=RenameDlgMessage;
     IF CreateRenameDialog.Execute(S) then
     Begin
          system.Assign(F,MultiC.Values[1,MultiC.ItemIndex]);Rename(F,S);IOError:=IOResult;
          IF IOError<>0 Then Begin MyErrorBox(SysErrorMessage(IOError));exit;End;
          Status:=1;
          ReadCurrentDirectory;
     End;

End;

Procedure TFileDialogWork.MultiCOnItemFocus (Sender: TObject; Index: LongInt);
VAR ATTR:Longint;
Begin
     IF Length(CurrentDirectory)>3 Then Filename:=CurrentDirectory+'\'+GetMultiValueStr(MultiC.Items[Index],1)
                                   else FileName:=CurrentDirectory+GetMultiValueStr(MultiC.Items[Index],1);
     Attr:=FileGetAttr(FileName);
     IF Attr and faDirectory=0 Then COmboBox1.Text:=GetMultiValueStr(MultiC.Items[Index],1);
End;

Procedure TFileDialogWork.Button1OnClick (Sender: TObject);
VAR Key:TKeyCode;
Begin
     Key:=KBEnter;
     ComboBox1.OnScan(Self,Key);
End;

Procedure TFileDialogWork.MultiCOnItemSelect (Sender: TObject; Index: LongInt);
VAR Attr:Longint;
Begin
     Attr:=QueryEntryType(Index);

     IF (ATTR=Entry_is_Directory) or (Attr=Entry_is_Drive) Then
     Begin
          IF ChangeDirectory(GetMultiValueStr(MultiC.Items[Index],1)) Then
          Begin
               ReadCurrentDirectory;
               Status:=1;
          End;
     End;
     IF Attr=Entry_is_File Then
     Begin
          DismissDlg(cmOK);
     End;
End;

Procedure TFileDialogWork.ComboBox1OnScan (Sender: TObject; Var KeyCode: TKeyCode);
VAR ATTR:Longint;
Begin
     IF (KeyCOde=KBENter) or (KeyCode=KBCR) Then
     Begin
          KeyCode:=kbNull;
          ComboBox1.Items.add(ComboBox1.Text);
          IF POS('?',ComboBox1.Text)>0 then Begin CurrentFilterMask:=ComboBox1.Text;ReadCurrentDirectory;exit;End; // wurde "?" eingegeben , wenn ja erneut Verzecihniss+Dateien einlesen
          IF POS('*',ComboBox1.Text)>0 then Begin CUrrentFilterMask:=ComboBox1.Text;ReadCurrentDirectory;exit;End; //wurde "*" eingegeben , wenn ja erneut Verzecihniss+Dateien einlesen
             Attr:=FileGetAttr(ComboBox1.Text); // Sollte kein ? oder * eingegeben worden sein, handelt es sich entweder um eine Datei oder ein Verzeichniss
              IF Attr and faDirectory<>0 Then // Ist eingabe ein Verzeichniss ?
                 Begin
                      // EIngabe ist ein Verzeichniss, wechseln ins Zielverzeichniss und ernuete verz+dateiliste einlesen
                      IF ChangeDirectory(COmboBox1.Text) Then Begin ReadCurrentDirectory;Status:=1;End;
                 End else
          Begin
               // Eingabe ist eine Datei
               IF Length(CurrentDirectory)>3 Then Filename:=CurrentDirectory+'\'+ComboBox1.Text
                                   else FileName:=CurrentDirectory+ComboBox1.Text;
               DismissDlg(cmOK);
          End;
     End;
End;


Procedure TFileDialogWork.FilterFileEntry(aSearchRec:TSearchRec);

          Procedure TypeExe;
          Begin
               MultiC.AddObject('|'+aSearchRec.Name+'|'+ExeType+'|'+DateAndTime.FileSizeStr2+'|'+DateAndTime.DateStr,IconExeFile);
          End;

          Procedure TypeImage;
          Begin
               MultiC.AddObject('|'+aSearchRec.Name+'|'+ImageType+'|'+DateAndTime.FileSizeStr2+'|'+DateAndTime.DateStr,IconImage);
          End;

          Procedure TypeDefault;
          Begin
               // Header=Dummy|Icon | Titel | TYP | Gr”แe | Datum
               MultiC.AddObject('|'+aSearchRec.Name+'|'+FileSplit(aSearchRec.Name,5)+' '+DefaultType+'|'+DateAndTime.FileSizeStr2+'|'+DateAndTime.DateStr,IconDefaultFile);
          End;

          Procedure TypeText;
          Begin
               MultiC.AddObject('|'+aSearchRec.Name+'|'+FileSplit(aSearchRec.Name,5)+' '+TextType+'|'+DateAndTime.FileSizeStr2+'|'+DateandTime.DateStr,IconTextFile);
          End;

          Procedure TypeSFV;
          Begin
               MultiC.AddObject('|'+aSearchRec.Name+'|'+FileSplit(aSearchRec.Name,5)+' '+CheckSumType+'|'+DateAndTime.FileSizeStr2+'|'+DateAndTime.DateStr,IconCRCFile);
          End;

          Procedure TypeAudio;
          Begin
                MultiC.AddObject('|'+aSearchRec.Name+'|'+FileSplit(aSearchRec.Name,5)+' '+AudioType+'|'+DateAndTime.FileSizeStr2+'|'+DateAndTime.DateStr,IconAudio);
          End;
Begin
        IF FileSplit(aSearchRec.Name,3)='.EXE' Then Begin TypeExe;exit;End;
        IF FileSplit(aSearchRec.Name,3)='.TXT' Then Begin TypeText;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.BMP' Then Begin TypeImage;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.ICO' Then Begin TypeImage;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.GIF' Then Begin TypeImage;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.JPG' Then Begin TypeImage;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.SFV' Then Begin TypeSFV;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.MD5' Then Begin TypeSFV;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.WAV' Then Begin TypeAudio;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.MID' Then Begin TypeAudio;Exit;End;
        IF FileSplit(aSearchRec.Name,3)='.MP3' Then Begin TypeAudio;Exit;End;

        {Sollte keiner der Typen gefunden werden, Standart Typ annehmen}
        TypeDefault;
End;

Procedure TFileDialogWork.FilterComboBox1OnChange (Sender: TObject);
Begin
     ComboBox1.Text:=FilterComboBox1.Mask;
     CurrentFiltermask:=ComboBox1.Text;

     IF RefreshDir Then ReadCurrentDirectory;
End;

Procedure TFileDialogWork.ButtonDriveViewOnClick (Sender: TObject);
Begin
     IF Status=1 Then Begin Status:=2;DisplayDrives;exit;End;
     IF Status=2 Then Begin Status:=1;ReadCurrentDirectory;exit;ENd;
End;



Procedure TFileDialogWork.ButtonFolderUpOnClick (Sender: TObject);
Begin
     Chdir('..');
     IF MyCurrentDir=LabelCurrentPath.Caption Then
     Begin
          Status:=2;DIsplayDrives;exit;
     End;
     ReadCurrentDirectory;
End;

Procedure TFileDialogWork.ButtonFolderNewOnClick (Sender: TObject);
VAR NewName:String;
Begin
     CreateRenameDialog.Create(Self);
     NewName:=DirectoryType;
     IF CreateRenameDialog.Execute(NewName) Then
     Begin
          {$I-}
               Mkdir(NewName);IF IoResult<>0 Then ErrorBox('Fehler beim Erstellen des Verzeichnises !');
          {$I+}
          Status:=1;
          ReadCurrentDirectory;
     End;
     CreateRenameDialog.Destroy;
End;

 Function TFileDialogWork.SearchString:String;
 Begin
      IF length(CurrentDirectory)<>3 Then Result:=CurrentDirectory+'\*.*' else Result:='*.*';
 End;

 Function TFileDialogWork.MyCurrentDir:String;
 VAR D:String;
 Begin
      GetDir(0,D);Result:=D;
 End;


Procedure TFileDialogWork.FileDialogWorkOnDestroy (Sender: TObject);
Begin
    //ShowMessage('Destroy');
    IconHardDisk.Destroy;
    IconCDROM.Destroy;
    IconRemote.Destroy;
    IconFloppy.Destroy;
    IconRamDrive.Destroy;
    BitmapDriveBtn.Destroy;
    BitmapFileBtn.Destroy;
    IconDirectory.Destroy;
    IconDefaultFile.Destroy;
    IconExeFile.Destroy;
    IconTextFile.Destroy;
    IconArchive.Destroy;
    IconImage.Destroy;
    IconCMD.Destroy;
    IconFont.Destroy;
    IconDos.Destroy;
    IconCRCFIle.Destroy;
    IconAudio.Destroy;
    DateAndTime.Destroy;
End;

Procedure TFileDialogWork.Form1OnCreate (Sender: TObject);
Begin
    IconHardDisk.Create;
    IconCDROM.Create;
    IconRemote.Create;
    IconFloppy.Create;
    IconRamDrive.Create;
    BitmapDriveBtn.Create;
    BitmapFileBtn.Create;
    IconCRCFile.Create;
    IconDirectory.Create;
    IconDefaultFile.Create;
    IconExeFile.Create;
    IconTextFile.Create;
    IconArchive.Create;
    IconImage.Create;
    IconCMD.Create;
    IconFont.Create;
    IconDos.Create;
    IconAudio.Create;
    RefreshDir:=False;
    Filter:='Backup Ini Files|*.INI';
    ExeType         :='Application';
    ImageType       :='Grafic Image';
    CMDType         :='Batch File';
    FontType        :='Font File';
    TextType        :='Text File';
    ArchiveType     :='Archive File';
    DefaultType     :='File';
    DirectoryType   :='Folder';
    CheckSumType    :='Checksum File';
    AudioType       :='Audio File';
    ERROR_DIRChangeFailed:='Changeing into target direcory is not possible !';
    RenameDlgCaption:='Rename';
    RenameDlgMessage:='New Name : ';
    DeleteDlgCaption:='Delete Confirmation';
    DeleteDlgMessage:='Are you sure that you want to delete the selected entry ?';
    DateTimeOptions.DayMonthYear:=True;
    DateTimeOptions.YearMonthDay:=FALSE;
    DateTimeOptions.MonthDayYear:=FALSE;
    ButtonDriveCaptionDrive:='Displays the drives connected to your computer';
    ButtonDriveCaptionFiles:='Switch to filelist display';
    LoadIconsFromResource;
    FilterIndex:=0;
    DateAndTime.Create;
End;

 {
 ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Directory Scan Routine                                                บ
 บ                                                                          บ
 บ                                                                          บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


  Function TFileDialogWork.ReadCurrentDirectory:Boolean;
 VAR SearchRec:TSearchRec;DOSError:Longint;FAMyFiles:Longint;a:Longint;
 Begin

      IF not DriveReady Then exit;
      MultiC.Clear;
      ButtonDriveView.Hint:=ButtonDriveCaptionDrive;
      ButtonDriveView.Glyph:=BitmapDriveBtn;
      GetDir(0,CurrentDirectory);
      MyDOSError:=Sysutils.FindFirst(SearchString,Directory shl 8 OR AnyFile,SearchRec);
      MultiC.BeginUpdate;
      While MyDOSError=0 do
      Begin
                IF (SearchRec.Name<>'..') and (SearchRec.Name<>'.') Then
                Begin
                     //DateTime:=UnpackDateTime(SearchRec,DateTimeOptions);
                     //MultiC.addObject('|'+SearchRec.Name+'|'+DirectoryType+'|'+'|'+DateTime.DateString,IconDirectory);
                     DateandTime.GetFileDateTime(SearchRec);
                     MultiC.addObject('|'+SearchRec.Name+'|'+DirectoryType+'|'+'|'+DateandTime.DateStr,IconDirectory);
                End;
                MyDOSError:=SysUtils.FindNext(SearchRec);
      End;
      IF (MyDOSError<0) and (MyDosError<>-18) Then
      Begin
           MyErrorBox(SysErrorMessage(26));SysUtils.FindClose(SearchRec);Result:=FALSE;
           exit;
      End;
      Sysutils.FindCLose(SearchRec);

      // Verzeichnis nur nach Dateien absuchen
      LabelCurrentPath.Caption:=CurrentDirectory;
      FAMyFiles:=faReadOnly or faHidden or faSysFile or faArchive;
      DOSError:=Sysutils.FindFirst(CurrentFilterMask,faMyFiles,SearchRec);
      While DOSError=0 do
      Begin
           //DateTime:=UnpackDateTime(SearchRec,DateTimeOptions);
           DateAndTime.GetFileDateTime(SearchRec);
           FilterFileEntry(SearchRec);
           DosError:=SysUtils.FIndNext(SearchRec);
      End;
      SysUtils.FindClose(SearchRec);
      MultiC.EndUpdate;
      Result:=TRUE;
 End;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Laufwerke Anzeigen                                                    บ
 บ                                                                          บ
 บ                                                                          บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Procedure TFileDialogWork.DisplayDrives;
VAR LOOP:Byte;

          Procedure HardDiskDrive;
          Begin
                MultiC.AddObject('DRIVE|'+chr(64+Loop)+':\|Local Drive',IconHardDisk);
          End;

          Procedure RAMDiskDrive;
          Begin
                MultiC.AddObject('DRIVE|'+chr(64+Loop)+':\|RAM Disc Drive',IconRamDrive);
          End;

          Procedure RemoteDrive;
          Begin
               MultiC.AddObject('DRIVE|'+chr(64+Loop)+':\|Network Drive',IconRemote);
          End;
          Procedure CDROMDrive;
          Begin
               MultiC.AddObject('DRIVE|'+chr(64+Loop)+':\|CD/DVD-ROM Drive',IconCDROM);
          End;

          Procedure FloppyDrive;
          Begin
              MultiC.AddObject('DRIVE|'+chr(64+Loop)+':\|Floppy Drive',IconFloppy);
          END;

Begin
     Cursor:=CrHourGlass;
     ButtonDriveView.Glyph:=BitmapFileBtn;
     ButtonDriveView.Hint:=ButtonDriveCaptionFiles;
     UGetDriveMap;
     MultiC.Clear;
     For Loop:=1 to 26 do
     Begin
         IF floppy in  [garDrives[Loop].edriveType]  Then FLOPPYDrive;
         IF HardDisk in  [garDrives[Loop].edriveType]  Then HardDiskDrive;
         IF RAMDisk in  [garDrives[Loop].edriveType]  Then RAMDiskDrive;
         IF CDROM in     [garDrives[Loop].edriveType]  Then CDROMDrive;
         IF Remote in    [garDrives[Loop].edriveType]  Then RemoteDrive;
     End;
     Cursor:=CrDefault;

End;


Function InsertMultiColumnList(parent:TControl;Left,Bottom,Width,Height:LongInt;Hint:String):TMultiColumnList;
Begin
    { Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Hint:=Hint;
     Result.Duplicates:=True;
     Result.Separator:='|';
     Result.parent := parent;
     Result.Sections.Add;
     Result.Align:=alNone;
     Result.Enabled:=True;
     Result.SaveLoadInfo:=FALSE;
     Result.ZOrder:=zoBottom;}
End;

Procedure TFileDialogWork.Form1OnSetupShow (Sender: TObject);
VAR S:String;l:Longint;HeaderSection: THeaderSection;

Begin
    {Test:=InsertMultiColumnList(Self,12,14,581,229,'Test');Test.Create(Nil);
    HeaderSection := Test.Sections.Add;
    HeaderSection.Text :='Test';
    HeaderSection.Alignment := taLeftJustif                                     y;
    HeaderSection.Width :=253;}

    // Gegenwrtiges Verzeichnis einlsen

     //IconDirectory.LoadFromFile('F:\WDSibyl\Projects\icons\Folder.ICO');



     Status:=1; {Standart Darstellungsmodus ist Dateiliste}
     IF filter='' Then Begin ErrorBox('FileDialog Fehler ! Variable "Filter" besitzt keinen Wert !');Halt;End;

     FilterComboBox1.Filter:=Filter;
     FilterComboBox1.ItemIndex:=FilterIndex;
     RefreshDir:=TRUE;
     ReadCurrentDirectory;
End;

Procedure TFileDialogWork.LoadIconsFromResource;
Begin
     TRY
     IconHardDisk.LoadFromResourceName('HardDisk');
     Except ExceptionBox('Hard Disk Icon invalid or not found !');
     End;
     IconCDRom.LoadFromResourceName('CDROM');
     IconFloppy.LoadFromResourceName('FLOPPY');
     IconRemote.LoadFromResourceName('Remote2');
     IconRamDrive.LoadFromResourceName('RAMDrive');

     BitmapDriveBtn.LoadFromResourceName('MYDrives');
     BitmapFileBtn.LoadFromResourceName('MYFiles');

     IconDirectory.LoadFromResourceName('Directory');
     IconDefaultFile.LoadFromResourceName('DefaultFile');

    IconExeFile.LoadFromResourceName('ExeFile');
    IconTextFile.LoadFromResourceName('TextFile');
    IconArchive.LoadFromResourceName('Archive');
    IconImage.LoadFromResourceName('Image');;
    IconCMD.LoadFromResourceName('CMD');;
    IconFont.LoadFromResourceName('Font');;
    IconDos.LoadFromResourceName('DOS');;
    IconCRCFile.LoadFromResourceName('CRC32');
    IconAudio.LoadFromResourceName('Audio');
End;

Function TFileDialogWork.Execute:Boolean;
VAR RC:Longint;
Begin
        RC:=ShowModal;
        IF RC=CMCancel Then Result:=FALSE;
        IF RC=CMOK     Then Result:=TRUE;
End;


Initialization
  RegisterClasses ([TFileDialogWork, TLabel, TBitBtn, tMultiColumnList, TComboBox,TGroupBox,TEdit,
    TFilterComboBox, TButton, TImage, TMenuItem, TMemo,TCreateRenameDialog
   , TPopupMenu]);
End.
