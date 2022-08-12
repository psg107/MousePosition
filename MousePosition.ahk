/*
* encoding: EUC-KR
*/

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

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
    ;�α��� â�� ������ ����
    If (!WinExist("Authentication Information"))
    {
        SoundBeep, 300, 500
        Return
    }

    ;�ӵ� �ʱ�ȭ
    SetControlDelay -1
    SetKeyDelay, -1

    ;��й�ȣ �����
    loop 30
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, Authentication Information
        ControlSend, Qt5QWindowIcon17, {Delete}, Authentication Information
    }
    Sleep, 200

    ;��й�ȣ �ʱ�ȭ
    password = Inter123$`%^

    ;��й�ȣ OTP �߰�
    If (WinExist("MotionProOTP"))
    {
        ControlClick, x300 y320, MotionProOTP
        SoundBeep, 800, 100
        SoundBeep, 800, 100

        password := password . Clipboard
    }

    ;��й�ȣ �Է� ��ġ Ŭ��
    ControlClick, x315 y200, Authentication Information
    Sleep, 200

    ;��й�ȣ �Է�
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, %password%, Authentication Information
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50
    
    Return
}