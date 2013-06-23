Unit TCP_NFSWizard;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, TabCtrls, Buttons, Dialogs, ExtCtrls,
  EditList,PMWIN,menus,Messages;

Type
  TNFSWizard = Class (TForm)
    GroupBox1: TGroupBox;
    Title: TLabel;
    NoteBook1: TNoteBook;
    BackButton: TButton;
    NextButton: TButton;
    Label0: TLabel;
    GrpBoxDir: TGroupBox;
    Edit1: TEdit;
    BrowseButton: TButton;
    Label4: TLabel;
    GrpBoxAlias: TGroupBox;
    EditAlias: TEdit;
    Label5: TLabel;
    GrpBoxComment: TGroupBox;
    EditComment: TEdit;
    Image1: TImage;
    Label7: TLabel;
    Label8: TLabel;
    CancelButton: TButton;
    ComboBox1: TComboBox;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    RadioButtonPubWrite: TRadioButton;
    AddButton: TButton;
    DeleteButton: TButton;
    Label11: TLabel;
    GrpBoxRights: TGroupBox;
    RadioButtonRead: TRadioButton;
    RadioButtonWrite: TRadioButton;
    RadioButtonPubRead: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Procedure RadioButtonPubWriteOnClick (Sender: TObject);
    Procedure AddButtonOnClick (Sender: TObject);
    Procedure NFSWizardOnDestroy (Sender: TObject);
    Procedure MenuItem1OnClick (Sender: TObject);
    Procedure ComboBox1OnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure EditAliasOnChange (Sender: TObject);
    Procedure RadioButtonPubOnClick (Sender: TObject);
    Procedure RadioButtonWriteOnClick (Sender: TObject);
    Procedure RadioButtonReadOnClick (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure Edit1OnChange (Sender: TObject);
    Procedure NFSWizardOnSetupShow (Sender: TObject);
    Procedure BackButtonOnClick (Sender: TObject);
    Procedure NextButtonOnClick (Sender: TObject);
    Procedure BrowseButtonOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfgen}
  Public
    {™ffentliche Deklarationen hier einfgen}
  EditFlag:Boolean;
  EditIndex:Longint;
  End;

Var
  NFSWizard: TNFSWizard;

Implementation
USES DebugUnit,TCP_Var_Unit,DirChangeDlg,TCP_LanguageUnit,MyMessageBox;



Procedure TNFSWizard.RadioButtonPubWriteOnClick (Sender: TObject);
Begin
     NextButton.Enabled:=True;
End;

Procedure TNFSWizard.AddButtonOnClick (Sender: TObject);
  VAR Key:TKeyCode;
Begin
  Key:=kbEnter;
  ComBoBox1.OnScan(Self,Key);
End;

Procedure TNFSWizard.NFSWizardOnDestroy (Sender: TObject);
Begin
     DirDialog.Destroy;
End;

Procedure TNFSWizard.MenuItem1OnClick (Sender: TObject);
Begin
     TRY
     Combobox1.items.delete(ComboBox1.ItemIndex);
     Except
     End;
     IF ComboBox1.Items.count=0 Then NextButton.Enabled:=FALSE;
End;

Procedure TNFSWizard.ComboBox1OnScan (Sender: TObject; Var KeyCode: TKeyCode);
Begin
     IF (KeyCode=KBEnter) or (KeyCode=264) then
     Begin
          KeyCode:=kbNull;
          IF ComboBox1.Text='' Then Begin MyInfoBox(GetNlsString('Message','NO_HOST_ENTRYS'));exit;End;
          IF POS(' ',ComboBox1.text)>0 then BEgin MyInfoBox(GetNlsString('Message','NO_HOST_SPACES'));exit;End;
          ComBoBox1.items.add(ComboBox1.Text);
          ComBoBox1.Text:='';
          NextButton.Enabled:=TRUE;

     End;
End;


Procedure TNFSWizard.EditAliasOnChange (Sender: TObject);
Begin
    IF Length(EditAlias.text)>0 Then NextButton.Enabled:=TRUE else NextButton.Enabled:=FALSE;
End;

Procedure TNFSWizard.RadioButtonPubOnClick (Sender: TObject);
Begin
     NextButton.Enabled:=TRUE;
End;

Procedure TNFSWizard.RadioButtonWriteOnClick (Sender: TObject);
Begin
NextButton.Enabled:=TRUE;
End;

Procedure TNFSWizard.RadioButtonReadOnClick (Sender: TObject);
Begin
     NextButton.Enabled:=True;
End;

