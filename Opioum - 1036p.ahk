; Initialization and Environment Setup
#NoEnv
#MaxHotkeysPerInterval 127
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, Force

; Initial Screen Coordinates
FirX := 200
FirY := 200

; Screen Mid Coordinates
MidX := A_ScreenWidth / 2
MidY := A_ScreenHeight / 2

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

; Coordinate Mode Settings
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; Aim and Sensitivity Variables
aim1 := 0x0000E6
aim2 := 0x0000E6
variation := 8
searchArea := 150
Sense := 0.15
FovSense := 0.15
TriggerSense := 5.75
Smoothing := 4.75
OSDEnabled := 1
TrueColorAimbotEnabled := 0

; Movement Options
MovementOptions := ["None", "Jump Only", "Crouch Only", "Jump & Crouch", "Strafe Left", "Strafe Right", "Forward", "Backward", "Circle Left", "Circle Right", "Diagonal Forward Left", "Diagonal Forward Right", "Diagonal Backward Left", "Diagonal Backward Right", "Random Jump", "Random Crouch", "Step Left", "Step Right", "Step Forward", "Step Backward", "Rotate Left", "Rotate Right", "Rotate Up", "Rotate Down"]
SelectedMovementOption := "None"

; Aiming Styles
AimingStyles := ["Standard", "Smooth", "Fast", "Precise", "Aggressive", "Random", "Predictive", "Sniper", "Spray", "Burst", "Steady", "Recoil Control", "Tracking", "Micro Adjustment", "Macro Adjustment", "Gradual", "Sudden", "Wave", "Zigzag", "Jitter", "Spiral", "Random Precise", "Random Aggressive", "Counter Recoil", "Drag Shot", "Hit Scan", "Sharp Shooter", "Rapid Fire", "Slow Fire", "Auto Aim"]
SelectedAimingStyle := "Gradual"

; GUI Theme Variables
GuiThemes := {}
GuiThemes["Dark"] := {"Color": "0x1C1C1C", "FontColor": "cFF00FF"}
GuiThemes["Light"] := {"Color": "0xFFFFFF", "FontColor": "c000000"}
GuiThemes["Blue"] := {"Color": "0x0000FF", "FontColor": "cFFFFFF"}
GuiThemes["Red"] := {"Color": "0xFF0000", "FontColor": "cFFFFFF"}
GuiThemes["Green"] := {"Color": "0x00FF00", "FontColor": "c000000"}
GuiThemes["Yellow"] := {"Color": "0xFFFF00", "FontColor": "c000000"}
GuiThemes["Purple"] := {"Color": "0x800080", "FontColor": "cFFFFFF"}
GuiThemes["Orange"] := {"Color": "0xFFA500", "FontColor": "c000000"}
GuiThemes["Pink"] := {"Color": "0xFFC0CB", "FontColor": "c000000"}
GuiThemes["Teal"] := {"Color": "0x008080", "FontColor": "cFFFFFF"}
GuiThemes["Lime"] := {"Color": "0x00FF00", "FontColor": "c000000"}
GuiThemes["Cyan"] := {"Color": "0x00FFFF", "FontColor": "c000000"}
GuiThemes["Magenta"] := {"Color": "0xFF00FF", "FontColor": "cFFFFFF"}
GuiThemes["Silver"] := {"Color": "0xC0C0C0", "FontColor": "c000000"}
GuiThemes["Maroon"] := {"Color": "0x800000", "FontColor": "cFFFFFF"}
GuiThemes["Olive"] := {"Color": "0x808000", "FontColor": "cFFFFFF"}
GuiThemes["Navy"] := {"Color": "0x000080", "FontColor": "cFFFFFF"}
GuiThemes["Gold"] := {"Color": "0xFFD700", "FontColor": "c000000"}
GuiThemes["Brown"] := {"Color": "0xA52A2A", "FontColor": "cFFFFFF"}
GuiThemes["Coral"] := {"Color": "0xFF7F50", "FontColor": "cFFFFFF"}
GuiThemes["Khaki"] := {"Color": "0xF0E68C", "FontColor": "c000000"}
GuiThemes["Lavender"] := {"Color": "0xE6E6FA", "FontColor": "c000000"}
GuiThemes["Mint"] := {"Color": "0x98FF98", "FontColor": "c000000"}
GuiThemes["Peach"] := {"Color": "0xFFE5B4", "FontColor": "c000000"}
GuiThemes["Salmon"] := {"Color": "0xFA8072", "FontColor": "c000000"}
GuiThemes["Sky Blue"] := {"Color": "0x87CEEB", "FontColor": "c000000"}
GuiThemes["Slate"] := {"Color": "0x708090", "FontColor": "cFFFFFF"}
GuiThemes["Tan"] := {"Color": "0xD2B48C", "FontColor": "c000000"}
GuiThemes["Turquoise"] := {"Color": "0x40E0D0", "FontColor": "c000000"}
GuiThemes["Violet"] := {"Color": "0xEE82EE", "FontColor": "c000000"}
GuiThemes["Wheat"] := {"Color": "0xF5DEB3", "FontColor": "c000000"}
GuiThemes["EngineOwning"] := {"Color": "0x515151", "FontColor": "cF7F7F7"}

