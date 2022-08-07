CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;마우스 강제 이동 시간
global forceMouseMoveTime = 300 * 1000

;마우스 강제 이동 횟수
global forceMouseMoveCount = 0

;마우스 위치 정보
global lastMousePositionX = 0
global lastMousePositionY = 0
global lastMouseMoveTime := A_TickCount

;툴팁 알림 표시 시간
global displayToolTipTime = 60 * 1000

;시작
MouseGetPos, lastMousePositionX, lastMousePositionY
SetTimer, MousePositionDetect, 100
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MousePositionDetect:

;마우스 위치가 변경되었으면 마우스 위치 정보 갱신
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

;장시간 마우스 위치가 변경되지 않았으면 마우스 위치 강제 변경
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

;툴팁 알림
if (forceMouseMoveCount >= 1 || mouseStopTime > displayToolTipTime)
{
    ToolTip, %forceMouseMoveCount% %mouseStopTime%/%forceMouseMoveTime%
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

~Insert::
If (WinExist("Authentication Information"))
{
    ;비밀번호 입력 위치 클릭 한번 (클릭 안하면 입력이 안됨)
    SetControlDelay -1
    ControlClick, x315 y200, Authentication Information

    ;지우기
    SetKeyDelay, -1
    loop 10
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, Authentication Information
        ControlSend, Qt5QWindowIcon17, {Delete}, Authentication Information
    }

    ;Inter123$%^ 입력
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, Inter123$`%^, Authentication Information

    ;만약 OTP창이 열려있다면 OTP 복사 & 입력
    If (WinExist("MotionProOTP"))
    {
        ;복사
        ControlClick, x300 y320, MotionProOTP

        ;입력
        otp := Clipboard
        ControlSendRaw, Qt5QWindowIcon17, %otp%, Authentication Information
    }
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

~End::
;ExitApp
Return