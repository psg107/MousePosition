/*
* encoding: EUC-KR
* - Win11
* - ���α׷� ��ġ ��� �ϵ��ڵ�
* - ��й�ȣ �ϵ��ڵ�
*/

;�ʱ�ȭ
#SingleInstance, force
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetTitleMatchMode, 3

;���콺 ���� �̵� �ð�
global forceMouseMoveTime = 5 * 60 * 1000

;���콺 ���� �̵� Ƚ��
global forceMouseMoveCount = 0

;���콺 ��ġ ����
global lastMousePositionX = 0
global lastMousePositionY = 0
global lastMouseMoveTime := A_TickCount

;���� �˸� ǥ�� �ð�
global displayToolTipTime = 1 * 60 * 1000

;����
RunMotionProApps()
MouseGetPos, lastMousePositionX, lastMousePositionY
SetTimer, MousePositionDetecting, 100
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;���콺 ��ġ ����
MousePositionDetecting:
RunMousePositionDetecting()
Return

;�α���
~Insert::
LoginMotionPro()
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
* ������� ����
*/
RunMotionProApps()
{
    ;������� ����
    If (!WinExist("MotionPro"))
    {
        Run C:\Program Files\Array Networks\MotionPro VPN Client\MotionPro.exe
    }

    ;�������OTP ����
    If (!WinExist("MotionProOTP"))
    {
        Run C:\Users\psg10\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\WsaClient.exe /launch wsa://com.arraynetworks.authentication
    }
}

/*
* ���콺 ��ġ ����
*/
RunMousePositionDetecting()
{
    ;���콺 ��ġ�� ����Ǿ����� ���콺 ��ġ ���� ����
    MouseGetPos, currentMouseX, currentMouseY
    if (currentMouseX != lastMousePositionX || currentMouseY != lastMousePositionY)
    {
        forceMouseMoveCount := 0
        lastMousePositionX := currentMouseX
        lastMousePositionY := currentMouseY
        lastMouseMoveTime := A_TickCount
        ToolTip
        Return
    }

    ;��ð� ���콺 ��ġ�� ������� �ʾ����� ���콺 ��ġ ���� ����
    mouseStopTime := A_TickCount - lastMouseMoveTime
    if (mouseStopTime > forceMouseMoveTime)
    {
        MouseMove, 0, 0
        MouseMove, %currentMouseX%, %currentMouseY%

        lastMouseMoveTime := A_TickCount
        forceMouseMoveCount := forceMouseMoveCount + 1
        ToolTip
        Return
    }

    ;���� �˸�
    if (forceMouseMoveCount >= 1 || mouseStopTime > displayToolTipTime)
    {
        ToolTip, %forceMouseMoveCount% %mouseStopTime%/%forceMouseMoveTime%
    }
}

/*
* �α���
*/
LoginMotionPro()
{
    MOTION_PRO_WINDOW_TITLE = MotionPro
    MOTION_PRO_LOGIN_WINDOW_TITLE = Authentication Information
    MOTION_PRO_OTP_WINDOW_TITLE = MotionProOTP
    TEMP_CLIPBOARD_MESSAGE = THIS_IS_TEMP_MESSAGE

    WinActivate, %MOTION_PRO_WINDOW_TITLE%

    ;�α��� â�� ������ ����
    If (!WinExist(MOTION_PRO_LOGIN_WINDOW_TITLE))
    {
        SoundBeep, 300, 500
        Return
    }

    ;Ȱ��ȭ
    WinActivate, %MOTION_PRO_LOGIN_WINDOW_TITLE%

    ;�ӵ� �ʱ�ȭ
    SetControlDelay -1
    SetKeyDelay, -1

    ;�׽�Ʈ ��й�ȣ �Է�
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, INPUT TEST, %MOTION_PRO_LOGIN_WINDOW_TITLE%

    Sleep, 500

    ;��й�ȣ �����
    loop 30
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, %MOTION_PRO_LOGIN_WINDOW_TITLE%
        ControlSend, Qt5QWindowIcon17, {Delete}, %MOTION_PRO_LOGIN_WINDOW_TITLE%
    }
    Sleep, 200

    ;��й�ȣ �ʱ�ȭ
    password = Inter123$`%^

    ;��й�ȣ OTP �߰�
    If (WinExist(MOTION_PRO_OTP_WINDOW_TITLE))
    {
        oldClipboard := Clipboard

        Clipboard := TEMP_CLIPBOARD_MESSAGE

        loop
        {
            ControlClick, x300 y320, MotionProOTP
            SoundBeep, 800, 100
            SoundBeep, 800, 100

            If (Clipboard == TEMP_CLIPBOARD_MESSAGE)
            {
                Sleep, 200
                Continue
            }

            password := password . Clipboard
            Clipboard := oldClipboard
            Break
        }
    }

    ;��й�ȣ �Է� ��ġ Ŭ��
    ControlClick, x315 y200, %MOTION_PRO_LOGIN_WINDOW_TITLE%
    Sleep, 200

    ;��й�ȣ �Է�
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, %password%, %MOTION_PRO_LOGIN_WINDOW_TITLE%
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50

    WinGetPos, x,y, width,height, %MOTION_PRO_LOGIN_WINDOW_TITLE%

    ToolTip %password%, x + 30,y + 30
    Sleep, 5000
    ToolTip
    
    Return
}