CurrentTheme := "EngineOwning"

; Set GUI Theme
SetGuiTheme(CurrentTheme)

; Custom Title Bar
Gui, -Caption -ToolWindow -AlwaysOnTop
Gui, Font, s11, Verdana
Gui, Add, Text, x-120 y10 w320 h30 Center BackgroundTrans cYellow, Opioum
Gui, Add, Text, x90 y146 w20 h20 Center BackgroundTrans cFuchsia, >>
Gui, Add, Text, x55 y30 w20 h20 Center BackgroundTrans cLime gLeDrag,
Gui, Add, Text, x60 y30 w20 h20 Center BackgroundTrans cFuchsia, D|
Gui, Add, Text, x20 y30 w20 h20 Center BackgroundTrans cFuchsia gRestartScript, |R|
Gui, Add, Text, x40 y30 w20 h20 Center BackgroundTrans cFuchsia gCloseGUI, X|

; Tabs Setup
Gui, Add, Tab2, x10 y50 w90 h390 vMainTab BackgroundTrans, Toggles|Settings|Themes|Movement|Aimbot

; Settings Tab
Gui, Tab, Settings
Gui, Font, s10, Verdana
Gui, Add, Text, x120 y20 w320 h30 Center BackgroundTrans cYellow, Lower Number = Higher Value
Gui, Add, Edit, x140 y50 w80 vSenseInput Number, %Sense%
Gui, Add, Button, x370 y50 w50 gApplySense, Apply
Gui, Add, Text, x140 y80 w300 vSenLabel, Aim Sensitivity: %Sense%
Gui, Add, Edit, x140 y110 w80 vFovSenseInput Number, %FovSense%
Gui, Add, Button, x370 y110 w50 gApplyFov, Apply
Gui, Add, Text, x140 y140 w300 vFovLabel, Sensitivity Smoothing: %FovSense%
Gui, Add, Edit, x140 y170 w80 vTriggerSenseInput Number, %TriggerSense%
Gui, Add, Button, x370 y170 w50 gApplyTrigger, Apply
Gui, Add, Text, x140 y200 w300 vTriggerLabel, Trigger Sensitivity: %TriggerSense%
Gui, Add, Edit, x140 y230 w80 vSearchAreaInput Number, %searchArea%
Gui, Add, Button, x370 y230 w50 gApplySearchArea, Apply
Gui, Add, Text, x140 y260 w300 vSearchAreaLabel, Search Area: %searchArea%
Gui, Add, Edit, x140 y290 w80 vSmoothingInput Number, %Smoothing%
Gui, Add, Button, x370 y290 w50 gApplySmoothing, Apply
Gui, Add, Text, x140 y320 w300 vSmoothingLabel, Aim Smoothing: %Smoothing%
Gui, Add, Hotkey, x140 y350 w80 vAimbotHotkey, RButton
Gui, Add, Button, x370 y350 w50 gApplyAimbotHotkey, Apply
Gui, Add, Text, x140 y380 w300 vAimbotHotkeyLabel, Aimbot Hotkey: RButton

