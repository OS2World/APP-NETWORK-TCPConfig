
/* *************************************************************************
   * Unit             : GetDrvs2                                           *
   * Ersteller/Author : Maik Jaeger                                        *
   * Datum/Date       : 01.01.1998                                         *
   * --------------------------------------------------------------------- *
   * Diese Unit ist Public Domain. / This Unit is Public Domain.           *
   * --------------------------------------------------------------------- *
   * I added english Comments more than two years after coding this Unit.  *
   * These comments may be shorter and sometimes less accurate than the    *
   * original - german - Comments.                                         *
   * --------------------------------------------------------------------- *
   * (D) Beschreibung: (English Translation - see below)                   *
   * -----------------                                                     *
   *   Beim Start wird eine Auflistung aller vorhandenen Laufwerke er-     *
   *   stellt und in dem oeffentlichen Array garDrives abgelegt (siehe     *
   *   Initialisierungsteil der Unit; Aufruf der Prozedur uGetDriveMap()). *
   *   Das Array besteht aus gciMinDriveNo..gciMaxDriveNo trDriveData-Re-  *
   *   cords (Aufbau siehe Deklaration weiter unten) und bietet die fol-   *
   *   genden Informationen:                                               *
   *        - Laufwerk vorhanden Ja/Nein                                   *
   *        - Typ des Laufwerks                                            *
   *        - Laufwerksbuchstabe                                           *
   *        - Angaben zum Medium                                           *
   *        - Angaben zu Bezeichner, Typ und Gueltigkeit des Dateisystems  *
   *        - ggf. weitere Angaben des jeweiligen Treibers                 *
   *                                                                       *
   *   Funktionsweise                                                      *
   *   --------------                                                      *
   *     Zur Ermittlung der Informationen werden Aufrufe von IOCtl-Funk-   *
   *     tionen, DosOpen() und einige (undokumentierte) Features des CD-   *
   *     Rom-Treibers verwendet:                                           *
   *       1) DosDevIOCTL()    Kategorie: IOCTL_DISK                       *
   *                           Funktion:  DSK_GETDEVICEPARAMS              *
   *                           Liefert Informationen darueber, ob das Lauf-*
   *                           werke vorhanden ist und ob das Medium ge-   *
   *                           wechselt werden kann                        *
   *       2) DosOpen() und                                                *
   *          DosDevIOCTL()    Kategorie: IOCTL_DISK                       *
   *                           Funktion:  DSK_GETLOCKSTATUS                *
   *                           Laufwerk vorhanden und Medium eingelegt ?   *
   *                                                                       *
   *       3) DosQueryFSAttach()                                           *
   *                           Bezeichner und Typ des Dateisystems.        *
   *                           Dateisystem gueltig ?                       *
   *                           Netzwerklaufwerk (Remote) ?                 *
   *                                                                       *
   *     Sonderf‰lle:                                                      *
   *       A) Floppy ?                                                     *
   *          DosDevConfig()   Liefert Anzahl der Diskettenlaufwerke       *
   *                           (-> siehe fIsFloppy())                      *
   *       B) CD-Rom ?                                                     *
   *          DosOpen() und                                                *
   *          DosDevIOCTL()    Kategorie: $82         (undokumentiert)     *
   *                           Funktion:  $60         (undokumentiert)     *
   *                           Anzahl der CD-Roms im System  und erster    *
   *                           vergebener Laufwerksbuchstabe               *
   *       C) RAM-Disk ?                                                   *
   *                           Die Pruefungen 1)..3) ergaben als Ergebnis, *
   *                           dass es sich um eine lokale Festplatte han- *
   *                           delt - aber 1) lieferte als Laufwerkstyp    *
   *                           7 (=Other Drive) statt 5 (=Harddisk)        *
   *                                                                       *
   *   oeffentliche Typen                                                  *
   *   ------------------                                                  *
   *     teDriveType            Aufzaehlung: Typ des Laufwerks             *
   *     teDeviceAttr           Aufzaehlung: Treiber-Attribute             *
   *     trDriveData            Record: Grunddaten des Laufwerks           *
   *     prDriveData            Zeiger auf trDriveData                     *
   *     trDriveInfoData        Record: gesammelte Informationen zum Lauf- *
   *                                    werk (enthaelt auch trDriveData)   *
   *     prDriveInfoData        Zeiger auf trDriveInfoData                 *
   *                                                                       *
   *   oeffentliche Konstanten                                             *
   *   -----------------------                                             *
   *     gciMinDriveNo          kleinste Laufwerksnummer (=> A:)           *
   *     gciMaxDriveNo          groesste Laufwerksnummer (=> Z:)           *
   *                                                                       *
   *   oeffentliche Funktionen/Prozeduren                                  *
   *   ----------------------------------                                  *
   *     Procedure uGetDriveMap()       Liste der Laufwerke in garDrives   *
   *                                    erstellen                          *    
   *     Function fGetDriveInfoData()   Informationen zum angegebenen Lauf-*
   *                                    werk ermitteln                     *
   * --------------------------------------------------------------------- *
   * (E) Description                                                       *
   * ---------------                                                       *
   *   This Unit build a map of present Drives on startup (see call to the *
   *   Procedure uGetDriveMap() in Initialization part of the Unit at end  *
   *   of this file). All Data ar stored in the public Array garDrives.    *
   *   This Array contain gciMinDriveNo..gciMaxDriveNo trDriveData-Records *
   *   (for Details see Declaration below) with the following Informations:*
   *        - Drive present Yes/No                                         *
   *        - Type of Drive                                                *
   *        - Drive Letter                                                 *
   *        - Informations about the Medium                                *
   *        - Identifier, Type and Status of the Filesystem                *
   *        - eventual additional Informations provides by the Driver      *
   *                                                                       *
   *   How                                                                 *
   *   ---                                                                 *
   *     The Informations are revealed by calls to OS/2's IOCtl-Functions, *
   *     DosOpen() and some (undocumented) Features of OS2CDROM.DMD:       *
   *       1) DosDevIOCTL()    Category:  IOCTL_DISK                       *
   *                           Function:  DSK_GETDEVICEPARAMS              *
   *                           Drive present; Medium fixed ?               *
   *       2) DosOpen() and                                                *
   *          DosDevIOCTL()    Category:  IOCTL_DISK                       *
   *                           Function:  DSK_GETLOCKSTATUS                *
   *                           Drive present and Medium present ?          *
   *                                                                       *
   *       3) DosQueryFSAttach()                                           *
   *                           Identifier and Type of Filesystem.          *
   *                           Filesystem valid ?                          *
   *                           Remote Drive ?                              *
   *                                                                       *
   *     Special cases:                                                    *
   *       A) Floppy ?                                                     *
   *          DosDevConfig()   Delivers number of Discette Drives          *
   *                           (-> see fIsFloppy())                        *
   *       B) CD-Rom ?                                                     *
   *          DosOpen() and                                                *
   *          DosDevIOCTL()    Kategorie: $82         (undocumented)       *
   *                           Funktion:  $60         (undocimented)       *
   *                           Delivers Number of CD-Roms in System and    *
   *                           first used Drive-Letter                     *
   *       C) RAM-Disk ?                                                   *
   *                           Steps 1)..3) revealing a local fixed Disk.  *
   *                           But the first call to DosDevIOCTL() return  *
   *                           Drivetype =7 (=Other Drive) instead of      *
   *                           Drivetype =5 (=Harddisk).                   *
   *                                                                       *
   *   public Types                                                        *
   *   ------------                                                        *
   *     teDriveType            Enumeration: Drive-Types                   *
   *     teDeviceAttr           Enumeration: Driver-Attributes             *
   *     trDriveData            Record: Basicdata of Drive                 *
   *     prDriveData            Pointer to trDriveData                     *
   *     trDriveInfoData        Record: complete Informations about a Drive*
   *                                    (contain trDriveData)              *
   *     prDriveInfoData        Pointer to trDriveInfoData                 *
   *                                                                       *
   *   public Constants                                                    *
   *   ----------------                                                    *
   *     gciMinDriveNo          lowest Drivenumber (=> A:)                 *
   *     gciMaxDriveNo          highest Drivenumber (=> Z:)                *
   *                                                                       *
   *   public Functions/Procedures                                         *
   *   ---------------------------                                         *
   *     Procedure uGetDriveMap()       Builds a map of Drives in garDrives*
   *     Function fGetDriveInfoData()   Informationen about a given Drive  *
   * --------------------------------------------------------------------- *
   * History:                                                              *
   *   Version    Date      Author          Description                    *
   *   ------------------------------------------------------------------- *
   *   1.00.01  01.01.1998  M.J.            Erstellung                     *
   *   1.00.02  02.01.1998  M.J.            RamDisk erkennen               *
   *   1.00.03  12.04.1998  M.J.            trDriveInfoData in einer Klas- *
   *                                        se (tobjDriveInfoData) gekaps. *
   *   1.00.04  20.04.2000  M.J.            tobjDriveInfoData entfernt     *
   *                                        englische Kommentare erg‰nzt   *
   *                                                                       *
   *   1.00.05  20.10.2006 R.B.             Korrekte Erkennung von Remote  *
   *                                        Laufwerken des Types 04        *
   *   CDROM Laufwerke melden sich auch als TYP 04 an                      *
   ************************************************************************* */