Procedure TNFSWizard.NoteBook1OnPageChanged (Sender: TObject);
VAR loop:Byte;S:String;
Begin
         Case Notebook1.PageIndex of
         0:Begin BackButton.Enabled:=FALSE;Edit1OnChange(Self);End;
         1:Begin
                //WinSetFocus(Hwnd_Desktop,EditAlias.handle);
                BackButton.Enabled:=True;
                NextButton.Enabled:=FALSE;
                IF RadioButtonPubRead.Checked Then NextButton.Enabled:=TRUE;
                IF RadioButtonRead.Checked Then NextButton.Enabled:=TRUE;
                IF RadioButtonWrite.Checked Then NextButton.Enabled:=True;
                IF RadioButtonPubWrite.checked Then NextButton.Enabled:=TRUE;
           End;
         2:Begin
                NextButton.Enabled:=FALSE;
                EditAliasOnChange(Self);
                EditAlias.Focus;
           End;
         3:Begin
                IF ComboBox1.Items.count>0 Then NextButton.Enabled:=True else NextButton.Enabled:=FALSE;
           End;
         4:begin
                NextButton.Caption:=GetNlsString('NFS-Wizard','Ready');
           End;
         5:Begin
                Close;ModalResult:=CmOK;ChangeRec.NFS:=True;
                IF not EditFlag then
               Begin
                DebugForm.lbNFSDirectory.items.add(Edit1.text);
                DebugForm.lbNFSAlias.Items.add(EditAlias.Text);
                DebugForm.lbNFSComment.items.add(EditComment.Text);
                DebugForm.lbNFSPublicDir.items.add('');
                IF RadioButtonPubRead.Checked Then DebugForm.lbNFSRights.items.add('PR');
                IF RadioButtonPubWrite.Checked Then DebugForm.lbNFSRights.items.add('PW');
                IF RadioButtonRead.Checked Then DebugForm.lbNFSRights.items.add('HR');
                IF RadioButtonWrite.Checked Then DebugForm.lbNFSRights.Items.add('HW');
                IF ComboBox1.Items.count=0 Then exit;
                For loop:=0 to ComboBox1.items.count-1 do
                begin
                     TRY
                     NFSHostListArray[DebugForm.lbNFSDirectory.Items.Count-1].Add(ComBoBox1.Items[loop]);
                     Except ErrorBox('Unit TCP_NFS_Wizard Zugriffsverletzung Zeile 180');Halt;
                     End;
                     //S:=NFSHostListArray[DebugForm.lbNFSDirectory.Items.count-1][loop];
                End;
                //ShowMessage(TOStr(NFSReadListArray[DebugForm.lbNFSDirectory.items.count].count));
               End else
               Begin
                    DebugForm.lbNFSDirectory.items[EditIndex]:=Edit1.text;
                    DebugForm.lbNFSAlias.Items[EditIndex]:=EditAlias.Text;
                    DebugForm.lbNFSComment.Items[EditIndex]:=EditComment.Text;
                    IF  RadioButtonPubRead.Checked Then DebugForm.lbNFSRights.items[EditIndex]:='PR';
                    IF  RadioButtonPubWrite.Checked Then DebugForm.lbNFSRights.items[EditIndex]:='PW';
                    IF RadioButtonRead.Checked Then DebugForm.lbNFSRights.items[EditIndex]:='HR';
                    IF RadioButtonWrite.Checked Then DebugForm.lbNFSRights.Items[EditIndex]:='HW';
                    NFSHostListArray[EditIndex].Clear;
                    TRY
                    For loop:=0 to ComboBox1.items.count-1 do
                     begin
                     NFSHostListArray[EditIndex].add(ComBoBox1.Items[loop]);
                     //S:=NFSHostListArray[EditIndex.lbNFSDirectory.Items.count-1][loop];
                     End;
                     Except ErrorBox('Unit TCP_VAR_NFS_Wizard Zurgiffsverletzung Zeile 201');Halt;
                     End;
               End;

           End;
         end;
   End;

Procedure TNFSWizard.Edit1OnChange (Sender: TObject);
Begin
   IF Length(Edit1.Text)>2 Then NextButton.Enabled:=True else NextButton.Enabled:=False;
End;

