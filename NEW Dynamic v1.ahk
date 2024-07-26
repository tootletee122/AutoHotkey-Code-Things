#Persistent
#SingleInstance Force
SetTitleMatchMode, 2
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetWinDelay, -1
SetControlDelay, -1

; Constants for default values
DEFAULT_SEARCH_COLOR := 0x00E6E6 ; Default search color
DEFAULT_PREDICTION_FACTOR := 100.0 ; Increased prediction factor for more aggressive lead aiming

; Initialize global variables
global aimbotEnabled := false
global triggerbotEnabled := false
global centerX := A_ScreenWidth // 2
global centerY := A_ScreenHeight // 2
global searchWidth := 185
global searchHeight := 185
global colorTolerance := 10
global horizontalOffset := 2.5
global verticalOffset := 5.0
global baseSensitivity := 0.1 ; Base sensitivity
global maxSensitivity := 6.3 ; Maximum sensitivity
global sensitivityExponent := 0.2 ; Exponent for sensitivity adjustment
global distanceThreshold := 500 ; Distance at which sensitivity is maxed out
global dpi := 500
global predictionEnabled := false ; Default prediction state
global predictionFactor := DEFAULT_PREDICTION_FACTOR

; Create GUI with Windows 11-like theme
Gui, Color, 0x1E1E1E
Gui, Font, s12 bold, Segoe UI
Gui, Add, Text, x10 y10 w210 h30 cFFFFFF Center vTitle, Aimbot Controller
Gui, Font, s10 cFFFFFF, Segoe UI

; Aimbot Control Section
Gui, Add, GroupBox, x10 y50 w210 h80 c00E6E6, Aimbot Settings
Gui, Font, s10 cFFFFFF, Segoe UI
Gui, Add, Checkbox, x20 y70 w180 h20 vPredictionEnabled, Enable Prediction

Gui, Add, Button, x10 y130 w210 h30 gUpdateSettings cFFA500, Restart Script
Gui, Add, Button, x10 y170 w210 h30 gToggleAimbot vToggleButton cFFA500, Enable Aimbot
Gui, Add, Text, x10 y200 w210 h20 cFFFFFF vStatus, Aimbot Disabled

; Triggerbot Control Section
Gui, Add, GroupBox, x10 y230 w210 h60 c00E6E6, Triggerbot Settings
Gui, Font, s10 cFFFFFF, Segoe UI
Gui, Add, Button, x10 y250 w210 h30 gToggleTriggerbot vToggleTriggerButton cFFA500, Enable Triggerbot
Gui, Add, Text, x10 y280 w210 h20 cFFFFFF vTriggerStatus, Triggerbot Disabled

Gui, Show, w230 h340, Aimbot Controller

; Set timers for main loop and aimbot
SetTimer, AimbotLoop, 3 ; Aimbot loop
SetTimer, TriggerbotLoop, 20 ; Triggerbot loop

; Set Kill Switch to disable Aimbot and Triggerbot
~Esc::KillSwitch()

return

; Kill Switch function
KillSwitch() {
    global aimbotEnabled, triggerbotEnabled
    aimbotEnabled := false
    triggerbotEnabled := false
    GuiControl,, Status, Aimbot Disabled
    GuiControl,, ToggleButton, Enable Aimbot
    GuiControl,, TriggerStatus, Triggerbot Disabled
    GuiControl,, ToggleTriggerButton, Enable Triggerbot
}

; Toggle aimbot function
ToggleAimbot:
    aimbotEnabled := !aimbotEnabled
    GuiControl,, Status, % (aimbotEnabled ? "Aimbot Enabled" : "Aimbot Disabled")
    GuiControl,, ToggleButton, % (aimbotEnabled ? "Disable Aimbot" : "Enable Aimbot")
return

; Toggle triggerbot function
ToggleTriggerbot:
    triggerbotEnabled := !triggerbotEnabled
    GuiControl,, TriggerStatus, % (triggerbotEnabled ? "Triggerbot Enabled" : "Triggerbot Disabled")
    GuiControl,, ToggleTriggerButton, % (triggerbotEnabled ? "Disable Triggerbot" : "Enable Triggerbot")
return

; Update settings function
UpdateSettings:
    ; Optionally reapply default values or reset script
    Reload
return

; Improved Aimbot loop function
AimbotLoop:
    if (!aimbotEnabled || !GetKeyState("RButton", "P"))
        return

    ; Calculate search area boundaries
    left := Max(centerX - (searchWidth // 2), 0)
    top := Max(centerY - (searchHeight // 2), 0)
    right := Min(centerX + (searchWidth // 2), A_ScreenWidth)
    bottom := Min(centerY + (searchHeight // 2), A_ScreenHeight)

    ; Perform PixelSearch within the defined area
    PixelSearch, foundX, foundY, left, top, right, bottom, %DEFAULT_SEARCH_COLOR%, %colorTolerance%, Fast RGB

    ; Check if pixel was found within the defined area
    if (!ErrorLevel && foundX >= left && foundX <= right && foundY >= top && foundY <= bottom) {
        ; Apply offsets to adjust aim position
        aimX := foundX + horizontalOffset
        aimY := foundY + verticalOffset

        ; Calculate relative movement
        xRel := aimX - centerX
        yRel := aimY - centerY

        ; Calculate distance between center and target
        distance := Sqrt(xRel**2 + yRel**2)

        ; Calculate dynamic sensitivity based on distance
        if (distance < distanceThreshold) {
            dynamicSensitivity := baseSensitivity + ((maxSensitivity - baseSensitivity) * (distance / distanceThreshold))
        } else {
            dynamicSensitivity := maxSensitivity
        }

        ; Apply sensitivity exponent
        dynamicSensitivity := dynamicSensitivity ** sensitivityExponent

        ; Apply prediction factor if enabled
        if (predictionEnabled) {
            ; Calculate predicted movement
            xPredicted := Round(xRel * dynamicSensitivity * predictionFactor)
            yPredicted := Round(yRel * dynamicSensitivity * predictionFactor)

            ; Directly move mouse to the predicted position
            if (xPredicted != 0 || yPredicted != 0) {
                ; Direct movement towards the predicted position
                DllCall("mouse_event", "UInt", 0x0001, "Int", xPredicted, "Int", yPredicted, "UInt", 0, "UInt", 0)
            }
        } else {
            ; Directly move the mouse
            DllCall("mouse_event", "UInt", 0x0001, "Int", Round(xRel * dynamicSensitivity), "Int", Round(yRel * dynamicSensitivity), "UInt", 0, "UInt", 0)
        }
    }
return

; Triggerbot loop function
TriggerbotLoop:
    if (triggerbotEnabled) {
        ; Perform pixel search to detect if target is in the center
        PixelSearch, targetX, targetY, centerX - 5, centerY - 5, centerX + 5, centerY + 5, %DEFAULT_SEARCH_COLOR%, %colorTolerance%, Fast RGB
        if (!ErrorLevel) {
            Click
        }
    }
return
