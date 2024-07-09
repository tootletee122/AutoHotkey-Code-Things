; Optimization Settings
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetWinDelay, -1
SetControlDelay, -1

#Persistent
#SingleInstance Force
SetTitleMatchMode, 2

; Constants for default values
DEFAULT_SEARCH_WIDTH := 400
DEFAULT_SEARCH_HEIGHT := 400
DEFAULT_COLOR_TOLERANCE := 8
DEFAULT_SEARCH_COLOR := 0x00E6E6
DEFAULT_HORIZONTAL_OFFSET := 0
DEFAULT_VERTICAL_OFFSET := 2.5
DEFAULT_SENSITIVITY := 0.85

; Initialize global variables
global aimbotEnabled := false
global triggerbotEnabled := false
global centerX := A_ScreenWidth // 2
global centerY := A_ScreenHeight // 2
global searchWidth := DEFAULT_SEARCH_WIDTH
global searchHeight := DEFAULT_SEARCH_HEIGHT
global colorTolerance := DEFAULT_COLOR_TOLERANCE
global horizontalOffset := DEFAULT_HORIZONTAL_OFFSET
global verticalOffset := DEFAULT_VERTICAL_OFFSET
global sensitivity := DEFAULT_SENSITIVITY

; Variables for smart aimbot logic
global lastAimX := centerX
global lastAimY := centerY
global aimCooldown := 500  ; Cooldown period in milliseconds
global aimCooldownTimer := 0
global aimResetDistance := 100  ; Distance threshold to reset aim when target moves away

; Smart optimizing variables
global optimizeCooldown := 3000  ; Cooldown for optimizing search parameters
global optimizeCooldownTimer := 0
global lastOptimizedX := centerX
global lastOptimizedY := centerY

; Create sophisticated GUI
Gui, Font, s10, Segoe UI
Gui, Color, 0x1E1E1E
Gui, Add, Text, x10 y10 w210 h30 cFFFFFF Center vTitle, Àimbót Cöntrollér
Gui, Font, s10, Segoe UI

; Aimbot Control Section
Gui, Add, GroupBox, x10 y50 w210 h220 c00E6E6, Àimbót Séttíngs
Gui, Add, Text, x20 y70 w100 h20 cFFFFFF, Séarch Âréa:
Gui, Add, Text, x20 y95 w60 h20 cFFFFFF, Wídth:
Gui, Add, Edit, x80 y95 w60 vSearchWidth c000000, %searchWidth%
Gui, Add, Text, x20 y120 w60 h20 cFFFFFF, Héíght:
Gui, Add, Edit, x80 y120 w60 vSearchHeight c000000, %searchHeight%
Gui, Add, Text, x20 y145 w100 h20 cFFFFFF, Cölór Tóleránce:
Gui, Add, Edit, x120 y145 w60 vColorTolerance c000000, %colorTolerance%
Gui, Add, Text, x20 y170 w100 h20 cFFFFFF, Hórízóntál Öffsét:
Gui, Add, Edit, x120 y170 w60 vHorizontalOffset c000000, %horizontalOffset%
Gui, Add, Text, x20 y195 w100 h20 cFFFFFF, Vértícál Öffsét:
Gui, Add, Edit, x120 y195 w60 vVerticalOffset c000000, %verticalOffset%
Gui, Add, Text, x20 y220 w100 h20 cFFFFFF, Sénsítiṽíty:
Gui, Add, Edit, x120 y220 w60 vSensitivity c000000, %sensitivity%
Gui, Add, Button, x10 y250 w210 h30 gUpdateSettings, Üpdáté Séttíngs
Gui, Add, Button, x10 y290 w210 h30 gToggleAimbot vToggleButton, Énáble Àimbót
Gui, Add, Text, x10 y330 w210 h20 cFFFFFF vStatus, Àimbót Dísaḃléd

; Triggerbot Control Section
Gui, Add, GroupBox, x10 y360 w210 h30 c00E6E6, Tríggérbót Séttíngs
Gui, Add, Button, x10 y380 w210 h30 gToggleTriggerbot vToggleTriggerButton, Énáble Tríggérbót
Gui, Add, Text, x10 y420 w210 h20 cFFFFFF vTriggerStatus, Tríggérbót Dísaḃléd