Procedure TNFSWizard.NFSWizardOnSetupShow (Sender: TObject);
Begin
     Edit1.Focus;Notebook1.PageIndex:=0;
     IF EditFlag Then
     begin
          Edit1.Text:=DebugForm.lbNFSDirectory.items[EditIndex];
          IF DebugForm.lbNFSRights.items[EditIndex]='HW' Then RadioButtonWrite.Checked:=True;
          IF DebugForm.lbNFSRights.items[EditIndex]='HR' Then RadioButtonRead.Checked:=TRUE;
          IF DebugForm.lbNFSRights.items[EditIndex]='PR' Then RadioButtonPubRead.checked:=true;
          IF DebugForm.lbNFSRights.items[EditIndex]='PW' Then RadioButtonPubWrite.checked:=true;

          ComboBox1.Items:=NFSHostListArray[EditIndex];
          EditAlias.Text:=DebugForm.lbnfsAlias.items[EditIndex];
          EditComment.Text:=DebugForm.lbNfsComment.items[EditIndex];
     End else
     Begin
          Edit1.text:='';
          EditAlias.Text:='';
          EditComment.Text:='';
          ComBoBox1.Items.Clear;
          ComboBox1.text:='';
          RadioButtonRead.Checked:=False;
          RadioButtonWrite.checked:=False;
          RadioButtonPubRead.checked:=False;
          RadioButtonPubWrite.checked:=False;
     End;

      DirDialog.Create;

      // NLS Settings
      Caption:=GetNLSString('NFS-Wizard','CAPTION');
      Title.Caption  :=GetNLSString('NFS-Wizard','Title');
      Label0.Caption:=GetNlsString('NFS-Wizard','Label#0');
      Label1.Caption:=GetNlsString('NFS-Wizard','Label#1');
      Label2.Caption:=GetNlsString('NFS-Wizard','Label#2');
      Label3.Caption:=GetNlsString('NFS-Wizard','Label#3');
      Label4.Caption:=GetNlsString('NFS-Wizard','Label#4');
      Label5.Caption:=GetNlsString('NFS-Wizard','Label#5');
      Label6.Caption:=GetNlsString('NFS-Wizard','Label#6');
      Label7.Caption:=GetNLSString('NFS-Wizard','Label#7');
      Label8.Caption:=GetNLSString('NFS-Wizard','Label#8');
      GrpBoxDir.Caption:=GetNlsString('NFS-Wizard','GrpBoxDir');
      GrpBoxRights.Caption:=GetNlsString('NFS-Wizard','GrpBoxRights');
      GrpBoxAlias.Caption:=GetNlsString('NFS-Wizard','GrpBoxAlias');
      GrpBoxComment.Caption:=GetNlsString('NFS-Wizard','GrpBoxComment');
      BrowseButton.Caption:=GetNlsString('NFS-Wizard','BrowseButton');
      NextButton.Caption:=GetNlsString('NFS-Wizard','NextButton');
      BackButton.Caption:=GetNlsString('NFS-Wizard','BackButton');
      CancelButton.Caption:=GetNlsString('NFS-Wizard','CancelButton');
      RadioButtonRead.Caption:=GetNlsString('NFS-Wizard','RadioButtonRead');
      RadioButtonWrite.Caption:=GetNlsString('NFS-Wizard','RadioButtonWrite');
      RadioButtonPubRead.Caption:=GetNlsString('NFS-Wizard','RadioButtonPubRead');
      RadioButtonPubWrite.Caption:=GetNlsString('NFS-Wizard','RadioButtonPubWrite');
      AddButton.Caption:=getNlsString('NFS-Wizard','AddButton');
      DeleteButton.Caption:=getNlsString('NFS-Wizard','DeleteButton');
End;

Procedure TNFSWizard.BackButtonOnClick (Sender: TObject);
Begin
     NoteBook1.PageIndex:=Notebook1.PageIndex-1;
     NextButton.Caption:=GetNlsString('NFS-Wizard','NextButton');
End;

Procedure TNFSWizard.NextButtonOnClick (Sender: TObject);
Begin
     If (Notebook1.pageIndex=2) and (RadioButtonPubRead.checked) then Begin Notebook1.PageIndex:=4;Exit;End;
     If (Notebook1.pageIndex=2) and (RadioButtonPubWrite.checked) then Begin Notebook1.PageIndex:=4;Exit;End;

     NoteBook1.PageIndex:=NoteBook1.PageIndex+1;
End;

Procedure TNFSWizard.BrowseButtonOnClick (Sender: TObject);
Begin
      IF DirDialog.Execute Then Edit1.Text:=DirDialog.Directory;
End;

Initialization
  RegisterClasses ([TNFSWizard, TGroupBox, TLabel, TNoteBook, TButton, TEdit,
    TImage, TRadioButton, TComboBox, TPopupMenu, TMenuItem]);
End.