/* Erkennung einer RamDisk:
     Wird nach Durchlaufen aller Pruefungen auf HDD erkannt, erfolgt zu-
     saetzlich noch eine Abfrage des Laufwerkstyps, wie er durch die IOCtl-
     Funktion zur Ermittlung der Device-Parameter geliefert wurde. Taucht
     hier eine 7 (Other Drive) statt einer 5 (fixed Disk) auf, wird auf
     RamDisk (statt HDD) erkannt.
     Dies ist evtl. nicht ganz sauber, bleibt aber bis auf weiteres...
    Hinweis 1: Ein DVD/CD Brenner mit eingeleger BESCHREIBBARER DISC (DVD RAM/CDRW/DVD-RW/+RW) wird als RAMDISK erkannt
    Hinweis 2: EIn DVD/CD Brenner OHNE eingelegen WIEDERBESCHREIBAREN MEDIUM wird als CDROM erkannt.
               Dies gilt auch fÅr alle EINMAL Beschreibbaren Medien (DVD-R/+R sowie CD-R)

*/

Unit GETDRVS2;

Interface
Uses Dos,Dialogs;

// =========================================================================
// oeffentliche Konstanten / public Constants
// =========================================================================
Const gciMinDriveNo = 1;               // kleinste Laufwerksnummer (='A:')
                                       // lowest Drivenumber
      gciMaxDriveNo = 26;              // groesste Laufwerksnummer (='Z:')
                                       // highest Drivenumber

// =========================================================================
// oeffentliche Typdeklarationen / public Types
// =========================================================================
                                       /************************************
                                        * Mengentyp fuer Laufwerkstyp
                                        * Enumeration of Drivetypes
                                        ************************************/
Type teDriveType = (noDrive,           // kein Laufwerk vorhanden
                                       // no Drive present

                    noAccess,          // Laufwerk vorhanden aber kein Zugriff maeglich
                                       // Drive present but not accessible

                    disconnected,      // Treiber fuer Laufwerk vorhanden aber Laufwerk nicht gefunden
                                       // Driver (for Drive) is present bu Drive itself not found
                                       
                    Floppy,            // Diskettenlaufwerk
                                       // Floppy-Drive
                                       
                    Harddisk,          // lokale Festplatte
                                       // local Harddisk
                                       
                    RamDisk,           // lokale RamDisk
                                       // local Ram-Disk
                                       
                    Subst,             // substituiertes Laufwerk
                                       // substituted Drive
                                       
                    Remote,            // Netzlaufwerk
                                       // Remote Drive
                                       
                    Removable,         // Laufwerk mit Wechselmedium
                                       // Drive with removable Medium
                                       
                    CDRom,             // CD-Rom Laufwerk
                                       // CD-Rom Drive
                                       
                    MODrive,           // MO Laufwerk
                                       // MO Drive
                                       
                    TapeDrive,         // Bandlaufwerk
                                       // Tape Drive
                                       
                    Failure);          // Daten konnten nicht ermittelt werden
                                       // Data not available (could not be retrieved)

                                       /************************************
                                        * Aufzaehlungstyp fuer Treiber Attribute
                                        * Enumeration of Driver Attributes
                                        ************************************/
Type teDeviceAttr = (fixed,            // fixes Medium (kein Wechselmedium)
                                       // fixed Medium (Medium not removable)
                                       
                     changeLine,       // Treiber ist ueber Medienwechsel informiert
                                       // Driver is informed about removed Medium
                                       
                     greater16MB);     // Treiber unterstuetzt Datentransfer in Bereich oberhalb 16MB
                                       // Driver is able to transfer Data beyond 16MB

                                       /************************************
                                        * Daten-Record fuer Liste der Laufwerke
                                        * Record for Basicdata of Drives
                                        ************************************/
Type prDriveData = ^trDriveData;
     trDriveData = Record
                     iDriveNo     : Integer;        // Nummer des Laufwerks
                                                    // Number of Drive
                                                    
                     cDriveLetter : Char;           // Laufwerksbuchstabe
                                                    // Drive Letter
                                                    
                     fDriveValid  : Boolean;        // Flag: Laufwerk vorhanden
                                                    // Flag: Drive present
                                                    
                     eDriveType   : teDriveType;    // Laufwerkstyp
                                                    // Type of Drive
                     Filesystem    : String;
                   End;

                                       /************************************
                                        * Info-Record fuer ein Laufwerk
                                        * Info-Record for one Drive
                                        ************************************/
Type prDriveInfoData = ^trDriveInfoData;
     trDriveInfoData = Record
                         rDriveData    : trDriveData; // siehe oben
                                                      // see above
                                                      
                         fRemovable    : Boolean;     // Flag: Medium ist entnehmbar
                                                      // Flag: Medium is removable
                                                      
                         fMediaPresent : Boolean;     // Flag: Medium ist vorhanden
                                                      // Flag: Medium is present
                                                      
                         fFSDataValid  : Boolean;     // Flag: Filesystemdaten sind gueltig
                                                      // Flag: Filesystemdata are valid
                                                      
                         iFSType       : Word;        // Typ des Filesystems:
                                                      // Type of Filesystem:
                                                      //   1   FSAT_CHARDEV    Resident Char. Device
                                                      //   2   FSAT_PSEUDODEV  Pseudocharacter Device
                                                      //   3   FSAT_LOCALDRIVE lokales Laufwerk / local Drive
                                                      //   4   FSAT_REMOTEDRV  Netzlaufwerk / remote Drive
                         szFSItem      : CSTRING;     // Item Name (Einheitenbezeichner; z.B. 'A:', 'B:' etc.)
                                                      // Item Name (Drive Letter)

                         szFSDName     : CSTRING;     // Name des Filesystem Device (z.B. 'FAT', 'HPFS', 'CDFS' etc.)
                                                      // Name of Filesystem ('FAT', 'HPFS' etc.)
                                                      
                         wFSDataLength : Word;        // Anzahl Bytes der zusaetzlich vom Filesystem Device gelieferten Daten
                                                      // Number of Bytes for additional Data delivered by the Filesystem-Driver
                                                      
                         szFSAData     : CSTRING;     // zusaetzlich vom Filesystem Device gelieferte Daten
                                                      // additional Data delivered by Filesystem-Driver

                         Case Boolean Of              // Attribute des Einheiten-Treibers
                                                      // Attributes of Unit-Driver (see above)
                           False : (wDevAttr: word);
                           True  : (setDevAttr: Set Of teDeviceAttr);

                       End;


