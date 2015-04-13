Unit MessageBoxUnit;
INTERFACE
uses Os2Def, Os2PmApi, SysUtils;
Procedure ShowMessage(MsgTitle,Msg:String);

IMPLEMENTATION

Procedure ShowMessage(MsgTitle,Msg:String);

  var
    Ptl        : PointL; // message data
    hwndClient : HWnd;   // client window handle
    Ab         : Hab;
    Mq         : Hmq;

  begin
    Ab := WinInitialize(0);
    Mq := WinCreateMsgQueue(Ab, 0);

    WinQueryPointerPos(HWND_DESKTOP, ptl);

    //Msg := Format( 'x = %d   y = %d'#0, [ ptl.x, ptl.y ] );
    WinMessageBox(HWND_DESKTOP,
      hwndClient,                // client-window handle
      @Msg[1],                   // body of the message
      @MsgTitle[1],   // title of the message
      0,                         // message box id
      MB_information OR MB_OK);       // icon and button flags
  end;


Begin

End.
