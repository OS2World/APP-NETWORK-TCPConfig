Unit NFS_LanguageUnit;

Interface
         Function GetNlsString(Section:String;Key:String):String;
         Function NlsButton(Button:String):String;
         Function NLSDialog(DIalogName:String):Boolean;
         Procedure NLSInavlidIPDialog(EntryField:Byte);
         Procedure ViewHelp(HelpIndex:Longint);
         Function NLSInput(DialogName:String;VAR Return:String):boolean;
         Procedure NlsErrorBox(NLSSection:String);
         Procedure NlsInfoBox(NLSSection:String);
Implementation
Uses NFS_VAR_Unit,NFS_UtiltyUnit,Forms,MyMessageBox,NFS_NLS_IniFileUnit,Dialogs;
//TCP_Var_Unit,DOs,TCP_IniFiles,Dialogs,Classes,MYMessageBox,{TCP_Options}Forms,TCPUtilityUnit,TCP_NewIniFile;



     Procedure ViewHelp(HelpIndex:Longint);
     VAR STR1:String;
         Index:Longint;

     Begin
          Str1:=GetNLSString('GENERAL','IPF_Help_Index');
          Index:=ToInt(STR1)+HelpIndex;
          //ShowMessage(ToStr(Index));
          IF not Application.Help(Index) Then myInfoBox('Sorry ... '+#13+'Help Index : '+ToStr(Index)+' not found');
     End;




     Function GetNlsString(Section:String;Key:String):String;
     Begin
                If not NLSIni.ReadString(Section,Key,Result) then
                Begin
                     MyErrorBox(NlsIni.ErrorString);
                     Halt;
                End;
     End;


Function NlsButton(Button:String):String;
Begin
     Result:=GetNlsString('NW_BUTTONS',Button);
End;

Function NLSDialog(DIalogName:String):Boolean;
VAR
   aCaption:String;
   aMessage:String;
   Button1:String;
   Button2:String;
BEgin
   aCaption:=GetNlsString(DialogName,'Caption');
   aMessage:=GetNlsString(DialogName,'Title');
   Button1:=GetNlsString(DialogName,'Button_YES');
   Button2:=GetNlsString(DIalogName,'Button_NO');
   Result:=ConfirmDialog(aCaption,aMessage,Button1,Button2);
End;

Function NLSInput(DialogName:String;VAR Return:String):boolean;
Begin
     Result:=InputQuery(GetNLSString(DialogName,'CAPTION'),GetNlsString(DialogName,'Title'),Return);
End;

Procedure NLSInavlidIPDialog(EntryField:Byte);
VAR Mess,SUBMess:String;
Begin

case EntryField of
     EF_IPNUM   : Mess:=GetNlsString('MESSAGE','INVALID_IP_Adress');
     EF_SUBNET  : Mess:=GetNLSString('Message','Invalid_Subnet');
End;

    IF  Default_IP_Error.MissingPoint Then  SubMess:=GetNlsString('Message','MISS_IP_POINT');
    IF  Default_IP_Error.MissingNumber Then SubMess:=GetNlsString('Message','MISS_IP_Number');
    IF  Default_IP_Error.PointOverflow Then SubMess:=GetNlsString('Message','DOT_Overflow');
    IF  Default_IP_Error.InValidSigns  Then  SubMess:=GetNlsString('Message','Illegal_Char');
    IF  Default_IP_Error.InvalidNumber Then SubMess:=GetNlsString('Message','IP_Out_of_Range');

    MyInfoBox(Mess+#13+SubMess);
End;


Procedure NLSErrorBox(NlsSection:String);
Begin
     MyErrorBox(GetNLSString('ERRORS',NLSSection));
End;

 Procedure NlsInfoBox(NLSSection:String);
 Begin
      MyInfoBox(GetNlsString('MESSAGE',NlsSection));
 End;


End.