// =========================================================================
// oeffentliche Variablen / public Variables
// =========================================================================
                                       /************************************
                                        * Auflistung vorhandener Laufwerke
                                        * Map of Drives
                                        ************************************/
Var garDrives : Array[gciMinDriveNo..gciMaxDriveNo] Of trDriveData;
VAR MyType:Array[1..26] of Byte;

// =========================================================================
// oeffentliche Funktionen & Prozeduren / public Functions & Procedures
// =========================================================================
                                       /************************************
                                        * Liste der Laufwerke erstellen
                                        *
                                        * Build map of Drives
                                        ************************************/
Procedure uGetDriveMap;

                                       /************************************
                                        * Informationen zu einem Laufwerk
                                        *
                                        * Retrievs Informations about one
                                        * given Drive
                                        ************************************/
Function fGetDriveInfoData(iDriveNo: Integer;
                           Var rDriveInfoData: trDriveInfoData): Boolean;


// #########################################################################
// Implementierung
// #########################################################################
Implementation
Uses OS2Def, BseDev, BseDos, BseErr;

// =========================================================================
// private Konstanten
// =========================================================================

Const DSK_GETLOCKSTATUS = $66;         // fehlende Konstante fuer IOCtl-Funktionscode
                                       // missing IOCtl-Functioncode

Const ciMediaPresent = 4;              // Bitcode fuer vorhandenes Medium (IOCtl-Funktion
                                       // zur Abfrage des LockStatus eines Laufwerks
                                       
                                       // Bitcode for present Medium (IOCtl-Function
                                       // for LockState-Query)

                                       // Code fuer Devicetype-Angaben der IOCtl-Funktion
                                       // zur Ermittlung der Device-Parameter
                                       
                                       // Codes for Devicetype-Information (IOCtl-Function
                                       // for Device-Parameter Query)

Const ciDevTypeFixedDisk = 5;          // Fixed Disk
      ciDevTypeTape = 6;               // Tapedrive
      ciDevTypeOther = 7;              // Other
      ciDevTypeMO = 8;                 // MO-Drive

// =========================================================================
// private Typdeklarationen / private Types
// =========================================================================
                                       /************************************
                                        * Zugriffstypen
                                        * Accesstypes
                                        ************************************/
Type tWord = Record                    // Bytes of a Word
               LoByte, HiByte : Byte;
             End;

Type tLongWord = Record                // Words and Bytes of a Longword
                   Case Boolean Of
                     False : (LoWord, HiWord : Word);
                     True  : (LoBytes, HiBytes : tWord);
                 End;
                                       /************************************
                                        * Ergebnis-Record fuer IOCtl-Funktion
                                        * zur Ermittlung der Device Parameter
                                        * (siehe IOCtl Kat. 08h, Fkt. 63h)
                                        *
                                        * Result-Record for IOCtl-Function for
                                        * Query of Device-Parameters
                                        ************************************/
Type tabBPB = Array[0..30] Of Byte;    // Puffer fuer BPB-Struktur
                                       // Buffer for BPB-Structure

Type prDeviceParams = ^trDeviceParams;
     trDeviceParams = Record
                        BPB         : tabBPB;  // BPB Struktur
                                               // BPB Structure
                                               
                        wCylinders  : Word;    // Anzahl Zylinder
                                               // Number of Cylinders
                                               
                        bDeviceType : Byte;    // Treibertyp
                                               // Drivertype
                                               
                        Case Boolean Of        // Treiberattribute
                                               // Driver-Attributes
                          False: (wAttr   : Word);
                          True : (setAttr : Set Of teDeviceAttr);
                      End;


Function TestLanDrive(Drive:Char):Boolean;
Const FileSystemInfoBufferSize = SizeOf(FSQBuffer2) + (3 * CCHMAXPATH) + 256;

VAR
   Data            : PChar;
   pBuffer            : Pointer;
   lDataLengthInOut  :ULONG;
   ReturnCOde        : ULONG;
   szDeviceName       : CSTRING[2]; // A: oder B:
   ItemName           : CString;
   FileSystemName     : STRING;
   FSDAta             : CString;
   Remote             : Boolean;
   IType              : Longint;

{
Testet ob das angegebene Laufwerk ein LAN Laufwerk ist , indem auf das FSAT_REMOTEDRV abgefragt wird.
Es erfolgt danach eine Abfrage auf das Dateisystem "LAN"
RÅckwerte :
          TRUE = Angegebenes Laufwerk ist ein LAN laufwerk
          FALSE = Angegebenes Laufwerk ist KEIN LAN Laufwerk

}

Begin
                   GetMem(pBuffer, FileSystemInfoBufferSize);
                    SZDeviceName:=Drive+':';
                    Try
                      FillChar(pBuffer^, FileSystemInfoBufferSize, 0);
                      lDataLengthInOut := Pred(FilesystemInfoBufferSize);

                      ReturnCode := DosQueryFSAttach(szDeviceName,         // Device Name
                                                                     // Device Name
                                                                     
                                               0,                    // immer 0 fuer FSAIL_QUERYNAME
                                                                     // always 0 for FSAIL_QUERYNAME
                                                                     
                                               FSAIL_QUERYNAME {1},  // Modus: Treibernamen abfragen
                                                                     // Mode: ask for drivername
                                                                     
                                               PFSQBUFFER2(pBuffer)^,// Pufferbereich fuer gelieferte Daten
                                                                     // Buffer for returned Data
                                                                     
                                               lDataLengthInOut);   // max. Groesse des Pufferbereichs bzw.
                                                                     // tats. gelieferte Anzahl Bytes
                                                                     // size of Buffer and really returned
                                                                     // number of Bytes


                      If (ReturnCode = NO_ERROR) Then
                        Begin
                                       // Item Name
                          ItemName := CSTRING(PFSQBUFFER2(pBuffer)^.szName);
                                       // Driver Name
                          Data := PChar(@PFSQBUFFER2(pBuffer)^.szName);
                          Inc(Data, Succ(PFSQBUFFER2(pBuffer)^.cbName));
                          FILESystemName := CSTRING(Data^);
                                      // Driver Data
                          Inc(Data, Succ(PFSQBUFFER2(pBuffer)^.cbFSDName));
                          //rDriveInfoData.wFSDataLength := PFSQBUFFER2(pBuffer)^.cbFSAData;
                          FSData := CSTRING(Data^);

                          //rDriveInfoData.fFSDataValid := True;

                                       /************************************
                                        * Remote Drive ?
                                        ************************************/
                          If (PFSQBUFFER2(pBuffer)^.iType = FSAT_REMOTEDRV) then Remote:=TRUE else Remote:=FALSE;
                          IType:=PFSQBUFFER2(pBuffer)^.iType;
                          MyType[ord(Drive)-64]:=IType;
                        End; (* If (ulRC = NO_ERROR)    Ende: DosQueryFSAttach() war erfolgreich *)
                        Finally
                      FreeMem(pBuffer, FileSystemInfoBufferSize);  // Pufferspeicher wieder freigeben
                    End;
                    IF IType=4 Then
                    Begin
                        Result:=True;
                        { IF Copy(FileSystemName,1,3)='LAN' Then Result:=TRUE else RESULT:=FALSE;
                         IF Copy(FileSystemName,1,4)='VPCMAP' Then Result:=}
                    End else Result:=FALSE;
