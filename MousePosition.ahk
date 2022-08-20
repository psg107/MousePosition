/*
* encoding: EUC-KR
* - Win11
* - 프로그램 설치 경로 하드코딩
* - 비밀번호 하드코딩
*/

;초기화
#SingleInstance, force
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetTitleMatchMode, 3

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
RunMotionProApps()
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
* 모션프로 실행
*/
RunMotionProApps()
{
    ;모션프로 실행
    If (!WinExist("MotionPro"))
    {
        Run C:\Program Files\Array Networks\MotionPro VPN Client\MotionPro.exe
    }

    ;모션프로OTP 실행
    If (!WinExist("MotionProOTP"))
    {
        Run C:\Users\psg10\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\WsaClient.exe /launch wsa://com.arraynetworks.authentication
    }
}

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
    MOTION_PRO_WINDOW_TITLE = MotionPro
    MOTION_PRO_LOGIN_WINDOW_TITLE = Authentication Information
    MOTION_PRO_OTP_WINDOW_TITLE = MotionProOTP
    TEMP_CLIPBOARD_MESSAGE = THIS_IS_TEMP_MESSAGE

    WinActivate, %MOTION_PRO_WINDOW_TITLE%

    ;로그인 창이 없으면 종료
    If (!WinExist(MOTION_PRO_LOGIN_WINDOW_TITLE))
    {
        SoundBeep, 300, 500
        Return
    }

    ;활성화
    WinActivate, %MOTION_PRO_LOGIN_WINDOW_TITLE%

    ;속도 초기화
    SetControlDelay -1
    SetKeyDelay, -1

    ;테스트 비밀번호 입력
    SetKeyDelay, -1, 10
    ControlSendRaw, Qt5QWindowIcon17, INPUT TEST, %MOTION_PRO_LOGIN_WINDOW_TITLE%

    Sleep, 500

    ;비밀번호 지우기
    loop 30
    {
        ControlSend, Qt5QWindowIcon17, {BackSpace}, %MOTION_PRO_LOGIN_WINDOW_TITLE%
        ControlSend, Qt5QWindowIcon17, {Delete}, %MOTION_PRO_LOGIN_WINDOW_TITLE%
    }
    Sleep, 200

    ;비밀번호 초기화
    password = Inter123$`%^

    ;비밀번호 OTP 추가
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

    ;비밀번호 입력 위치 클릭
    ControlClick, x315 y200, %MOTION_PRO_LOGIN_WINDOW_TITLE%
    Sleep, 200

    ;비밀번호 입력
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