; Toggles Tab
Gui, Tab, Toggles
Gui, Font, s10, Verdana
Gui, Add, Checkbox, x140 y50 w300 gFovBox vFov, Fov Box (1036p)
Gui, Add, Checkbox, x140 y80 w300 vTriggerbot, Triggerbot
Gui, Add, Checkbox, x140 y110 w300 gToggleOSD vOSDEnabled Checked, Enable OSD
Gui, Add, Checkbox, x140 y140 w300 gToggleBHop vBHop, BHop (45ms)
Gui, Add, Checkbox, x140 y170 w300 gDualAimbot vDualAimbot, Dual Aimbot
Gui, Add, Checkbox, x140 y200 w300 gToggleTrueColorAimbot vTrueColorAimbot, True Color Aimbot
Gui, Add, Button, x140 y230 w300 gCreds, CREDITS

; Themes Tab
Gui, Tab, Themes
Gui, Font, s10, Verdana
Gui, Add, Text, x140 y50 w100, Select Theme:
Gui, Add, Text, x200 y20 w170 cYellow, Default is EngineOwning
Gui, Add, DropDownList, x240 y50 w100 vThemeDropDown gApplyTheme, % "Dark|Light|Blue|Red|Green|Yellow|Purple|Orange|Pink|Teal|Lime|Cyan|Magenta|Silver|Maroon|Olive|Navy|Gold|Brown|Coral|Khaki|Lavender|Mint|Peach|Salmon|Sky Blue|Slate|Tan|Turquoise|Violet|Wheat|EngineOwning"

; Movement Tab
Gui, Tab, Movement
Gui, Font, s10, Verdana
Gui, Add, Text, x140 y50 w100, Select Movement:
Gui, Add, Text, x200 y20 w170 cYellow, Default is None
Gui, Add, DropDownList, x240 y50 w150 vMovementOption gApplyMovementOption, % "None|Jump Only|Crouch Only|Jump & Crouch|Strafe Left|Strafe Right|Forward|Backward|Circle Left|Circle Right|Diagonal Forward Left|Diagonal Forward Right|Diagonal Backward Left|Diagonal Backward Right|Random Jump|Random Crouch|Step Left|Step Right|Step Forward|Step Backward|Rotate Left|Rotate Right|Rotate Up|Rotate Down"

; Aimbot Tab
Gui, Tab, Aimbot
Gui, Font, s10, Verdana
Gui, Add, Text, x140 y50 w100, Select Aiming Style:
Gui, Add, Text, x200 y20 w170 cYellow, Default is Gradual
Gui, Add, DropDownList, x240 y50 w150 vAimingStyle gApplyAimingStyle, % "Standard|Smooth|Fast|Precise|Aggressive|Random|Predictive|Sniper|Spray|Burst|Steady|Recoil Control|Tracking|Micro Adjustment|Macro Adjustment|Gradual|Sudden|Wave|Zigzag|Jitter|Spiral|Random Precise|Random Aggressive|Counter Recoil|Drag Shot|Hit Scan|Sharp Shooter|Rapid Fire|Slow Fire|Auto Aim"

; Main Gui Section
Gui, Tab
Gui, Show, x%FirX% y%FirY% w500 h450, Opioum
WinSet, Region, 0-0 500-0 500-450 0-450 0-0 w500 h450 R40-40, Opioum

; On-Screen Display (OSD) Setup
MyColor := 0xCB3031
Gui OSD:+LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, OSD:Color, %MyColor%
Gui, OSD:Font, s26, Lucida Console
Gui, OSD:Add, Text, vMyText cYellow, Opioum
WinSet, TransColor, %MyColor% 155
if (OSDEnabled) {
    Gui, OSD:Show, x0 y0 NoActivate
}

; Set Timer for FOV Box Update
SetTimer, UpdateFovBox, 002

; Initial Aimbot Hotkey Setup
AimbotHotkey := "RButton"
Hotkey, %AimbotHotkey%, Aimbot, On
Hotkey, %AimbotHotkey% Up, AimbotUp, On

return

