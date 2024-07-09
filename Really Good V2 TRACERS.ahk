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

; Global variable to toggle the aimbot
global aimbotEnabled := false

; Center of the screen
global centerX := A_ScreenWidth // 2
global centerY := A_ScreenHeight // 2

; Search area dimensions
global searchWidth := 400
global searchHeight := 400

; Acceleration settings
global accelerationFactor := 1.5  ; Example acceleration factor

; Tracer settings
tracerColor := 0xF000FF  ; Red color (BGR format)
tracerThickness := 2     ; Line thickness
tracerDuration := 1000   ; Duration in milliseconds

; Create GUI
Gui, Add, Button, x10 y10 w100 h30 gToggleAimbot, Toggle Aimbot (`~` hotkey)
Gui, Add, Text, x10 y50 w200 h20 vStatus, Aimbot Disabled
Gui, Add, Text, x10 y80 w100 h20, Search Width:
Gui, Add, Edit, x110 y80 w50 vSearchWidth, %searchWidth%
Gui, Add, Text, x10 y110 w100 h20, Search Height:
Gui, Add, Edit, x110 y110 w50 vSearchHeight, %searchHeight%
Gui, Show, w220 h150, Color Aimbot

; Main loop
SetTimer, AimbotLoop, 1 ; Minimal interval for fastest execution

return

; Toggle aimbot function
ToggleAimbot:
    aimbotEnabled := !aimbotEnabled
    if (aimbotEnabled) {
        GuiControl,, Status, Aimbot Enabled
    } else {
        GuiControl,, Status, Aimbot Disabled
    }
return

; Aimbot loop function
AimbotLoop:
    if (!aimbotEnabled) {
        return
    }

    ; Update search area dimensions from GUI inputs
    GuiControlGet, searchWidth, , SearchWidth
    GuiControlGet, searchHeight, , SearchHeight

    ; Calculate new search area boundaries
    left := centerX - (searchWidth // 2)
    top := centerY - (searchHeight // 2)
    right := centerX + (searchWidth // 2)
    bottom := centerY + (searchHeight // 2)

    ; Optimized screen capture and search for color
    PixelSearch, x, y, left, top, right, bottom, 0x00E6E6, 8, Fast RGB ; Searching for color 0x00E6E6 with a tolerance of 8

    if (ErrorLevel = 0) {
        ; Calculate relative movement
        xRel := x - centerX
        yRel := y - centerY

        ; Implement mouse acceleration control
        MouseMoveAccel(xRel, yRel)

        ; Implement auto-adjust sensitivity based on target distance
        AutoAdjustSensitivity(xRel, yRel)

        ; Draw tracer line
        DrawTracer(centerX, centerY, x, y, tracerColor, tracerThickness, tracerDuration)

        ; Move mouse relatively
        DllCall("mouse_event", "UInt", 0x0001, "Int", xRel, "Int", yRel, "UInt", 0, "UInt", 0)
    }
return

; Function to draw a tracer line
DrawTracer(x1, y1, x2, y2, color, thickness, duration) {
    ; Draw line using DllCall to user32.dll DrawLine
    DllCall("gdi32.dll\SetROP2", "UInt", 7, "Ptr", 0)  ; R2_COPYPEN mode

    hDC := DllCall("GetDC", "Ptr", 0)

    ; Create a pen
    pen := DllCall("CreatePen", "UInt", 0, "Int", thickness, "UInt", color, "Ptr", 0)

    ; Select the pen into the device context
    DllCall("SelectObject", "Ptr", hDC, "Ptr", pen)

    ; Draw the line
    DllCall("MoveToEx", "Ptr", hDC, "Int", x1, "Int", y1, "Ptr", 0)
    DllCall("LineTo", "Ptr", hDC, "Int", x2, "Int", y2)

    ; Clean up
    DllCall("DeleteObject", "Ptr", pen)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    ; Remove tracer after duration
    SetTimer, RemoveTracer, % duration
    return

    RemoveTracer:
        ; Redraw the line to erase it
        DllCall("gdi32.dll\SetROP2", "UInt", 7, "Ptr", 0)  ; R2_COPYPEN mode

        hDC := DllCall("GetDC", "Ptr", 0)

        ; Create a pen with a black color to erase
        pen := DllCall("CreatePen", "UInt", 0, "Int", thickness, "UInt", 0x000000, "Ptr", 0)

        ; Select the pen into the device context
        DllCall("SelectObject", "Ptr", hDC, "Ptr", pen)

        ; Redraw the line to erase it
        DllCall("MoveToEx", "Ptr", hDC, "Int", x1, "Int", y1, "Ptr", 0)
        DllCall("LineTo", "Ptr", hDC, "Int", x2, "Int", y2)

        ; Clean up
        DllCall("DeleteObject", "Ptr", pen)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
        
        return
}

; Function to control mouse acceleration
MouseMoveAccel(xRel, yRel) {
    ; Example: Apply acceleration factor to movement
    xRel := Round(xRel * accelerationFactor)
    yRel := Round(yRel * accelerationFactor)
    
    ; Return adjusted values
    return {x: xRel, y: yRel}
}

; Function to auto-adjust sensitivity based on target distance
AutoAdjustSensitivity(xRel, yRel) {
    ; Example: Calculate distance from center (hypothetical)
    distance := Round(Sqrt(xRel**2 + yRel**2))
    
    ; Example: Adjust sensitivity based on distance
    if (distance > 200) {
        accelerationFactor := 2  ; Increase sensitivity for distant targets
    } else {
        accelerationFactor := 1  ; Default sensitivity
    }
}