; Show GUI
Gui, Show, w230 h460, Àimbót Cöntrollér

; Main loop
SetTimer, AimbotLoop, 10

return

; Toggle aimbot function
ToggleAimbot:
    aimbotEnabled := !aimbotEnabled
    GuiControl,, Status, % (aimbotEnabled ? "Àimbót Énábléd" : "Àimbót Dísaḃléd")
    GuiControl,, ToggleButton, % (aimbotEnabled ? "Dísaḃlé Àimbót" : "Énáblé Àimbót")
return

; Toggle triggerbot function
ToggleTriggerbot:
    triggerbotEnabled := !triggerbotEnabled
    GuiControl,, TriggerStatus, % (triggerbotEnabled ? "Tríggérbót Énábléd" : "Tríggérbót Dísaḃléd")
    GuiControl,, ToggleTriggerButton, % (triggerbotEnabled ? "Dísaḃlé Tríggérbót" : "Énáblé Tríggérbót")
return

; Update settings function
UpdateSettings:
    GuiControlGet, searchWidth,, SearchWidth
    GuiControlGet, searchHeight,, SearchHeight
    GuiControlGet, colorTolerance,, ColorTolerance
    GuiControlGet, horizontalOffset,, HorizontalOffset
    GuiControlGet, verticalOffset,, VerticalOffset
    GuiControlGet, sensitivity,, Sensitivity

    ; Validate and adjust parameters
    searchWidth := Max(searchWidth, 1)
    searchHeight := Max(searchHeight, 1)
    colorTolerance := Max(colorTolerance, 0)
    sensitivity := Max(sensitivity, 0)

    ; Update global variables
    global searchWidth := searchWidth
    global searchHeight := searchHeight
    global colorTolerance := colorTolerance
    global horizontalOffset := horizontalOffset
    global verticalOffset := verticalOffset
    global sensitivity := sensitivity
return

; Aimbot loop function
AimbotLoop:
    if (!aimbotEnabled)
        return
    
    ; Calculate search area boundaries
    left := Max(centerX - (searchWidth // 2), 0)
    top := Max(centerY - (searchHeight // 2), 0)
    right := Min(centerX + (searchWidth // 2), A_ScreenWidth)
    bottom := Min(centerY + (searchHeight // 2), A_ScreenHeight)

    ; Perform PixelSearch within the defined area using fixed searchColor and tolerance
    PixelSearch, foundX, foundY, left, top, right, bottom, %DEFAULT_SEARCH_COLOR%, %colorTolerance%, Fast RGB

    ; Check if pixel was found within the defined area
    if (!ErrorLevel && foundX >= left && foundX <= right && foundY >= top && foundY <= bottom) {
        ; Apply offsets to adjust aim position
        aimX := foundX + horizontalOffset
        aimY := foundY + verticalOffset

        ; Smart aimbot logic to prevent rapid movement changes
        if (A_TickCount >= aimCooldownTimer) {
            if (Dist(aimX, aimY, lastAimX, lastAimY) >= aimResetDistance) {
                lastAimX := aimX
                lastAimY := aimY
            }
            else {
                aimX := lastAimX
                aimY := lastAimY
            }
            aimCooldownTimer := A_TickCount + aimCooldown
        }

        ; Calculate relative movement
        xRel := Round((aimX - centerX) * sensitivity) ; Use sensitivity for initial movement adjustment
        yRel := Round((aimY - centerY) * sensitivity)

        ; Move mouse relatively using mouse_event for precise control
        DllCall("mouse_event", "UInt", 0x0001, "Int", xRel, "Int", yRel, "UInt", 0, "UInt", 0)

        ; Update last aim position for next iteration
        lastAimX := aimX
        lastAimY := aimY

        ; Triggerbot firing logic
        if (triggerbotEnabled) {
            Click
        }
    }
return

; Function to calculate distance between two points
Dist(x1, y1, x2, y2) {
    return Sqrt((x2 - x1)^2 + (y2 - y1)^2)
}