End;

// -------------------------------------------------------------------------
// Funktion/Function: fIsFloppy()
//
// Beschreibung:
//   Feststellen, ob das per Nr. angegebene Laufwerk ein Diskettenlaufwerk ist
//
// Description:
//   Is given Drive a Floppy ?
//
//
// Parameter:
//   iDriveNo         Integer          Nummer des zu analysierenden Laufwerks
//                                     Number of Drive
//                                     (1=A:, 2=B:, 3=C: etc.)
//
// Rueckgabe/Returnvalue:  Boolean
//              True                   Laufwerk ist Diskettenlaufwerk (=Floppy)
//                                     Drive is a Floppy
//              False                  Laufwerk ist kein Diskettenlaufwerk
//                                     Drive is not a Floppy
// -------------------------------------------------------------------------
Function fIsFloppy(iDriveNo: Integer): Boolean;
Var bResult : Byte;          // Puffer fuer Ergebnis von DosDevConfig()
                             // Buffer for Result of DosDevConfig()

Begin (* fIsFloppy() *)
  DosDevConfig(bResult, DEVINFO_FLOPPY);  // Anzahl Diskettenlaufwerke ermitteln
                                          // Number of Floppy-Drives
                                          
  fIsFloppy := (Abs(iDriveNo) <= bResult);  // Floppy, wenn Laufwerksnummer <= Anzahl Floppies
                                            // Floppy, if Drivenumber <= Number of Floppy-Drives
End; (* IsFloppy *)


// -------------------------------------------------------------------------
// Funktion/Function: uQueryCDRom()
//
// Beschreibung:
//   Die Funktion QueryCDRom ermittelt ueber eine nicht dokumentierte
//   Schnittstelle die Anzahl der CDRom-Laufwerke und den ersten, fuer
//   ein CDRom-Laufwerk, vergebenen UnitIdentifier.
//   Der Treiber OS2CDROM.DMD stellt dem System zwei Devices (CD-ROM1$
//   und CD-ROM2$) zur Verfuegung. Die beiden Devices unterscheiden sich
//   durch DeviceAttribute. Beide Devices unterstuetzen (zumindest unter
//   Warp) den undokumentierten Generic IOCtl 0x82/0x60, welcher Infor-
//   mationen ueber die angeschlossenen CDRom-Laufwerke liefert.
//
// Description:
//   This Functions finds out how many CD-Rom Drives are present in System
//   and which Drive Letter is the first occupied by a CD-Rom. It uses an
//   undocumented Interface to OS2CDROM.DMD.
//   OS2CDROM.DMD presents two Devices (CD-ROM1$ and CD-ROM2$). These De-
//   vices are distinguished by their Device-Attributes. Both Devices sup-
//   port (under Warp) the undocumented generic IOCtl-Call 0x82/0x60 which
//   deliver some Information about the connected CD-Rom Drives.
//
// Parameter:
//   Var ulCDRomCount        ULONG     Anzahl CD-Rom Laufwerke im System
//                                     Number of CD-Rom Drives in System
//
//   Var ulFirstCDRomDiskNo  ULONG     erste Laufwerksnummer, die an ein
//                                     CD-Rom vergeben ist
//                                     first Drive-Letter occupied by a
//                                     CD-Rom Drive
//
// Rueckgabe/Returnvalue:  keine/none
// -------------------------------------------------------------------------
Procedure uQueryCDRom(Var ulCDRomCount, ulFirstCDRomDiskNo: ULONG);
 
Const cszDriverName : CSTRING = 'CD-ROM?$';
 
Var cCurDriver : Char;                    // Indexvariable fuer aktuell bearbeites Device (1 oder 2)
                                          // Index for current Device (1 or 2)

    hDevHandle : HFILE;                   // Handle fuer Device
                                          // Device handle

    ulAction   : ULONG;                   // Aktionscode (DosOpen())
                                          // Actioncode (DosOpen())
                                          
    ulParams   : ULONG;                   // Anzahl Bytes von IOCtl gelieferter Parameterdaten
                                          // Number of Bytes for delivered Parameterdata
                                          
    ulData     : ULONG;                   // Anzahl Bytes von IOCtl gelieferter Daten
                                          // Number of Bytes delivered by IOCtl
                                          
    rCDInfo    : Record                   // Ergebnisstruktur der IOCtl-Funktion (s.o.)
                                          // Record for Results of IOCtl-Call (see above)
                   usCDRomCount : USHORT; // Anzahl CD-Roms                   / Number of CD-Rom Drives
                   usFirstUnitNo: USHORT; // erste vergebene Laufwerksnummer  / first Driver Letter
                 End;

Begin (* uQueryCDRom *)
                                       /************************************
                                        * Vorbelegungen
                                        *
                                        * initial assignments
                                        ************************************/
  ulCDRomCount := 0;
  ulFirstCDRomDiskNo := 0;

  ulParams := 0;

                                       /************************************
                                        * die beiden Devices abarbeiten
                                        *
                                        * accessing both Devices
                                        ************************************/
  For cCurDriver := '1' To '2' Do
    Begin
                                       /************************************
                                        * Device oeffnen
                                        *
                                        * open Device
                                        ************************************/
      cszDriverName[6] := cCurDriver;
      If (DosOpen(cszDriverName,              // Devicename
                  hDevHandle,                 // Handle
                  ulAction,                   // Aktionscode
                  0,                          // Dateigrî·e
                  FILE_NORMAL,                // Attribute: read/write
                  OPEN_ACTION_OPEN_IF_EXISTS, // OpenFlag: îffnen, wenn vorhanden
                  OPEN_FLAGS_FAIL_ON_ERROR Or // Modus: Fehlermeldung per Returncode
                    OPEN_SHARE_DENYNONE Or    //        keine EinschrÑnkungen fÅr Dritte
                    OPEN_ACCESS_READONLY,     //        nur lesender Zugriff
                  NIL)=NO_ERROR) Then         // keine EA
        Begin
                                       /************************************
                                        * IOCtl-Funktion aufrufen
                                        *
                                        * Call to IOCtl
                                        ************************************/
          If (DosDevIOCtl(hDevHandle,             // Handle                 / Handle
                          $82,                    // Kategorie              / Category
                          $60,                    // Funktion               / Function
                          NIL,                    // keine Parameterliste   / No Parameterlist
                          0,                      // Laenge Parameterliste  / Length of Parameterlist
                          ulParams,               // Groesse der gelieferten Parameterdaten
                                                  //                        / Number of Bytes for Parameterdata
                          rCDInfo,                // Puffer fuer gelieferte Daten
                                                  //                        / Buffer for returned Data
                          SizeOf(rCDInfo),        // Groesse des Datenpuffers
                                                  //                        / Size of Databuffer
                          ulData)=NO_ERROR) Then  // Groesse der gelieferten Daten
                                                  //                        / Number of Bytes for returned Data
            Begin
              ulCDRomCount := rCDInfo.usCDRomCount;
              ulFirstCDRomDiskNo := Succ(rCDInfo.usFirstUnitNo);
            End;

          DosClose(hDevHandle);
        End;

   End; (* For *)

