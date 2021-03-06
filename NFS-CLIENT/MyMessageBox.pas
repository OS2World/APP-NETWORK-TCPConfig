{
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�                                                                           �
� My own Messagebox Unit                                                    �
�                                                                           �
� Version 2 22.10.2005 - last changed 24.10.2005                            �
�                                                                           �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
}
Unit MyMessageBox;

Interface
Function ConfirmDialog(ACaption,AMessage,B1Name,B2Name:String):boolean;
Procedure MyErrorBox(AMessage:String);
Procedure MyInfoBox(AMessage:String);
Procedure ExceptionBox(AMessage:String);
Implementation

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons,PMWIN,Color,Messages;

{$R MYOwnMessageBox}

Type
   TMyMessageBox=Class(TForm)
      Private
         FMsg:String;
         FHelpCtx:THelpContext;
         FButtons:TMsgDlgButtons;
         fType:TMsgDlgType;
      Protected
         Procedure SetupShow;Override;
         Procedure SetupComponent;Override;
         IconResName:String;
         Image:TImage;
         Label1:TLabel;
         aIcon:TIcon;
         OKButton:TBitBtn;
         CancelButton:TBitBtn;
      Published
         Property Message:String Read FMsg Write FMsg;
         Property Buttons:TMsgDlgButtons Read FButtons Write FButtons;
         Property DlgType:TMsgDlgType Read fType Write fType;
         Property HelpCtx:THelpContext Read FHelpCtx Write FHelpCtx;
      Public
      aMessage:String;
      aCaption:String;
      ButtonCaption:Array[1..2] of String;
      Sound:Boolean;
      StaticOrWindowText:Boolean;
    End;

{
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�                                                                           �
� This section: TmMessageBox Class Implementation                           �
�                                                                           �
� Version 2 22.10.2005                                                      �
�                                                                           �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
}

Function InsertMyImage(Parent:TControl;Left,Bottom,Width,Height:LongInt;BitmapName:String):TImage;
Var  Bitmap:TBitmap;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Bitmap.Create;
     Bitmap.LoadFromResourceName(BitmapName);
     Result.Picture.Graphic:=Bitmap;
     Bitmap.Destroy; {#}
     Result.Parent := Parent;
End;

Procedure TMyMessageBox.SetupShow;
VAR LabelHeightSize:byte;
    FormHeightSize:Byte;
Begin
     Caption:=aCaption;
     IF StaticOrWindowText Then PenColor :=clStaticText else PenColor:=clWindowText;
     IF Ftype=mtConfirmation Then
     Begin
          IconResName:='QUERY_ICO';
          OKButton:=InsertBitBtn(Self,44,12,73,29,bkOK,ButtonCaption[1],'');
          CancelButton:=InsertBitBtn(Self,120,12,73,29,bkCancel,ButtonCaption[2],'');
          If SOund Then WinAlarm(HWND_Desktop,WA_Warning);
     End;

    IF FType=MtInformation Then
    Begin
         IconResName:='Info_ICO';
         OKButton:=InsertBitBtn(Self,76,12,73,29,bkOK,ButtonCaption[1],'');
         If SOund Then WinAlarm(HWND_Desktop,WA_Note);
    End;

    IF FType=MtError Then
    Begin
         IconResName:='Error_ICO';
         OKButton:=InsertBitBtn(Self,76,12,73,29,bkOK,ButtonCaption[1],'');
         If SOund Then WinAlarm(HWND_Desktop,WA_Error);
    End;
      aIcon.Create;
      aIcon.loadfromResourceName(IconResName);
      Image:=InsertMyImage(Self,8,54,32,32,'Dummy');
      Image.Bitmap:=aIcon;
      Image.Align:=alFixedLeftTop;
      aIcon.Destroy;
      Label1:=InsertLabel(Self,48,74,185,15,aMessage);
      Label1.WordWrap:=True;
      Label1.Align:=alFixedLeftTop;

          LabelHeightSize:=Label1.Rows*15;
          Label1.Height:=LabelHeightSize;
          FormHeightSize:=Height+labelHeightSize;
          Height:=FormHeightSize-15;
End;

Procedure TMyMessageBox.SetupComponent;
Begin
     Inherited SetupComponent;
     XAlign := xaCenter;
     YAlign := yaCenter;
     Color := clDlgWindow;
     ParentPenColor := False;
     ParentColor := False;
     BorderIcons := [biSystemMenu];
     BorderStyle := bsDialog;
     Visible := FALSE;
     Height:=109;
     Width:=247;
     ClientWidth:=239;
     ClientHeight:=77;
     Position:=poScreenCenter;
     Font:=Screen.GetFontFromName('WarpSans',16,14);
End;

{
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�                                                                           �
� This section: Confirm Dialog                                              �
�                                                                           �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
 }

 Function ConfirmDialog(ACaption,AMessage,B1Name,B2Name:String):boolean;
 VAr Test:TmyMessageBox;RC:Longint;
 Begin
      Test.Create(Nil);
      Test.DlgType:=mtConfirmation;
      test.aMessage:=aMessage;
      test.aCaption:=aCaption;
      Test.ButtonCaption[1]:=B1Name;
      Test.ButtonCaption[2]:=B2Name;
      Test.Sound:=True;
      RC:=Test.ShowModal;
      IF RC=CMOK Then Result:=TRUE else Result:=FALSE;
      Test.Destroy;
 End;

{
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�                                                                           �
� This section: Error / Exception Box                                       �
�                                                                           �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
 }
 Procedure MyErrorBox(AMessage:String);
 VAr Test:TmyMessageBox;
 Begin
      Test.Create(Nil);
      Test.DlgType:=mtError;
      test.aMessage:=aMessage;
      test.aCaption:='Error';
      Test.ButtonCaption[1]:='~Ok';
      Test.Sound:=True;
      Test.ShowModal;
      Test.Destroy;
 End;

 Procedure ExceptionBox(AMessage:String);
 VAr Test:TmyMessageBox;
 Begin
      Test.Create(Nil);
      Test.DlgType:=mtError;
      test.aMessage:=aMessage;
      test.aCaption:='Exception aufgetreten';
      Test.ButtonCaption[1]:='~Ok';
      Test.StaticOrWindowText:=FALSE;
      Test.Sound:=True;
      Test.ShowModal;
      Test.Destroy;
 End;
{
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�                                                                           �
� This section: Info Box                                                    �
�                                                                           �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
}

 Procedure MyInfoBox(AMessage:String);
 VAr Test:TmyMessageBox;
 Begin
      Test.Create(Nil);
      Test.DlgType:=mtInformation;
      test.aMessage:=aMessage;
      Test.StaticOrWindowText:=True;
      test.aCaption:='Information';
      Test.ButtonCaption[1]:='~Ok';
      Test.Sound:=TRUE;
      Test.ShowModal;
      Test.Destroy;
 End;


Initialization
End.
