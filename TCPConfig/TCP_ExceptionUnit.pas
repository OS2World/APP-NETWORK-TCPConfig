Unit TCP_ExceptionUnit;

Interface
         Procedure DisplayException(Num:longint);
Implementation



Uses
  Classes, Forms, Graphics, StdCtrls, ExtCtrls, Buttons,PMWIN,DebugUnit,TCP_VAr_Unit,Dialogs;

Type
  TFormException = Class (TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    LabelExceptionMessage: TLabel;
    BitBtn2: TBitBtn;
    Procedure BitBtn2OnClick (Sender: TObject);
    Procedure FormExceptionOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

  Var
  FormException: TFormException;
  aString:String;
Procedure TFormException.BitBtn2OnClick (Sender: TObject);
Begin
  DebugForm.ShowModal;
End;

Procedure TFormException.FormExceptionOnSetupShow (Sender: TObject);
Begin
      WinAlarm(HWND_DESKTOP,WA_ERROR);
End;

              Procedure DisplayException(Num:longint);
              VAR S:String;
              Begin
                   Case Num of
                    0:S:='TabbedNotebook Pages out of Range !'+#13+'Page ; '+ToStr(ExceptionHelpByte);
                    1:S:='Function MakeListBox1Entry auf Array lbIPsetupLanNum.items[Index] konnte nicht zugegriffen werden';
                    2:S:='Function MakeListBox1Entry auf Array LBIpSetupIPAdress.Items[Index] konnte nicht zugeriffen werden';
                    3:S:='Function MakeListBox1Entry auf Array LBIpSetupSubnetmask.items[Index] konnte nicht zugegrifen werden';
                    4:S:='Unit TCP_IP_Wizard3  Auf DebugForm.LBIpSetupBroadcast.Items[EditIndex] konnte nicht zugegriffen werden';
                    5:S:='Unit TCP_IP_Wizard3  Auf DebugForm.LBIPSetupTargetAdress.Items[EditIndex] konnte nicht zugegriffen werden';
                    6:S:='Unit TCP_IP_Wizard3  Auf DebugForm.LBIPSetupMTU konnte nicht zugegriffen werden';
                    7:S:='Unit TCP_IP_Wizard3  Auf DebugForm.LBIPSetupMetric konnte nicht zugegriffen werden';
                    8:S:='UNIT TCP_Unit1 Funktion MakeListBox1EntryString - Auf DebugForm.lbAlias.items[index] konnte nicht zugegriffen werden';
                   20:S:='UNIT TCP_Unit1 Funktion TForm1.ButtonSocksDomainEditOnClick Auf FORM1.ListBoxSocksDomains.items konnte nicht zugegriffen werden !';
                   21:S:='UNIT TCP_Unit1 Funktion TForm1.ButtonSocksDomainEditOnClick Auf DEBUGFORM.ListBoxSocksDomains.items konnte nicht zugegriffen werden !';
                   22:S:='UNIT TCP_Unit1 Funktion TForm1.ButtonSocksDomainEditOnClick Auf FORM1.ListBoxSocksDNS.items konnte nicht zugegriffen werden !';
                   23:S:='UNIT TCP_Unit1 Funktion TForm1.ButtonSocksDomainEditOnClick Auf DEBUGFORM.ListBoxSocksDNS.items konnte nicht zugegriffen werden !';
                   24:S:='UNIT TCP_UNIT1 Fehler in "Procedure MakeListBoxSOCKSServerEntry" - Index ausserhalb der Reichweite ?';
                   25:S:='UNIT TCP_UNIT1 Fehler in Procedure MakeListBoxSOCKSDirectEntry - Index ausserhalb der Reichweite ?';
                   30:S:='UNIT TCP_Unit1 Procedure SetupNFS - NFS Listbox fÅr Form1 konnte nicht aus NFS Debuglistbox zugewiesen werden !';
                   31:S:='UNIT TCP_Unit1 Procedure SetupNFS - NFS Listbox fÅr Public Verzeichnisse konnte nicht aus Debug NFS public liste zugewiesen werden !';
                   32:S:='UNIT TCP_Unit1 Procedure DisplayReadHost - Aufruf von lbNfsHostReadOnly.items:=NFSReadListArray[Index] ist fehlgeschlagen (Index ausserhalb zulÑsser Reichweite ?)';
                   33:S:='UNIT TCP_Unit1 Procedure DisplayReadWriteHost - Aufruf von lbnfsHostReadWrite.items:=NFSReadWriteListArray[Index] ist fehlgeschlagen (Index ausserhalb der Reichweite ?)';
                   34:S:='UNIT TCP_UNIT_QueryEntrys  Procedure QueryEntrys - Aufruf von DebugForm.lbnfsRights.items.insert(AddIndex,"R") ist fehlgeschlagen';
                   40:S:='Unit TCP_AdvancedNotebook Procedure TAdvancedSettings.ButtonAliasIPDeleteOnClick - Lîschen fehlgeschlagen - Aufruf :  IpAliasListArray[ComboBox1.itemIndex].delete(ListBox1.itemIndex)';
                   41:S:='Unit TCP_AdvancedNotebook Procedure TAdvancedSettings.ButtonAliasIPDeleteOnClick  - Lîschen aus Listboix1 fehlgeschlagen - Aufruf : Listbox1.delete(Listbox1.itemindex)';
                   42:S:='Unit TCP_AdvancedNotebook Procedure TAdvancedSettings.ButtonAliasIPEditOnCLick - bearbeiten des Feldes nicht mîglich - Eintrag existiert nicht im Feld !'+#13+'Aufruf : IPAliasListArray[ComboBox1.ItemIndex][ListBox1.ItemIndex]';
                   43:Begin
                           S:='Unit TCP_IP_Wizards Procedure TFormAliasIPWizard.FormAliasIPWizardOnSetupShow'+#13+'Kann nicht auf Alias IP Feld zugreiffen'+#13+
                           'Aufruf Edit1.Text:=IPAliasListArray[EntryAliasArrayIndex].Strings[EntryAliasStringIndex]'+#13+'schlug fehl';
                      End;
                   44:S:='Unit TCP_AdvancedNotebook FormAliasIPWizard Procedure OnSetupShow : Edit2.text konnte nicht von Alias Subnet (IPAliasSubnetListArray) zugewiesen werden';
                   45:S:='Unit TCP_AdvancedNotebook Procedure TAdvancedSettings.ButtonAliasIPEditOnClick'+#13+'Subnet Alias konnte nicht zugewiesen werden';
                   46:S:='Unit TCP_AdvancedNotebook Procedure TAdvancedSettings.ButtonAliasIPDeleteOnClick - Lîschen (subnet) fehlgeschlagen - Aufruf :  IpAliasSubnetListArray[ComboBox1.itemIndex].delete(ListBox1.itemIndex)';
                   50:S:='TCP_UNIT_FileOperation Auf DebugForm.LBHostIP konnte nicht zugegrifen werden (Index ausserhalb der Reichweite ?)';
                   51:S:='TCP_Unit_FileOperation Auf DebugForm.LBHostName konnte nicht zugegriffen werden (Index ausserhalb der Reichweite ?';
                   52:S:='TCP_Unit_FileOperation Auf DebugForm.LBHostAlias konnte nicht zugegriffen werden (Index ausserhalb der Recihweite ?';
                   53:S:='TCP_Unit_FileOperation Auf DebugForm.LBHostComment konnte nicht zugegriffen werden (Index ausserhalb der Reichweite ?';
                   54:S:='TCP_UNIT_FileOperation Proecdure "FirstEntrys" Auf "DebugExecForm.ListBoxProg" konnte nicht zugegriffen werden (Form nicht erzeugt ?)';
                   55:S:='TCP_UNIT_FileOperation Procedure "FirstEntrys" Auf "DebugExecForm.ListBoxParam" konnte nicht zugegriffen werden (Form nicht erzeugt ?)';
                   56:S:='UNIT TCP_WIZARD_QUERY Procedure "QueryHostWizzard"'+#13+'Aufruf von :'+#13+'DebugForm.LBHostIP.items[IndexToQuery]:=FormHostWizard.EditHostIP.Text'+#13+'konnte nicht durchgefÅhrt werden';
                   57:S:='Unit TCP_Wizard_QUERY Procedure "QueryHostWizzard"'+#13+'Aufruf von :'+#13+'DebugForm.LBHostName.items[IndexToQuery]:=FormHostWizard.EditHostname.Text'+#13+'konnte nicht durchgefÅhrt werden';
                   58:S:='Unit TCP_Wizard_Query Procedure "QueryHostWizzard"'+#13+'Aufruf von :'#13+'DebugForm.LBHostAlias.items[IndexToQuery]:=FormHostWizard.EditHostAliasName.Text'+#13+'konnte nicht durchgefÅhrt werden';
                   59:S:='Unit TCP_Qizard_Query Procedure "QueryHostWizzard"'+#13+'Aufruf von :'#13+'DebugForm.LBHostComment.items[IndextoQuery]:=FormHostWizard.EditHostComment.Text'+#13+'konnte nicht durchgefÅhrt werden';
                   60:S:='Unit TCP_Wizard_Query Procedure AddHostWizzard"'+#13+'Aufruf von '+#13+'DebugForm.lbHostIP.items.add(FormHostWizard.EditHostIP.Text)'+#13+'nicht mîglich';
                   61:S:='Unit TCP_Wizard_Query Procedure AddHostWizzard"'+#13+'Aufruf von '+#13+'DebugForm.LBHostName.items.Add(FormHostWizard.EditHostname.Text)'+#13+'konnte nicht durchgefÅhrt werden';
                   62:S:='Unit TCP_Wizard_Query Procedure AddHostWizzard"'+#13+'Aufruf von '+#13+'DebugForm.LBHostAlias.items.Add(FormHostWizard.EditHostAliasName.text)'+#13+'konnte nicht durchgefÅhrt werden';
                   63:S:='Unit TCP_Wizard_Query Procedure AddHostWizzard"'+#13+'Aufruf von '+#13+'DebugForm.LBHostComment.items.Add(FormHostWizard.EditHostComment.Text)'+#13+'konnte nicht durchgefÅhrt werden';
                   70:S:='TCP_Wizard_Query "Procedure QuerySocksServerSettings" Auf DebugForm.lbSOCKSServerIP.items[Index] konnte nicht zugegriffen werden';
                   71:S:='TCP_Wizard_Query "Procedure QuerySocksServerSettings" Auf DebugForm.lbSOCKSServerTargetIP.items[Index] konnte nicht zugegriffen werden';
                   72:S:='TCP_Wizard_Query "Procedure QuerySocksServerSettings" Auf DebugForm.lbSOCKSServerSubnet.items[Index] konnte nicht zugegriffen werden';
                   73:S:='TCP_Wizard_Query "Procedure QuerySocksServerSettings" Auf DebugForm.lbSOCKSServerSUerID.items[Index] konnte nicht zugegriffen werden';
                   74:S:='TCP_Wizard_Query "Procedure QuerySocksServerSettings" Auf DebugForm.lbSOCKSServerPassword.items[Index] konnte nicht zugegriffen werden';
                   75:S:='TCP_SOCKS_Server_Wizard "Procedure onSetupShow " Auf DebugForm.lbSOCKSServerIP.items[Index] konnte nicht zugegriffen werden';
                   76:S:='TCP_SOCKS_Server_Wizard Procedure onSetupShow " Auf DebugForm.lbSOCKSServerTargetIP.items[Index] konnte nicht zugegriffen werden';
                   77:S:='TCP_SOCKS_Server_Wizard Procedure onSetupShow " Auf DebugForm.lbSOCKSServerSubnet.items[Index] konnte nicht zugegriffen werden';
                   78:S:='TCP_SOCKS_Server_Wizard Procedure onSetupShow" Auf DebugForm.lbSOCKSServerSUerID.items[Index] konnte nicht zugegriffen werden';
                   79:S:='TCP_SOCKS_SERVER_WIZARD PROCEDURE ONSETUPSHOW "Auf DebugForm.lbPassword1.itemss[index] konnte nicht zugegriffen werden';
                   80:S:='Unit TCP_IP_Wizard4  Auf DebugForm.LBSpSettingsALLRS.items[Index] konnte nicht zugegriffen werden (Keine EintrÑge im Feld ?)';
                   90:S:='Procedure QueryALLRS Aufruf DebugForm.LBSpSettingsALLRS.items.add fehlgeschlagen';
                   91:S:='Procedure QueryARP Aufruf DebugForm.LBSpSettingsARP.items.add fehlgeschlagen';
                   92:S:='Procedure QueryICMPred Aufruf DebugForm.LBSpSettingsICMPred.items.add fehlgeschlagen';
                   93:S:='Procedure QuerySNAP Aufruf DebugForm.LBSpSettingsSNAP.items.add fehlgeschlagen';
                   94:S:='Procedure QueryBridge Aufruf DebugForm.LBSpSettingsBridge.items.add fehlgeschlagen';
                   95:S:='Procedure QueryTrailers Aufruf DebugForm.LBSpSettingsBridge.items.add fehlgeschlagen';
                   96:S:='Procedure Query802 Aufruf DebugForm.LBSpSettings802.items.add fehlgeschlagen';
                   97:S:='Procedure QueryCanonical Aufruf DebugForm.LBSpSettingsCanonical.items.add fehlgeschlagen';
                   100:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSDirectory.items.delete(Index) schlug fehl';
                   101:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSAlias.items.delete(Index) fehlgeschlagen';
                   102:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSComment.items.delete(Index) fehlgeschlagen';
                   103:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSRights.items.delete(Index) fehlgeschlagen';
                   104:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'NFSReadListArray[Index].clear fehlgeschlagen';
                   105:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'NFSReadWriteListArray[Index].clear fehlgeschîagen';
                   106:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSDirectory.items.delete(Index) fehlgeschlagen';
                   107:S:='UNIT 1 - Procedure TForm1.ButtonNFSDirectoryDeleteOnClick'+#13+'lbNFSDirectory2.items.delete(Index) fehlgeschlagen';
                   150:S:='Exception number : '+ToStr(Num);
                   151:S:='Exception number : '+ToStr(Num);
                   152:S:='Exception number : '+ToStr(Num);
                   153:S:='Exception number : '+ToStr(Num);
                   154:S:='Exception number : '+ToStr(Num);
                   155:S:='Exception number : '+ToStr(Num);
                   156:S:='Exception number : '+ToStr(Num);
                   170:S:='Exception number : '+ToStr(Num);
                   171:S:='Exception number : '+ToStr(Num);
                   172:S:='Exception number : '+ToStr(Num);
                   173:S:='Exception number : '+ToStr(Num);
                   174:S:='Exception number : '+ToStr(Num);
                   175:S:='Exception number : '+ToStr(Num);
                   176:S:='Exception number : '+ToStr(Num);
                   177:S:='Exception number : '+ToStr(Num);
                   180:S:='Exception in TCP_UNIT_FileOperation'+#13+'Procedure SaveSocks_CFG'+#13+'auf DebugForm.TestListBox.Items[loop]'+#13+'konnte nicht zugegriffen werden';
                   181:Begin
                            S:='Exception number 181 in Unit TCP_Unit_FileOperation Procedure SAVESOCKS_ENV';
                       ENd;
                   182:S:='Exception number : '+ToStr(Num);
                   183:S:='Exception number : '+ToStr(Num);
                   184:S:='Exception number : '+ToStr(Num);
                   185:S:='Exception number : '+ToStr(Num);
                   186:S:='Exception number : '+ToStr(Num);
                   187:S:='Exception number : '+ToStr(Num);
                   188:S:='Exception number : '+ToStr(Num);
                   189:S:='Exception number : '+ToStr(Num);
                   190:S:='Exception number : '+ToStr(Num);
                   191:S:='Exception number : '+ToStr(Num);
                   192:S:='Exception number : '+ToStr(Num);
                   193:S:='Exception number : '+ToStr(Num);
                   194:S:='Exception number : '+ToStr(Num);
                   195:S:='Exception number : '+ToStr(Num);
                   196:S:='Exception number : '+ToStr(Num);
                   197:S:='Exception number : '+ToStr(Num);
                   198:S:='Exception number : '+ToStr(Num);
                   199:S:='Exception number : '+ToStr(Num);
                   200:S:='Exception number : '+ToStr(Num)+' Unit : TCP_UNIT_Fileoperation Procedure SaveNFS'+#13+'DebugForm.lbNFSDirectory.items.count-1'+#13+'ist fehlgeschlagen';
                   201:S:='Exception number : '+ToStr(Num);
                   202:S:='Exception number : '+ToStr(Num);
                   203:S:='Exception number : '+ToStr(Num);
                   204:S:='Exception number : '+ToStr(Num);
                   205:S:='Exception number : '+ToStr(Num);
                   206:S:='Exception number : '+ToStr(Num);
                   207:S:='Exception number : '+ToStr(Num);
                   208:S:='Exception number : '+ToStr(Num);
                   209:S:='Exception number : '+ToStr(Num);
                   210:S:='Exception number : '+ToStr(Num);
                   211:S:='Exception number : '+ToStr(Num);
                   212:S:='Exception number : '+ToStr(Num);
                   213:S:='Exception number : '+ToStr(Num);
                   214:S:='Exception number : '+ToStr(Num);
                   215:S:='Exception number : '+ToStr(Num);
                   216:S:='Exception number : '+ToStr(Num);
                   217:S:='Exception number : '+ToStr(Num);
                   218:S:='Exception number : '+ToStr(Num);
                   219:S:='Exception number : '+ToStr(Num);
                   220:S:='Exception number : '+ToStr(Num);
                   221:S:='Exception number : '+ToStr(Num);
                   222:S:='Exception number : '+ToStr(Num);
                   223:S:='Exception number : '+ToStr(Num);
                   224:S:='Exception number : '+ToStr(Num);
                   225:S:='Exception number : '+ToStr(Num);
                   226:S:='Exception number : '+ToStr(Num);
                   227:S:='Exception number : '+ToStr(Num);
                   228:S:='Exception number : '+ToStr(Num);
                   229:S:='Exception number : '+ToStr(Num);
                   230:S:='Exception number : '+ToStr(Num);
                   231:S:='UNIT : TCP_AdvancedNotebook'+#13+'Procedure TAdvancedSettings.ButtonAliasIPAddOnClick'+#13+' auf DebugForm.LBIpSetupIPAdress[Index] konnte nicht zugegirffen werden ? Index out of range ?';
                   232:S:='TCPUtilityUnit , Function RemoveConfigSysEntry'+#13+'LongString[aCharCounter] konnte nicht zugewiesen werden (aCharCounter ausserhalb Reichweite?)';
                   233:S:='TCPUtilityUnit , Procedure Write_ConfigSys'+#13+'Write(aFile,LongString[NewLoop] konnte nicht zugewiesen werden (NewLoop ausserhalb der Reichweite ?)';
                   234:S:='TCPUtilityUnit , Procedure Write_ConfigSys'+#13+'auf LongString[NewLoop] konnte nicht zugegriffen werden';
                   235:S:='Exception Number : 235'+#13+'TCP_UNIT_FILEOPERATION Procedure SaveSockEnv'+#13+'Fehler bei case selection 2';
                   250:S:='Exception Number : 250'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG Benutzer Name Feld';
                   251:S:='Exception Number : 251'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG PASSWORT Feld';
                   252:S:='Exception Number : 252'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG Comment Feld';
                   253:S:='Exception Number : 253'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG NFSUSerID Feld';
                   254:S:='Exception Number : 254'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG NFS GroupID Feld';
                   255:S:='Exception Number : 255'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG HomeDir Feld';
                   256:S:='Exception Number : 256'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTP Feld';
                   257:S:='Exception Number : 257'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDreadDirectory Feld';
                   258:S:='Exception Number : 258'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDcanRead Feld';
                   259:S:='Exception Number : 259'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDwriteDirectory Feld';
                   260:S:='Exception Number : 260'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDcanWrite Feld';
                   261:S:='Exception Number : 261'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDLog Feld';
                   262:S:='Exception Number : 262'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesFTPDTimeout Feld';
                   263:S:='Exception Number : 263'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesTelnet Feld';
                   264:S:='Exception Number : 264'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesREXec Feld';
                   265:S:='Exception Number : 265'+#13+'TCP_Unit_FILEOPERATION Procedure SAVEServices'+#13+'Fehler bei Zugriff auf DEBUG lbServicesNFS Feld';
                   267:S:='Exception Number : 267'+#13+'TCP_Unit1 Procedure COPYLPR';
                   268:S:='Exception Number : 268'+#13+'TCP_Unit1 Procedure Startup'+#13+'Konnte den Namen der NLS Datei nicht im Stringlist Array finden';
                   300:S:='Eine Form konnte nicht gelîscht werden';
                   400:S:='Exception Number : 400'+#13+'TCP_OPTIONS Procedure OKButtonOnCLick'+#13+'Zugriff auf lbLanguageHelp.items[x] verweigert !';
                   End;
                   FormException.Create(NIL);
                   FormException.labelExceptionMessage.Caption:=S;
                   FormException.showModal;
                   Halt;
              End;


Initialization
RegisterClasses ([TFormException, TImage, TBitBtn, TLabel]);
End.