End; (* uQueryCDRom *)


// -------------------------------------------------------------------------
// Funktion/Function: fGetDriveInfoData()
//
// Beschreibung:
//   Zum dem per Nr. angegebenen Laufwerk zusaetzliche Informationen ermitteln.
//   Die Daten zum Filesystem werden fuer Laufwerke mit Wechselmedien nur er-
//   mittelt, wenn ein Medium vorhanden ist. Dies ist zwar idR nicht notwendig,
//   da i.a. bei fehlendem Medium die Daten des phys. Geraets geliefert werden.
//   Aber einige Geraete halten sich leider nicht an diese Konvention und pro-
//   vozieren so Systemrequester (siehe auch Kommentar im Quelltext).
//
// Description:
//   Querying Data for given Drive.
//   For Drives with removeable Medium the Informations about the Filesystem
//   will only be queried if the Medium is present. Normally this is not ne-
//   cessary because the Drivers returning Data about the physical Device if
//   the Medium is not available. But some Drivers do not follow this 
//   convention and provoke a Systemrequester - i.e. "Drive not present" (see 
//   Comments below).
//   
//
// Parameter:
//   iDriveNo             Integer          Nummer des zu analysierenden Laufwerks
//                                         (1=A:, 2=B:, 3=C: etc.)
//                                         Number for Drive
//
//   Var rDriveInfoData   trDriveInfoData  Puffer fuer die ermittelten Daten
//                                         Buffer for Results
//
// Rueckgabe/Returnvalue:  Boolean
//              True                   Informationen konnten ermittelt werden
//                                     Informations available and valid
//              False                  Fehler aufgetreten
//                                     an error occured
// -------------------------------------------------------------------------
Function fGetDriveInfoData(iDriveNo: Integer;
                           Var rDriveInfoData: trDriveInfoData): Boolean;

/* Ausreichend Platz fuer die von DosQueryFSAttach() gelieferte Ergebnis-
   Struktur und die evtl. zusaetzlich gelieferten Informationen (zwei Be-
   zeichner sowie zusaetzliche Daten des Treibers). IdR wird weniger Puf-
   ferplatz benoetigt werden... 
   
   Reserving enough space for Results of DosQueryFSAttach() (two Iden-
   tifiers and eventually additonal Data from the Driver). Normally we
   use less memory... 
*/
Const ciFSInfoBufferSize = SizeOf(FSQBuffer2) + (3 * CCHMAXPATH) + 256;

Var fResult            : Boolean;                // Funktionsergebnis
                                                 // Returnvalue

    wIOCtlParam        : Word;                   // Parameter fuer IOCtl-Funktion zur Ermittlung der Device Parameter
                                                 // Parameter for IOCtl-Function (Query Device-Parameter)

    ulRC               : ULONG;                  // Puffer fuer Funktionsergebnisse
                                                 // Returncode
                                                 
    ulParmLengthInOut  :ULONG;                   // Puffer fuer Laenge der von DosDevIOCTL() gelieferten Parameter
                                                 // Number of Bytes in Parameterdata for DoDevIOCTL()
                                                 
    ulDataLengthInOut  :ULONG;                   // Puffer fuer Laenge der von DosDevIOCTL() gelieferten Daten
                                                 // Number of Bytes in Data for DoDevIOCTL()
                                                 
    ulAction           : ULONG;                  // von DosOpen() zurueckgelieferter Aktionscode
                                                 // Actioncode delivered by DosOpen()
                                                 
    ulCDRomCount       : ULONG;                  // Anzahl CD-Rom Laufwerke im System
                                                 // Numbr of CD-Rom Drives
                                                 
    ulFirstCDRomDiskNo : ULONG;                  // 1. Laufwerksnummer fuer CD-ROM
                                                 // first used Drive Letter

    hDevHandle         : HFILE;                  // Handle fuer Device
                                                 // Device Handle

    szDeviceName       : CSTRING[2];             // Device Name ('A:', 'B:' etc.)

    pBuffer            : Pointer;                // Zeiger auf einen Pufferbereich
                                                 // Pointer to Buffer
    pszData            : PChar;                  // Zeiger auf einen nullterminierten String
                                                 // Pointer to a C-String (terminated by #0)

    rDeviceParams      : trDeviceParams;         // Puffer fuer Device Parameter
                                                 // Buffer for Device-Parameters
                                                 
    rLockStatusParams  : Record                  // Parameter-Record fuer IOCtl-Funktion zur Ermittlung des LockStatus
                                                 // Parameter-Record for Query of Lock State
                           bCmdInfo  : Byte;     // Command Info (0)
                           wDriveUnit: Word;     // Laufwerksnummer / Drive Number
                         End;
    rLockStatusData    : Record                  // Daten-Record fuer IOCtl-Funktion zur Ermittlung des LockStatus
                                                 // Data-Record for Query of Lock Status
                           wLockStatus : ULONG;  // Lock-Status (Bit 2 -> Medium vorhanden Ja/Nein)
                                                 // Lock-Status (Bit 2 -> Medium present Yes/No)
                         End;

  S:String;
  TXFSBPB_REMOVABLE  : integer=08;
