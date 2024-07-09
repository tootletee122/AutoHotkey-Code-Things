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
DEFAULT_VERTICAL_OFFSET := 2.7
DEFAULT_SENSITIVITY := 0.47

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

; Aimbot state variables
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

; FPS control variables
global targetFPS := 144  ; Target FPS
global minAimDelay := Round(1000 / targetFPS)  ; Minimum delay between aim updates in milliseconds
global lastAimUpdateTime := 0

; Create sophisticated GUI with custom styling
Gui, Color, 0x1E1E1E
Gui, Font, s12 bold, Arial

; Title
Gui, Add, Text, x10 y10 w210 h30 cFFFFFF Center vTitle, Aimbot Controller
Gui, Font, s10 italic cFFA500, Segoe UI

; Aimbot Control Section
Gui, Add, GroupBox, x10 y50 w210 h230 c00E6E6, Aimbot Settings
Gui, Font, s10 cFFFFFF, Segoe UI
Gui, Add, Text, x20 y70 w100 h20 cFFFFFF, Search Area:
Gui, Add, Text, x20 y95 w60 h20 cFFFFFF, Width:
Gui, Add, Edit, x80 y95 w60 vSearchWidth c000000, %searchWidth%
Gui, Add, Text, x20 y120 w60 h20 cFFFFFF, Height:
Gui, Add, Edit, x80 y120 w60 vSearchHeight c000000, %searchHeight%
Gui, Add, Text, x20 y145 w100 h20 cFFFFFF, Color Tolerance:
Gui, Add, Edit, x120 y145 w60 vColorTolerance c000000, %colorTolerance%
Gui, Add, Text, x20 y170 w100 h20 cFFFFFF, Horizontal Offset:
Gui, Add, Edit, x120 y170 w60 vHorizontalOffset c000000, %horizontalOffset%
Gui, Add, Text, x20 y195 w100 h20 cFFFFFF, Vertical Offset:
Gui, Add, Edit, x120 y195 w60 vVerticalOffset c000000, %verticalOffset%
Gui, Add, Text, x20 y220 w100 h20 cFFFFFF, Sensitivity:
Gui, Add, Edit, x120 y220 w60 vSensitivity c000000, %sensitivity%
Gui, Add, Button, x10 y250 w210 h30 gUpdateSettings cFFA500, Update Settings
Gui, Add, Button, x10 y290 w210 h30 gToggleAimbot vToggleButton cFFA500, Enable Aimbot
Gui, Add, Text, x10 y330 w210 h20 cFFFFFF vStatus, Aimbot Disabled

; Triggerbot Control Section
Gui, Add, GroupBox, x10 y360 w210 h30 c00E6E6, Triggerbot Settings
Gui, Font, s10 cFFFFFF, Arial
Gui, Add, Button, x10 y380 w210 h30 gToggleTriggerbot vToggleTriggerButton cFFA500, Enable Triggerbot
Gui, Add, Text, x10 y420 w210 h20 cFFFFFF vTriggerStatus, Triggerbot Disabled

; Show GUI with a custom size and title
Gui, Show, w250 h480, Aimbot Controller

; Main loop to continuously check aimbot status
SetTimer, AimbotLoop, 10  ; Set a lower interval for higher FPS

return

; Toggle aimbot function to enable/disable aimbot
ToggleAimbot:
    aimbotEnabled := !aimbotEnabled
    GuiControl,, Status, % (aimbotEnabled ? "Aimbot Enabled" : "Aimbot Disabled")
    GuiControl,, ToggleButton, % (aimbotEnabled ? "Disable Aimbot" : "Enable Aimbot")
return

; Toggle triggerbot function to enable/disable triggerbot
ToggleTriggerbot:
    triggerbotEnabled := !triggerbotEnabled
    GuiControl,, TriggerStatus, % (triggerbotEnabled ? "Triggerbot Enabled" : "Triggerbot Disabled")
    GuiControl,, ToggleTriggerButton, % (triggerbotEnabled ? "Disable Triggerbot" : "Enable Triggerbot")
return

; Update settings function to adjust aimbot parameters
UpdateSettings:
    GuiControlGet, searchWidth,, SearchWidth
    GuiControlGet, searchHeight,, SearchHeight
    GuiControlGet, colorTolerance,, ColorTolerance
    GuiControlGet, horizontalOffset,, HorizontalOffset
    GuiControlGet, verticalOffset,, VerticalOffset
    GuiControlGet, sensitivity,, Sensitivity

    ; Validate and adjust parameters to ensure they are within acceptable ranges
    searchWidth := Max(searchWidth, 1)
    searchHeight := Max(searchHeight, 1)
    colorTolerance := Max(colorTolerance, 0)
    sensitivity := Max(sensitivity, 0)

    ; Update global variables with validated settings
    global searchWidth := searchWidth
    global searchHeight := searchHeight
    global colorTolerance := colorTolerance
    global horizontalOffset := horizontalOffset
    global verticalOffset := verticalOffset
    global sensitivity := sensitivity

    ; Update GUI with validated values
    GuiControl,, SearchWidth, %searchWidth%
    GuiControl,, SearchHeight, %searchHeight%
    GuiControl,, ColorTolerance, %colorTolerance%
    GuiControl,, HorizontalOffset, %horizontalOffset%
    GuiControl,, VerticalOffset, %verticalOffset%
    GuiControl,, Sensitivity, %sensitivity%
return

; Aimbot loop function to continuously adjust aim position based on target detection
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

        ; Calculate sensitivity based on the distance to the target within the search area
        distanceX := Abs(aimX - centerX) / (searchWidth / 2)
        distanceY := Abs(aimY - centerY) / (searchHeight / 2)
        
        ; Adjust sensitivity dynamically based on distance
        sensitivityX := sensitivity * (1 + distanceX)
        sensitivityY := sensitivity * (1 + distanceY)

        ; Ensure aim updates are limited to achieve target FPS
        if (A_TickCount >= lastAimUpdateTime + minAimDelay) {
            ; Move mouse directly to the calculated aim position with adjusted sensitivity
            DllCall("mouse_event", "UInt", 0x0001, "Int", Round((aimX - centerX) * sensitivityX), "Int", Round((aimY - centerY) * sensitivityY), "UInt", 0, "UInt", 0)

            ; Update last aim position and time
            lastAimX := aimX
            lastAimY := aimY
            lastAimUpdateTime := A_TickCount
        }
        
        ; Triggerbot firing logic
        if (triggerbotEnabled) {
            Click
        }
    }
    
    ; Optimize search parameters with a cooldown
    if (A_TickCount >= optimizeCooldownTimer) {
        ; Your optimization logic here
        optimizeCooldownTimer := A_TickCount + optimizeCooldown
    }

return

; Function to calculate distance between two points
Dist(x1, y1, x2, y2) {
    return Sqrt((x2 - x1)^2 + (y2 - y1)^2)
}