; Aimbot Functionality
Aimbot:
Gui, Submit, NoHide
While GetKeyState(AimbotHotkey, "P") {
    searchAreaHalf := searchArea / 2
    PixelSearch, TargetX, TargetY, MidX-searchAreaHalf, MidY-searchAreaHalf, MidX+searchAreaHalf, MidY+searchAreaHalf, aim1, variation, Fast RGB
    If (ErrorLevel = 0) {
        if (TrueColorAimbotEnabled) {
            ; Directly move to the target without sensitivity adjustments
            MoveX := TargetX - MidX
            MoveY := TargetY - MidY
            DllCall("mouse_event", UInt, 1, Int, MoveX, Int, MoveY, UInt, 0, UInt, 0)
        } else {
            distance := Sqrt((TargetX - MidX)**2 + (TargetY - MidY)**2)
            ; Dynamic Sensitivity Calculation
            if (distance < 50) {
                dynamicSense := 0.75
            } else if (distance < 100) {
                dynamicSense := 0.55
            } else {
                dynamicSense := Sense
            }
            MoveX := (TargetX - MidX) / dynamicSense
            MoveY := (TargetY - MidY) / dynamicSense

            ; Apply aiming style
            if (SelectedAimingStyle = "Standard") {
                ; Do nothing, use default values
            } else if (SelectedAimingStyle = "Smooth") {
                MoveX := MoveX / 2
                MoveY := MoveY / 2
            } else if (SelectedAimingStyle = "Fast") {
                MoveX := MoveX * 2
                MoveY := MoveY * 2
            } else if (SelectedAimingStyle = "Precise") {
                MoveX := MoveX / 3
                MoveY := MoveY / 3
            } else if (SelectedAimingStyle = "Aggressive") {
                MoveX := MoveX * 1.5
                MoveY := MoveY * 1.5
            } else if (SelectedAimingStyle = "Random") {
                Random, randX, -5, 5
                Random, randY, -5, 5
                MoveX := MoveX + randX
                MoveY := MoveY + randY
            } else if (SelectedAimingStyle = "Predictive") {
                ; Predictive logic can be more complex, for now using a simple multiplier
                MoveX := MoveX * 0.9
                MoveY := MoveY * 0.9
            } else if (SelectedAimingStyle = "Sniper") {
                MoveX := MoveX / 5
                MoveY := MoveY / 5
            } else if (SelectedAimingStyle = "Spray") {
                Random, sprayX, -10, 10
                Random, sprayY, -10, 10
                MoveX := MoveX + sprayX
                MoveY := MoveY + sprayY
            } else if (SelectedAimingStyle = "Burst") {
                Random, burstX, -3, 3
                Random, burstY, -3, 3
                MoveX := MoveX + burstX
                MoveY := MoveY + burstY
            } else if (SelectedAimingStyle = "Steady") {
                MoveX := MoveX * 0.8
                MoveY := MoveY * 0.8
            } else if (SelectedAimingStyle = "Recoil Control") {
                MoveX := MoveX / 4
                MoveY := MoveY / 4
            } else if (SelectedAimingStyle = "Tracking") {
                ; Tracking logic can be added here
                MoveX := MoveX
                MoveY := MoveY
            } else if (SelectedAimingStyle = "Micro Adjustment") {
                MoveX := MoveX / 10
                MoveY := MoveY / 10
            } else if (SelectedAimingStyle = "Macro Adjustment") {
                MoveX := MoveX * 5
                MoveY := MoveY * 5
            } else if (SelectedAimingStyle = "Gradual") {
                MoveX := MoveX * 0.7
                MoveY := MoveY * 0.7
            } else if (SelectedAimingStyle = "Sudden") {
                MoveX := MoveX * 3
                MoveY := MoveX * 3
            } else if (SelectedAimingStyle = "Wave") {
                ; Wave pattern logic
                MoveX := MoveX + Sin(A_TickCount / 10) * 5
                MoveY := MoveY + Cos(A_TickCount / 10) * 5
            } else if (SelectedAimingStyle = "Zigzag") {
                ; Zigzag pattern logic
                MoveX := MoveX + ((A_TickCount // 20) + 2 = 0 ? 10 : -10)
                MoveY := MoveY + ((A_TickCount // 20) + 2 = 0 ? -10 : 10)
            } else if (SelectedAimingStyle = "Jitter") {
                ; Jitter pattern logic
                Random, jitterX, -10, 10
                Random, jitterY, -10, 10
                MoveX := MoveX + jitterX
                MoveY := MoveY + jitterY
            } else if (SelectedAimingStyle = "Spiral") {
                ; Spiral pattern logic
                MoveX := MoveX + Sin(A_TickCount / 10) * 10
                MoveY := MoveY + Cos(A_TickCount / 10) * 10
            } else if (SelectedAimingStyle = "Random Precise") {
                Random, randX, -1, 1
                Random, randY, -1, 1
                MoveX := MoveX + randX
                MoveY := MoveY + randY
            } else if (SelectedAimingStyle = "Random Aggressive") {
                Random, randX, -15, 15
                Random, randY, -15, 15
                MoveX := MoveX + randX
                MoveY := MoveY + randY
            } else if (SelectedAimingStyle = "Counter Recoil") {
                ; Counter recoil logic
                MoveX := MoveX - Sin(A_TickCount / 10) * 5
                MoveY := MoveY - Cos(A_TickCount / 10) * 5
            } else if (SelectedAimingStyle = "Drag Shot") {
                MoveX := MoveX * 1.2
                MoveY := MoveY * 1.2
            } else if (SelectedAimingStyle = "Hit Scan") {
                MoveX := MoveX * 0.5
                MoveY := MoveY * 0.5
            } else if (SelectedAimingStyle = "Sharp Shooter") {
                MoveX := MoveX * 2.5
                MoveY := MoveY * 2.5
            } else if (SelectedAimingStyle = "Rapid Fire") {
                ; Rapid fire logic
                MoveX := MoveX * 3
                MoveY := MoveY * 3
            } else if (SelectedAimingStyle = "Slow Fire") {
                ; Slow fire logic
                MoveX := MoveX * 0.3
                MoveY := MoveX * 0.3
            } else if (SelectedAimingStyle = "Auto Aim") {
                ; Auto aim logic
                MoveX := MoveX * 0.9
                MoveY := MoveY * 0.9
            }

            MoveX := MoveX / Smoothing
            MoveY := MoveY / Smoothing
            DllCall("mouse_event", UInt, 1, Int, MoveX, Int, MoveY, UInt, 0, UInt, 0)
        }
        if (Triggerbot = 1) {
            Click, down
        }
        if (SelectedMovementOption = "Jump Only") {
            Sleep, 20
            Send, {Space}
        } else if (SelectedMovementOption = "Crouch Only") {
            Sleep, 20
            Send, {C}
        } else if (SelectedMovementOption = "Jump & Crouch") {
            Send, {Space}
            Sleep, 85
            Send, {C}
        } else if (SelectedMovementOption = "Strafe Left") {
            Send, {A}
        } else if (SelectedMovementOption = "Strafe Right") {
            Send, {D}
        } else if (SelectedMovementOption = "Forward") {
            Send, {W}
        } else if (SelectedMovementOption = "Backward") {
            Send, {S}
        } else if (SelectedMovementOption = "Circle Left") {
            Send, {A down}
            Sleep, 100
            Send, {W down}
            Sleep, 100
            Send, {A up}
            Sleep, 100
            Send, {W up}
        } else if (SelectedMovementOption = "Circle Right") {
            Send, {D down}
            Sleep, 100
            Send, {W down}
            Sleep, 100
            Send, {D up}
            Sleep, 100
            Send, {W up}
        } else if (SelectedMovementOption = "Diagonal Forward Left") {
            Send, {W down}
            Sleep, 20
            Send, {A down}
            Sleep, 20
            Send, {W up}
            Send, {A up}
        } else if (SelectedMovementOption = "Diagonal Forward Right") {
            Send, {W down}
            Sleep, 20
            Send, {D down}
            Sleep, 20
            Send, {W up}
            Send, {D up}
        } else if (SelectedMovementOption = "Diagonal Backward Left") {
            Send, {S down}
            Sleep, 20
            Send, {A down}
            Sleep, 20
            Send, {S up}
            Send, {A up}
        } else if (SelectedMovementOption = "Diagonal Backward Right") {
            Send, {S down}
            Sleep, 20
            Send, {D down}
            Sleep, 20
            Send, {S up}
            Send, {D up}
        } else if (SelectedMovementOption = "Random Jump") {
            Random, randJump, 1, 100
            if (randJump > 50) {
                Send, {Space}
            }
        } else if (SelectedMovementOption = "Random Crouch") {
            Random, randCrouch, 1, 100
            if (randCrouch > 50) {
                Send, {C}
            }
        } else if (SelectedMovementOption = "Step Left") {
            Send, {A}
            Sleep, 50
            Send, {A}
        } else if (SelectedMovementOption = "Step Right") {
            Send, {D}
            Sleep, 50
            Send, {D}
        } else if (SelectedMovementOption = "Step Forward") {
            Send, {W}
            Sleep, 50
            Send, {W}
        } else if (SelectedMovementOption = "Step Backward") {
            Send, {S}
            Sleep, 50
            Send, {S}
        } else if (SelectedMovementOption = "Rotate Left") {
            DllCall("mouse_event", UInt, 1, Int, -10, Int, 0, UInt, 0, UInt, 0)
        } else if (SelectedMovementOption = "Rotate Right") {
            DllCall("mouse_event", UInt, 1, Int, 10, Int, 0, UInt, 0, UInt, 0)
        } else if (SelectedMovementOption = "Rotate Up") {
            DllCall("mouse_event", UInt, 1, Int, 0, Int, -10, UInt, 0, UInt, 0)
        } else if (SelectedMovementOption = "Rotate Down") {
            DllCall("mouse_event", UInt, 1, Int, 0, Int, 10, UInt, 0, UInt, 0)
        }
    }
    if (DualAimbot = 1) {
        PixelSearch, TargetX2, TargetY2, MidX-searchAreaHalf, MidY-searchAreaHalf, MidX+searchAreaHalf, MidY+searchAreaHalf, aim2, variation, Fast RGB
        If (ErrorLevel = 0) {
            distance2 := Sqrt((TargetX2 - MidX)**2 + (TargetY2 - MidY)**2)
            if (distance2 < 50) {
                dynamicSense2 := 0.55
            } else if (distance2 < 100) {
                dynamicSense2 := 0.75
            } else {
                dynamicSense2 := Sense
            }
            MoveX2 := (TargetX2 - MidX) / dynamicSense2
            MoveY2 := (TargetY2 - MidY) / dynamicSense2
            MoveX2 := MoveX2 / Smoothing
            MoveY2 := MoveY2 / Smoothing
            DllCall("mouse_event", UInt, 1, Int, MoveX2, Int, MoveY2, UInt, 0, UInt, 0)
        }
    }
}
return

AimbotUp:
if (Triggerbot = 1) {
    Click, up
}
return

; Apply Movement Option
ApplyMovementOption:
Gui, Submit, NoHide
SelectedMovementOption := MovementOption
return

; Apply Aiming Style
ApplyAimingStyle:
Gui, Submit, NoHide
SelectedAimingStyle := AimingStyle
return

; Credits Display
Creds:
Msgbox, 0, Opioum Made By: Khris, HackerHansen and Leplix!
return

; Apply Functions for Settings
ApplySense:
Gui, Submit, NoHide
Sense := SenseInput
GuiControl,, SenLabel, Aim Sensitivity: %Sense%
return

ApplyFov:
Gui, Submit, NoHide
FovSense := FovSenseInput
GuiControl,, FovLabel, Sensitivity Smoothing: %FovSense%
return

ApplyTrigger:
Gui, Submit, NoHide
TriggerSense := TriggerSenseInput
GuiControl,, TriggerLabel, Trigger Sensitivity: %TriggerSense%
return

ApplySearchArea:
Gui, Submit, NoHide
searchArea := SearchAreaInput
GuiControl,, SearchAreaLabel, Search Area: %searchArea%
return

ApplySmoothing:
Gui, Submit, NoHide
Smoothing := SmoothingInput
GuiControl,, SmoothingLabel, Aim Smoothing: %Smoothing%
return

ApplyAimbotHotkey:
Gui, Submit, NoHide
Hotkey, %AimbotHotkey%, Aimbot, Off
Hotkey, %AimbotHotkey% Up, AimbotUp, Off
Hotkey, %AimbotHotkey%, Aimbot, On
Hotkey, %AimbotHotkey% Up, AimbotUp, On
GuiControl,, AimbotHotkeyLabel, Aimbot Hotkey: %AimbotHotkey%
return

; Apply Theme Function
ApplyTheme:
Gui, Submit, NoHide
CurrentTheme := ThemeDropDown
SetGuiTheme(CurrentTheme)
return

; Toggle OSD Display
ToggleOSD:
Gui, Submit, NoHide
if (OSDEnabled) {
    Gui, OSD:Show, x0 y0 NoActivate
} else {
    Gui, OSD:Hide
}
return

ToggleBHop:
Gui, Submit, NoHide
if (BHop == 1) {
    SetTimer, CheckBHop, 45
} else {
    SetTimer, CheckBHop, Off
}
return

CheckBHop:
if (GetKeyState("w", "P")) {
    SendInput, {Space}
}
return

; Toggle True Color Aimbot
ToggleTrueColorAimbot:
Gui, Submit, NoHide
TrueColorAimbotEnabled := TrueColorAimbot
return

; Dual Aimbot Functionality
DualAimbot:
Gui, Submit, NoHide
if (DualAimbot == 1) {
    ; Enable dual aimbot functionality
} else {
    ; Disable dual aimbot functionality
}
return

; Close GUI
CloseGUI:
ExitApp

; Restart Script
RestartScript:
Reload
return

; Drag Functionality for Custom Title Bar
LeDrag:
PostMessage, 0xA1, 2,,, A
return

; FOV Box Functions
FovBox:
Gui, Submit, NoHide
if (Fov == 1) {
    CreateBox("01FF01")
} else {
    RemoveBox()
}
return

UpdateFovBox:
if (Fov == 1) {
    RemoveBox()
    searchAreaHalf := searchArea / 2
    Box(MidX - searchAreaHalf, MidY - searchAreaHalf, searchArea, searchArea, 1, 0)
}
return

; Box Creation and Removal Functions
CreateBox(Color) {
    Gui 81:color, %Color%
    Gui 81:+ToolWindow -SysMenu -Caption +AlwaysOnTop
    Gui 82:color, %Color%
    Gui 82:+ToolWindow -SysMenu -Caption +AlwaysOnTop
    Gui 83:color, %Color%
    Gui 83:+ToolWindow -SysMenu -Caption +AlwaysOnTop
    Gui 84:color, %Color%
    Gui 84:+ToolWindow -SysMenu -Caption +AlwaysOnTop
}

Box(XCor, YCor, Width, Height, Thickness, Offset) {
    Side := (InStr(Offset, "In") ? -1 : 1)
    StringTrimLeft, offset, offset, (Side == -1 ? 2 : 3)
    if !Offset
        Offset := 0

    x := XCor - (Side + 1) / 2 * Thickness - Side * Offset
    y := YCor - (Side + 1) / 2 * Thickness - Side * Offset
    h := Height + Side * thickness + Side * offset * 2
    w := thickness
    Gui 81:Show, x%x% y%y% w%w% h%h% NA
    x += thickness
    w := Width + Side * thickness + Side * offset * 2
    h := thickness
    Gui 82:Show, x%x% y%y% w%w% h%h% NA
    x := x + w - thickness
    y += thickness
    h := Height + Side * thickness + Side * offset * 2
    w := thickness
    Gui 83:Show, x%x% y%y% w%w% h%h% NA
    x := XCor - (Side + 1) / 2 * thickness - Side * offset
    y += h - thickness
    w := Width + Side + thickness + Side + offset * 2
    h := thickness
    Gui 84:Show, x%x% y%y% w%w% h%h% NA
}

RemoveBox() {
    Gui 81:destroy
    Gui 82:destroy
    Gui 83:destroy
    Gui 84:destroy
}

; Set GUI Theme
SetGuiTheme(Theme) {
    global GuiThemes
    Gui, Font, % GuiThemes[Theme].FontColor
    Gui, Color, % GuiThemes[Theme].Color
}
