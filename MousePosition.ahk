/*
* encoding: EUC-KR
*/

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;마우스 강제 이동 시간
global forceMouseMoveTime = 5 * 60 * 1000

;마우스 강제 이동 횟수
global forceMouseMoveCount = 0

;마우스 위치 정보
global lastMousePositionX = 0
global lastMousePositionY = 0
global lastMouseMoveTime := A_TickCount

;툴팁 알림 표시 시간
global displayToolTipTime = 1 * 60 * 1000

;시작
MouseGetPos, lastMousePositionX, lastMousePositionY
SetTimer, MousePositionDetecting, 100
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;마우스 위치 감지
MousePositionDetecting:
RunMousePositionDetecting()
Return

;로그인
~Insert::
LoginMotionPro()
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
* 마우스 위치 감지
*/
RunMousePositionDetecting()
{
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
}

/*
* 로그인
*/
LoginMotionPro()
{
    ;로그인 창이 없으면 종료
    If (!WinExist("Authentication Information"))
    {
        SoundBeep, 300, 500
        Return
    }

    ;속도 초기화
    SetControlDelay -1
    SetKeyDelay, -1

    ;비밀번호 지우기
    loop 30
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, Authentication Information
        ControlSend, Qt5QWindowIcon17, {Delete}, Authentication Information
    }
    Sleep, 200

    ;비밀번호 초기화
    password = Inter123$`%^

    ;비밀번호 OTP 추가
    If (WinExist("MotionProOTP"))
    {
        ControlClick, x300 y320, MotionProOTP
        SoundBeep, 800, 100
        SoundBeep, 800, 100

        password := password . Clipboard
    }

    ;비밀번호 입력 위치 클릭
    ControlClick, x315 y200, Authentication Information
    Sleep, 200

    ;비밀번호 입력
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, %password%, Authentication Information
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50
    SoundBeep, 1000, 50
    
    Return
}