CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;���콺 ���� �̵� �ð�
global forceMouseMoveTime = 300 * 1000

;���콺 ���� �̵� Ƚ��
global forceMouseMoveCount = 0

;���콺 ��ġ ����
global lastMousePositionX = 0
global lastMousePositionY = 0
global lastMouseMoveTime := A_TickCount

;���� �˸� ǥ�� �ð�
global displayToolTipTime = 60 * 1000

;����
MouseGetPos, lastMousePositionX, lastMousePositionY
SetTimer, MousePositionDetect, 100
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MousePositionDetect:

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
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

~Insert::
If (WinExist("Authentication Information"))
{
    ;��й�ȣ �Է� ��ġ Ŭ�� �ѹ� (Ŭ�� ���ϸ� �Է��� �ȵ�)
    SetControlDelay -1
    ControlClick, x315 y200, Authentication Information

    ;�����
    SetKeyDelay, -1
    loop 10
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, Authentication Information
        ControlSend, Qt5QWindowIcon17, {Delete}, Authentication Information
    }

    ;Inter123$%^ �Է�
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, Inter123$`%^, Authentication Information

    ;���� OTPâ�� �����ִٸ� OTP ���� & �Է�
    If (WinExist("MotionProOTP"))
    {
        ;����
        ControlClick, x300 y320, MotionProOTP

        ;�Է�
        otp := Clipboard
        ControlSendRaw, Qt5QWindowIcon17, %otp%, Authentication Information
    }
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

~End::
;ExitApp
Return