Begin (* fGetDriveInfoData() *)

                                       /************************************
                                        * Vorbelegungen
                                        *
                                        * initial assignments
                                        ************************************/
  fResult := False;

  Try
                                       /************************************
                                        * Ergebnisrecord ruecksetzen
                                        *
                                        * reseting Resultrecord
                                        ************************************/
    FillChar(rDriveInfoData, SizeOf(rDriveInfoData), 0);

    With rDriveInfoData.rDriveData Do Begin
      iDriveNo := iDriveNo;
      cDriveLetter := Chr(Ord('A') + Pred(iDriveNo));
      fDriveValid := False;
      eDriveType := noDrive;
    End;

    rDriveInfoData.fFSDataValid := False;

                                       /************************************
                                        * Informationen zusammensuchen
                                        *
                                        * collection informations...
                                        ************************************/
                                       /************************************
                                        * Device-Parameter ermitteln
                                        *
                                        * Device-Parameter
                                        ************************************/
    tWord(wIOCtlParam).LoByte := 0;               // BPB des phys. Device   / BPB of physical Device
    tWord(wIOCtlParam).HiByte := Pred(iDriveNo);  // Nr. des Laufwerks      / Number of Drive
                                                  // (beginnend bei 0!)     / (starts with 0!)
    ulParmLengthInOut := SizeOf(wIOCtlParam);     // Initialisierung fuer Anzahl zurueckgegebener Parameterbytes
    ulDataLengthInOut := 0;                       // keine Daten an Funktion geliefert
                                                  //                        / No Data delivered to the function

    ulRC := DosDevIOCTL (HFILE(-1),               // Device oeffnen         / Open Device (not a file)
                         IOCTL_DISK,              // IOCtl Kategorie        / Category
                         DSK_GETDEVICEPARAMS,     // IOCtl Funktion         / Function
                         wIOCtlParam,             // Parameterblock         / Parameterblock
                         SizeOf(wIOCtlParam),     // max. Laenge zuruecklgelieferte Parameterinformationen
                                                  //                        / maximum Length for returned Parameter-Informations
                         ulParmLengthInOut,       // tats. gelieferte Anzahl Byte Parameterinformationen
                                                  //                        / really returned Bytes of Parameter-Info
                         rDeviceParams,           // Puffer fuer gelieferte Device-Parameter
                                                  //                        / Buffer for Device-Parameters
                         SizeOf(rDeviceParams),   // max. zur Verfuegung stehender Platz fuer Daten
                                                  //                        / maximum Length for returned Data
                         ulDataLengthInOut);      // tats. Anzahl Bytes gelieferter Daten
                                                  //                        / really returned Bytes of Data

    If (ulRC = ERROR_INVALID_DRIVE) Then          // Laufwerk nicht vorhanden / Drive present
      fResult := True
    Else If (ulRC = NO_ERROR) Then                // Laufwerk vorhanden -> weiter auswerten
                                                  // if Drive is present -> further investigations
      Begin
        rDriveInfoData.rDriveData.fDriveValid := True;  // Laufwerk vorhanden      / Flag: Drive present
        rDriveInfoData.wDevAttr := rDeviceParams.wAttr; // Device Parameter merken / store Device-Parameters
        If fixed In rDeviceParams.setAttr Then
          Begin
            rDriveInfoData.fRemovable := False;
            rDriveInfoData.fMediaPresent := True;
          End
        Else
          rDriveInfoData.fRemovable := True;

                                       /************************************
                                        * wenn Wechselmedium, dann Pruefung
                                        * auf Floppy
                                        *
                                        * if medium is removable check for
                                        * Floppy
                                        ************************************/
        If rDriveInfoData.fRemovable Then
          If fIsFloppy(iDriveNo) Then
            rDriveInfoData.rDriveData.eDriveType := Floppy
          Else
            rDriveInfoData.rDriveData.eDriveType := Removable;  // vorlaeufige Zuweisung
                                                                // preliminary assignment


                                       /************************************
                                        * Device oeffnen
                                        *
                                        * open Device
                                        ************************************/
        szDeviceName := Chr(Ord('A') + Pred(iDriveNo)) + ':';

        ulRC := DosOpen (szDeviceName,                  // Devicename           / Devicename
                         hDevHandle,                    // Puffer fuer Handle   / Devicehandle
                         ulAction,                      // ausgefuehrte Aktion  / Actioncode
                         0,                             // Dateigroesse         / Filesize
                         FILE_NORMAL,                   // Zugriffsmodus: read/write
                                                        //                      / access mode: read/write
                                                        
                         OPEN_ACTION_OPEN_IF_EXISTS,    // Openflag: oeffnen, wenn vorhanden
                                                        //                      / Openflag: open is exists
                                                        
                                                        // Modus/Mode:
                         OPEN_FLAGS_DASD OR             //        Device        / Device
                           OPEN_FLAGS_FAIL_ON_ERROR OR  //        Fehler per Returncode liefern
                                                        //                      / Error via Returncode
                           OPEN_SHARE_DENYNONE OR       //        keine Zugriffsbeschraenkungen fur Dritte
                                                        //                      / Sharemode
                           OPEN_ACCESS_READONLY,        //        Zugriff nur zum Lesen
                                                        //                      / read only
                         Nil);                          // kein Puffer fuer EA  / no IO-Buffer

                                       /************************************
                                        * wenn erfolgreich geoeffnet, dann
                                        * weitere Auswertung...
                                        *
                                        * if successfull opened then continue
                                        ************************************/
                                       /************************************
                                        * wenn Removable, dann ist der Fehler-
                                        * code ERROR_NOT_READY i.O.: es liegt
                                        * dann kein Medium im Laufwerk
                                        *
                                        * if Medium is removeable  then the
                                        * Errorcode ERROR_NOT_READY is ok;
                                        * no medium in drive
                                        ************************************/
        If ulRC In [NO_ERROR, ERROR_FILE_NOT_FOUND, ERROR_NOT_READY] Then
          Begin
                                       /************************************
                                        * wenn erfolgreich geoeffnet, dann
                                        * feststellen, ob Remote Drive
                                        *
                                        * remote drive ?
                                        ************************************/
            If ulRC = NO_ERROR Then
              Begin
                                       /************************************
                                        * Lockstatus ermitteln (liefert ne-
                                        * benbei, ob ein Medium vorhanden ist)
                                        * Ist natuerlich nur notwendig, wenn
                                        * nicht sowieso bekannt ist, ob ein
                                        * Medium im Laufwerk ist -> fixed
                                        * (siehe folgenden Kommentar)
                                        *
                                        * Get Lockstatus (secondary: is Medium
                                        * present). Not necessary if it is
                                        * obvious that there must be a medium
                                        * (fixed disk) - see comment below
                                        ************************************/
/* Einige Laufwerkstypen mit Wechselmedien (und die zugehoerigen Treiber) haben
   die mehr als schlechte Angewohnheit, bei Abfrage des Filesystems ueber die
   Funktion DosQueryFSAttach() einen Systemfehler (mit zugehoerigem Systemre-
   quester) zu generieren, wenn zum Zeitpunkt der Abfrage kein Medium im Lauf-
   werk liegt. Leider haben diese Geraete (namentlich: Syquest Wechselplatten)
   auch nicht den Anstand - wie z.B. CD-Roms - bei fehlendem Medium beim aus-
   fuehren von DosOpen() einen Fehlercode zu liefern.
   Abhilfe besteht lediglich darin, zu ermitteln, ob zum aktuellen Zeitpunkt
   ein Medium im Laufwerk liegt. Dies geschieht am guenstigsten ueber die IO-
   Control-Funktion zum ermitteln des LockStatus. Diese liefert nebenbei die
   gesuchte Information (zusaetzlich). Da es sich um eine Funktion aus der
   Kategorie DriveDevices ($08) handelt, wird hier von OS/2 in keinem Fall
   ein Systemrequester erzeugt...
   Liefert die Funktion als Ergebnis ein eingelegtes Medium, dann kann normal
   mit der Pruefung auf Remote-Laufwerk fortgefahren werden. Nur, wenn ein feh-
   lendes Medium gemeldet wird, muss abgebrochen werden. In diesem Fall wird
   das Laufwerk als Removable-Drive identifiziert, selbst dann, wenn es sich
   um ein Netzlaufwerk handelt - allerdings ist bisher die Kombination Netz-
   laufwerk und Removable noch nie aufgetreten... und so falsch ist die Mel-
   dung in dem Falle ja auch nicht. */

