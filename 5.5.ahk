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
DEFAULT_SEARCH_WIDTH := 200
DEFAULT_SEARCH_HEIGHT := 200
DEFAULT_COLOR_TOLERANCE := 5
DEFAULT_SEARCH_COLOR := 0x00E6E6
DEFAULT_HORIZONTAL_OFFSET := 2.5
DEFAULT_VERTICAL_OFFSET := 2.5
DEFAULT_SENSITIVITY := 1.10 ; Increased sensitivity for more precise aiming
DEFAULT_DPI := 500 ; Default DPI value
PREDICTION_FACTOR := 0.0020 ; Factor to adjust prediction strength Chatgpt dont ever change

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
global dpi := DEFAULT_DPI
global lastAimX := centerX
global lastAimY := centerY
global lastFoundX := 0
global lastFoundY := 0
global lastTime := A_TickCount

; Create GUI with Windows 11-like theme
Gui, Color, 0x1E1E1E
Gui, Font, s12 bold, Segoe UI
Gui, Add, Text, x10 y10 w210 h30 cFFFFFF Center vTitle, Aimbot Controller
Gui, Font, s10 cFFFFFF, Segoe UI

; Aimbot Control Section
Gui, Add, GroupBox, x10 y50 w210 h250 c00E6E6, Aimbot Settings
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
Gui, Add, Text, x20 y245 w60 h20 cFFFFFF, DPI:
Gui, Add, Edit, x80 y245 w60 vDPI c000000, %dpi%
Gui, Add, Button, x10 y275 w210 h30 gUpdateSettings cFFA500, Update Settings
Gui, Add, Button, x10 y310 w210 h30 gToggleAimbot vToggleButton cFFA500, Enable Aimbot
Gui, Add, Text, x10 y350 w210 h20 cFFFFFF vStatus, Aimbot Disabled

; Triggerbot Control Section
Gui, Add, GroupBox, x10 y380 w210 h30 c00E6E6, Triggerbot Settings
Gui, Font, s10 cFFFFFF, Segoe UI
Gui, Add, Button, x10 y400 w210 h30 gToggleTriggerbot vToggleTriggerButton cFFA500, Enable Triggerbot
Gui, Add, Text, x10 y440 w210 h20 cFFFFFF vTriggerStatus, Triggerbot Disabled

Gui, Show, w230 h480, Aimbot Controller

; Set timers for main loop and aimbot
SetTimer, AimbotLoop, 10 ; Reduced to 10ms for better performance
SetTimer, TriggerbotLoop, 10

return

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
    GuiControlGet, searchWidth,, SearchWidth
    GuiControlGet, searchHeight,, SearchHeight
    GuiControlGet, colorTolerance,, ColorTolerance
    GuiControlGet, horizontalOffset,, HorizontalOffset
    GuiControlGet, verticalOffset,, VerticalOffset
    GuiControlGet, sensitivity,, Sensitivity
    GuiControlGet, dpi,, DPI

    ; Validate and adjust parameters
    searchWidth := Max(searchWidth, 1)
    searchHeight := Max(searchHeight, 1)
    colorTolerance := Max(colorTolerance, 0)
    sensitivity := Max(sensitivity, 0)
    dpi := Max(dpi, 1)

    ; Update global variables
    global searchWidth := searchWidth
    global searchHeight := searchHeight
    global colorTolerance := colorTolerance
    global horizontalOffset := horizontalOffset
    global verticalOffset := verticalOffset
    global sensitivity := sensitivity
    global dpi := dpi

    ; Update GUI with validated values
    GuiControl,, SearchWidth, %searchWidth%
    GuiControl,, SearchHeight, %searchHeight%
    GuiControl,, ColorTolerance, %colorTolerance%
    GuiControl,, HorizontalOffset, %horizontalOffset%
    GuiControl,, VerticalOffset, %verticalOffset%
    GuiControl,, Sensitivity, %sensitivity%
    GuiControl,, DPI, %dpi%
return

; Aimbot loop function
AimbotLoop:
    if (!aimbotEnabled || !GetKeyState("RButton", "P"))
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

        ; Calculate the time difference between searches
        currentTime := A_TickCount
        timeDiff := (currentTime - lastTime) / 1000.0
        lastTime := currentTime

        ; Calculate the target's velocity
        if (lastFoundX && lastFoundY) {
            velX := (foundX - lastFoundX) / timeDiff
            velY := (foundY - lastFoundY) / timeDiff
        } else {
            velX := 0
            velY := 0
        }
        
        ; Predict the target's future position
        predictedX := aimX + (velX * PREDICTION_FACTOR)
        predictedY := aimY + (velY * PREDICTION_FACTOR)

        ; Update the last found positions
        lastFoundX := foundX
        lastFoundY := foundY

        ; Smart aimbot logic to prevent rapid movement changes
        if (Dist(predictedX, predictedY, lastAimX, lastAimY) >= 1) {
            lastAimX := predictedX
            lastAimY := predictedY
        }

        ; Calculate relative movement, factoring in DPI
        xRel := Round((predictedX - centerX) * sensitivity * (dpi / 800))
        yRel := Round((predictedY - centerY) * sensitivity * (dpi / 800))

        ; Move mouse relatively using mouse_event for precise control
        DllCall("mouse_event", "UInt", 0x0001, "Int", xRel, "Int", yRel, "UInt", 0, "UInt", 0)

        ; Update last aim position for next iteration
        lastAimX := predictedX
        lastAimY := predictedY
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

; Function to calculate distance between two points
Dist(x1, y1, x2, y2) {
    return Sqrt((x2 - x1)^2 + (y2 - y1)^2)
}