/* Some types of drives with removeable media (and their drivers) do not return
   an errorcode when querying informations about the filesystem and no medium is
   present. Instead they provoke an systemerror. Unfortunately those drives do
   not return an errocode on DosOpen() (e.g. Syquest Drives).
   So we have to know whether there is a medium inside the drive before we try
   to go on. This can be done via a call to IOCtl-Functions to get the Lock Status
   of the Drive (this call also delivers the desired informations). Because this
   request belongs to the functions of the category "DriveDevices" (0x08) OS/2
   never generates a system-messagebox...
   If this call reveals that there is a medium present we can continue to identify
   remote drives. Otherwise we abort and mark this drive as removable - even if
   this drive is remote (althoug this combination never appears so far). */

                If rDriveInfoData.fRemovable Then
                  Begin
                    rLockStatusParams.bCMDInfo := 0;                 // Cmd-Info (immer 0)
                                                                     // Cmd-Info (always 0)
                                                                     
                    rLockStatusParams.wDriveUnit := Pred(iDriveNo);  // Laufwerksnummer (beginnend bei 0!)
                                                                     // Drive-Number (starts with 0!)
                                                                     
                    ulParmLengthInOut := SizeOf(rLockStatusParams);  // Initialisierung fuer Anzahl zurueckgegebener Parameterbytes
                                                                     // size of Returnbuffer (for delivered data)
                    ulDataLengthInOut := 0;                          // keine Daten an Funktion geliefert
                                                                     // no data to the function

                    ulRC := DosDevIOCtl(hDevHandle,                  // Device Handle       / Device Handle
                                        IOCTL_DISK,                  // IOCtl Kategorie     / Category
                                        DSK_GETLOCKSTATUS,           // IOCTL Funktion      / Function
                                        rLockStatusParams,           // Parameterliste      / Parameterlist
                                        SizeOf(rLockStatusParams),   // max. Laenge zurueckgelieferter Parameterdaten
                                                                     //                     / max. Buffersize for Parameter-Data
                                        ulParmLengthInOut,           // tats. Anzahl Bytes gelieferter Parameterdaten
                                                                     //                     / really returned Parameter-Bytes
                                        rLockStatusData,             // Puffer fuer gelieferte Daten
                                                                     //                     / Buffer for returned data
                                        SizeOf(rLockStatusData),     // max. Groesse des Datenpuffers
                                                                     //                     / size of Buffer (for delivered Data)
                                        ulDataLengthInOut);          // tats. Anzahl Byte gelieferter Daten
                                                                     //                     / really returned Data-Bytes

                    If (ulRC = NO_ERROR) Then
                      If ((rLockStatusData.wLockStatus And ciMediaPresent)<>0) Then
                        rDriveInfoData.fMediaPresent := True
                      Else
                        rDriveInfoData.fMediaPresent := False
                    Else
                                       // wenn Status nicht ermittelt werden konnte,
                                       // dann annehmen, dass ein Medium vorhanden
                                       // ist - im unguenstigsten Fall erfolgt dann
                                       // eine Meldung ueber ein nicht bereites Lauf-
                                       // werk per Systemrequester (bis jetzt nur bei
                                       // bei Syquest Laufwerken beobachtet)
                                       //
                                       // if status is not available we suppose a 
                                       // present medium (worst case: a systemmessage
                                       // appears and inform us about missing drives)
                      rDriveInfoData.fMediaPresent := True

                  End; (* Ende: fuer Removables feststellen, ob Medium im Laufwerk *)
                       (* End: removeable medium present ? *)
                       
                                       /************************************
                                        * Device kann wieder geschlossen werden
                                        ************************************/
                DosClose(hDevHandle);  // Device wieder schliessen
                                       // close Device

                                       /************************************
                                        * wenn ein Medium im Laufwerk ist,
                                        * dann koennen bedenkenlos weitere
                                        * Informationen zum zugeordneten Da-
                                        * teisystem erfragt werden -> Remote?
                                        *
                                        * if medium is present we can query
                                        * additional filesystemdata without
                                        * problems -> remote Drive ?
                                        ************************************/
                If rDriveInfoData.fMediaPresent Then
                  Begin
                    rDriveInfoData.fMediaPresent := True;

                                       /************************************
                                        * Daten zum zugeordneten Dateisystem
                                        * ermitteln
                                        *
                                        * Filesystemdata
                                        ************************************/
                    /* Ausreichend Platz fuer Ergebnis-Struktur und die evtl. zu-
                       saetzlich gelieferten Informationen (zwei Bezeichner sowie
                       zusaetzliche Daten des Treibers) bereitstellen. IdR wird
                       weniger Pufferplatz benoetigt werden... */
                       
                    /* Reserving enough space for Results of DosQueryFSAttach() (two 
                       Identifiers and eventually additonal Data from the Driver). 
                       Normally we use less memory... */
                    GetMem(pBuffer, ciFSInfoBufferSize);  // Pufferspeicher bereitstellen
                                                          // get Buffermemory  

                    Try
                      FillChar(pBuffer^, ciFSInfoBufferSize, 0);
                        // Pred(), damit ein Kopieren des zus. Treiberdaten
                        // als nullterminierter String garantiert gelingt
                      ulDataLengthInOut := Pred(ciFSInfoBufferSize);

                      ulRC := DosQueryFSAttach(szDeviceName,         // Device Name
                                                                     // Device Name
                                                                     
                                               0,                    // immer 0 fuer FSAIL_QUERYNAME
                                                                     // always 0 for FSAIL_QUERYNAME
                                                                     
                                               FSAIL_QUERYNAME {1},  // Modus: Treibernamen abfragen
                                                                     // Mode: ask for drivername
                                                                     
                                               PFSQBUFFER2(pBuffer)^,// Pufferbereich fuer gelieferte Daten
                                                                     // Buffer for returned Data
                                                                     
                                               ulDataLengthInOut);   // max. Groesse des Pufferbereichs bzw.
                                                                     // tats. gelieferte Anzahl Bytes
                                                                     // size of Buffer and really returned
                                                                     // number of Bytes

                                       /************************************
                                        * bei Erfolg die Stringdaten bergen
                                        * und eindeutig festlegen, ob es sich
                                        * um ein Remote-Laufwerk handelt
                                        *
                                        * if successfull then recover Stringdata
                                        * and finally mark drive as remote or not
                                        ************************************/
                      If (ulRC = NO_ERROR) Then
                        Begin
                                       // Item Name
                          rDriveInfoData.szFSItem := CSTRING(PFSQBUFFER2(pBuffer)^.szName);
                                       // Driver Name
                          pszData := PChar(@PFSQBUFFER2(pBuffer)^.szName);
                          Inc(pszData, Succ(PFSQBUFFER2(pBuffer)^.cbName));
                          rDriveInfoData.szFSDName := CSTRING(pszData^);
                                      // Driver Data
                          Inc(pszData, Succ(PFSQBUFFER2(pBuffer)^.cbFSDName));
                          rDriveInfoData.wFSDataLength := PFSQBUFFER2(pBuffer)^.cbFSAData;
                          rDriveInfoData.szFSAData := CSTRING(pszData^);

                          rDriveInfoData.fFSDataValid := True;

                                       /************************************
                                        * Remote Drive ?
                                        ************************************/
                          If (PFSQBUFFER2(pBuffer)^.iType = FSAT_REMOTEDRV) then
                            rDriveInfoData.rDriveData.eDriveType := Remote;

                        End; (* If (ulRC = NO_ERROR)    Ende: DosQueryFSAttach() war erfolgreich *)

                    Finally
                      FreeMem(pBuffer, ciFSInfoBufferSize);  // Pufferspeicher wieder freigeben
                    End

                  End (* If (rDriveInfoData.fM...   Ende: Medium eingelegt *)

              End (* Ende: Device erfolgreich geîffnet *)

            Else (* ERROR_FILE_NOT_FOUND, ERROR_NOT_READY *)
              rDriveInfoData.fMediaPresent := False;

                                       /************************************
                                        * Devicetyp detailliert auswerten
                                        *
                                        * Devicetype en detail
                                        ************************************/
                                       /************************************
                                        * Remote
                                        ************************************/
            If rDriveInfoData.rDriveData.eDriveType = Remote Then
              Begin
                // wenn Typ Remote Drive, dann ist mit keinen genaueren Angaben mehr zu rechnen
              End
                                       /************************************
                                        * Removable Media
                                        ************************************/
            Else If rDriveInfoData.fRemovable Then
              Case rDriveInfoData.rDriveData.eDriveType Of
                noDrive,
                noAccess,
                disconnected,
                Floppy         : Begin
                                   // da ist nichts mehr zu zu sagen
                                   // all is said...
                                 End;
              Else                 // unterscheiden zw. CD, MO u.a. Removables
                                   // distuingish between CD, Tape, MO and other removeable Drives
                Case rDeviceParams.bDeviceType Of
                  ciDevTypeTape : rDriveInfoData.rDriveData.eDriveType := TapeDrive;
                  ciDevTypeMO   : rDriveInfoData.rDriveData.eDriveType := MODrive;
                Else
                                       /************************************
                                        * CD-Rom ?
                                        ************************************/
                  uQueryCDRom(ulCDRomCount, ulFirstCDRomDiskNo);

                  If (ulCDRomCount > 0) And
                     (ulFirstCDRomDiskNo >= gciMinDriveNo) And
                     (ulFirstCDRomDiskNo <= gciMaxDriveNo) Then
                    If (iDriveNo >= ulFirstCDRomDiskNo) And
                       (iDriveNo < (ulFirstCDRomDiskNo + ulCDRomCount)) Then
                      rDriveInfoData.rDriveData.eDriveType := CDRom
                    Else
                      rDriveInfoData.rDriveData.eDriveType := Removable
                  Else
                      rDriveInfoData.rDriveData.eDriveType := Removable;

                End (* Ende: MO, CD, Tape, Removable unterscheiden *)

              End (* Case rDriveInf... *)

                                       /************************************
                                        * fix (aber nicht remote) ->
                                        * lokale HDD oder lokale RamDisk
                                        *
                                        * fixed and local -> local Hard- or
                                        * Ramdisk
                                        ************************************/
            Else
              If rDeviceParams.bDeviceType = ciDevTypeOther Then
                rDriveInfoData.rDriveData.eDriveType := RamDisk
              Else
                rDriveInfoData.rDriveData.eDriveType := HardDisk


                                       /************************************
                                        *
                                        ************************************/
          End (* If ulRC In [NO_E...  Ende: Device liess sich oeffnen *)
                                       /************************************
                                        * DosOpen()
                                        * im Fehlerfall feststellen, ob nicht
                                        * evtl. ein Geistergeraet gemeldet wur-
                                        * de (z.B. eine fehlende 2. Floppy)
                                        *
                                        * if DosOpen() fails this is maybe
                                        * caused by a "Ghost"-Device (e.g.
                                        * a second - but not present - Floppy)
                                        ************************************/
        Else
          If ulRC = ERROR_DISK_CHANGE Then  // Anzeichen fuer Geistergeraet
                                            // Symptom for "Ghost" Devices
            rDriveInfoData.rDriveData.eDriveType := disconnected
          Else
            rDriveInfoData.rDriveData.eDriveType := noAccess;  // kein Zugriff moeglich
                                                               // no access possible

      End; (* Ende: Laufwerk vorhanden *)


    fResult := True;                   // Funktion erfolgreich abgearbeitet
                                       // Returncode for success

                                       /************************************
                                        * Clean-Up (und Funktionsergebnis)
                                        ************************************/
  Finally
    fGetDriveInfoData := fResult;
  End;

End; (* fGetDriveInfoData() *)

// -------------------------------------------------------------------------
// Prozedur/Procedure: uGetDriveMap()
//
// Beschreibung:
//   Eine Liste vorhandener Laufwerke und Informationen ueber deren Typ zu-
//   sammenstellen und im globalen Array garDrives[] ablegen. Die Informa-
//   tionsbeschaffung wird der Funktion fGetDriveInfoData() ueberlassen.
//
// Description:
//   Building a list of Drives and collecting informations about available
//   Drives. All Data are stored in the public Array garDrives[].
//   The Function fGetDriveInfoData() will do the job for each drive.
//
// Parameter:
//   keine / none
//
// Rueckgabe/Returnvalue:  keine / none
// -------------------------------------------------------------------------
Procedure uGetDriveMap;

Var iIndex,                            // Array-Index
    iDriveNo : Integer;                // Indexzaehler fuer Laufwerksnummern
                                       // Counter for Drive-Numbers

    rDriveInfoData : trDriveInfoData;  // Struktur fuer Drive-Informationen
                                       // Record for Drive-Data

Begin (* uGetDriveMap() *)
                                       /************************************
                                        * Liste abarbeiten
                                        *
                                        * whole list
                                        ************************************/
  For iIndex := Low(garDrives) To High(garDrives) Do
    Begin
                                       /************************************
                                        * Laufwerksnummer ermitteln
                                        *
                                        * calculate Drive-Number
                                        ************************************/
      iDriveNo := Succ(iIndex - Low(garDrives));

                                       /************************************
                                        * wenn gueltig, dann Informationen holen
                                        *
                                        * get informations about drive when
                                        * Drive-Number is valid
                                        ************************************/
      if (iDriveNo >= gciMinDriveNo) And (iDriveNo <= gciMaxDriveNo) Then
        If fGetDriveInfoData(iDriveNo, rDriveInfoData) Then
                                       /************************************
                                        * wenn ok, dann uebernehmen
                                        *
                                        * if ok, then transfer data to current
                                        * Array-Element
                                        ************************************/
          Begin
            garDrives[iIndex].iDriveNo := rDriveInfoData.rDriveData.iDriveNo;
            //garDrives[iIndex].cDriveLetter := rDriveInfoData.rDriveData.cDriveLetter;
            garDrives[iIndex].fDriveValid := rDriveInfoData.rDriveData.fDriveValid;
            garDrives[iIndex].cDriveLetter :=CHR(64+IDriveNo);
            garDrives[iIndex].eDriveType := rDriveInfoData.rDriveData.eDriveType;
            garDrives[iIndex].Filesystem:= rDriveInfoData.szFSDName;
            IF CDROM in [garDrives[iindex].eDriveType] Then
            Begin

            End else
            Begin
                 IF IDriveNo>2 Then
                 begin
                      IF TestLanDrive(CHR(64+IDriveNO)) Then
                      Begin
                           garDrives[iIndex].eDriveType :=Remote;
                           garDrives[iIndex].Filesystem:='LAN';
                      End;
                 End;
            End;

          End
        Else
          Begin
                                       /************************************
                                        * wenn Fehler, dann Standardbelegung
                                        *
                                        * if an error occur then reset current
                                        * Array-Element to Standard-Data
                                        ************************************/
            garDrives[iIndex].iDriveNo := -1;
            garDrives[iIndex].cDriveLetter := #0;
            garDrives[iIndex].fDriveValid := False;
            garDrives[iIndex].eDriveType := Failure;
          End;

    End; (* For *)

End;


// =========================================================================
// Unit Initialization
// =========================================================================
Begin
  //uGetDriveMap;
End.

// =========================================================================
// End of File
// =========================================================================
