;  ________________________________________________________________________________________
; |  Created by Houdini101 (Edgecraft). You may copy, distribute, or modify this file and  |
; |  change it's code to suit your need, provided that you, as the user, will NOT ommit    |
; |  this comment box or any commentary whatsoever.                                        |
; |  Modified by RaxorX using GDIP for true AFK ability.                                   |
; |________________________________________________________________________________________|

#NoEnv	; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn		; Enable warnings to assist with detecting common errors.
SendMode InputThenPlay	; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%		; Ensures a consistent starting directory.
#Persistent
#IfWinExist Minecraft ahk_class GLFW30
#include GDip_All.ahk
#include Gdip_ImageSearch.ahk
SetWinDelay, 100
SetTitleMatchMode, RegEx
SetTitleMatchMode, Fast
CoordMode, Mouse, Client

;=============================================================================
Hotkeys: ;################################################################
;=============================================================================
Hotkey, !c, AFK_Fishing			; Alt + C : Toggle Auto-Fishing
Hotkey, !v, Auto_Attack			; Alt + V : Toggle Auto-Sweep Attack
Hotkey, !z, Portal_Calculator	; Alt + Z : Nether Portal Calculator
Hotkey, !w, SelectWindow		; Alt + W : Hover mouse/cursor over a window to select it.

;=============================================================================
GUI: ;####################################################################
;=============================================================================
dragico := ["iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeBAMAAADJHrORAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAPUExURf///wAAAAAA//8AAMDAwOb4CLIAAABeSURBVBjTY3BxVEIAYWMGRxS+MAO6vCAqYKANYEQ1mVGAkQFZQAAkL4CQhiGYNES/AIIPloTxGRmBpgmASDifEULALRdkZER4DkMeTT+6+Rj2o7sP3f0Y/kP3P/kAAIzNCke6XjS/AAAAAElFTkSuQmCC", 276]
Gui, New,, Minecraft Mini-Tool
Gui, Add, Picture, gDragger, % "HBITMAP:*" . File2hBitmap(dragico)
Gui, Add, Text, y40 x10, % "Alt + C : Toggle Auto-Fishing"
Gui, Add, Button, y37 w+50 x+42, % "Fishing"
Gui, Add, Text, y70 x10, % "Alt + V : Toggle Auto Sweep-Attack"
Gui, Add, Button, y67 w+50 x+10, % "Attack"
Gui, Add, Text, y100 x10, % "Alt + Z : Nether Portal Calculator"
Gui, Add, Button, y97 w+50 x+25, % "Portal"
Gui, Add, Button, y+10 w+59 x7, % "Help"
Gui, Add, Button, yp wp x+10, % "Hide"
Gui, Add, Button, yp wp x+10, % "Exit"
Gui, Show,, Minecraft Mini-Tool
return

GuiClose:
goto, ButtonExit

ButtonFishing:
if (WinExist("ahk_class" GLFW30) and (WinExist(Minecraft)))
	gosub, AFK_Fishing
return

ButtonAttack:
if (WinExist("ahk_class" GLFW30) and (WinExist(Minecraft)))
	gosub, Auto_Attack
return

ButtonPortal:
if (WinExist("ahk_class" GLFW30) and (WinExist(Minecraft)))
	gosub, Portal_Calculator
return

ButtonHelp:
Gui +OwnDialogs
MsgBox, , Minecraft Mini-Tool, % "Important Reminders:`n`n1. Caption (subtitle) must be turned ON in Minecraft's setting.`n`n2. GUI scale must be set to 2 in Minecraft's setting.`n`n3. To select a window either point cursor at a window and use Alt + W or use the drag and drop icon, drag it over a window to select it."
return

ButtonHide:
Gui +OwnDialogs
MsgBox, 4, Minecraft Mini-Tool, % "Hide the tool window?`n`nReminder:`n`nYou can close this tool later by right-clicking`non its tray icon then selecting exit."
IfMsgBox Yes
	Gui, Hide
return

ButtonExit:
Gui +OwnDialogs
MsgBox, 4, Minecraft Mini-Tool, % "Are you sure you want to exit?"
IfMsgBox Yes
	ExitApp
return

;=============================================================================
SelectWindow: ;###########################################################
;=============================================================================

;Get mouse/cursor position on screen and grab details of the program.
MouseGetPos, , , id, control
gosub, WindowChecker
return

;=============================================================================
Dragger: ;################################################################
;=============================================================================

DragP:
    If !(A_GuiEvent = "Normal")
        return
    SetTimer, ReleaseP, 10
return 

ReleaseP:
    if !(GetKeyState("LButton", "P")) {
	SetTimer, DragP, Off
    SetTimer, ReleaseP, Off
	MouseGetPos, , , id, control
	gosub, WindowChecker
	return
    }
return

;=============================================================================
WindowChecker: ;##########################################################
;=============================================================================

targetwinclass := "GLFW30"
targetwintitle := "Minecraft"

WinGetTitle, targettitle, ahk_id %id%
WinGetClass, targetclass, ahk_id %id%

;Check if Class of the program is a Minecraft Java Class or not.
if (InStr(targetclass, targetwinclass) and InStr(targettitle, targetwintitle)) {
	;Target program is a valid Minecraft Window.
	mchwnd := id
	Gui +OwnDialogs
	MsgBox, , Minecraft Mini-Tool, % " Target Window Title: " targettitle "`n Target Window Class: " targetclass "`n Target HWIND: " id "`n Target Window is a valid Minecraft Window."
	return
	}
else {
	;Target program is not a valid Minecraft Window.
	Gui +OwnDialogs
	MsgBox, , Minecraft Mini-Tool, % "You do not seem to have selected a Minecraft window.`nPlease select again before you can continue."
	return
	}
return

;=============================================================================
AFK_Fishing: ;############################################################
;=============================================================================

SetTimer, AutoFish, % (toggle := !toggle) ? (0) : ("Delete")
if (toggle) {
	Fishing_File := ["iVBORw0KGgoAAAANSUhEUgAAAEQAAAASCAIAAABtpu8PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACtSURBVEhL3ZbBDsAgCEP9/5/eDnpgIYWnm4nDo6vYQnG0Vmxd4epiO4QLJ3iC4TcOZEEx0zkID2zJOqG44+IdMYmW0Q/WbP6YJ6fM6XtMRbYx42iWT4L0n38vJi6izyLBq3qq6sVJVNZ97BN/lxVj80r6wTv+oMoUFPPe38S6s68oGlW+6islADW3GazkC7xGNH7QCbm1yiS/jVJi0JhwAIhPCQeQzSiUEpOJbTc2o8hirsx+9QAAAABJRU5ErkJggg==", 376]
	pToken2 := Gdip_startup()
	FishHook := Gdip_CreateBitmapFromHBITMAP(File2hBitmap(Fishing_File))
	StartTime := A_TickCount	; Logs the Start Time
	FishCount := 0
	Fish_Idle := 0
	}

ControlCheck:
SetControlDelay -1
ControlClick,, ahk_id %mchwnd%,, right,, NA	; Initial cast of the Fishing Rod

if !(toggle) {	; Alt + C was pressed again.
	gosub, Counter
	MsgBox, 0, Minecraft Mini-Tool, % "You stopped the Auto-Fishing by toggling Alt + C." Fish_Tally
	Gdip_Delete()
	}
if (toggle) and (Fish_Idle = 600) {
	toggle := 0
	gosub, Counter
	MsgBox, 0, Minecraft Mini-Tool, % "Something went wrong. Error may be caused by one of the ff. reasons:`n`n1. The required in-game settings was not met, causing the ImageSearch to fail.`n`n2. The Mouse was moved, casting the fishing rod at the wrong place.`n`n3. Failed to catch any fish within the time period." Fish_Tally
	Gdip_Delete()
	SetTimer, AutoFish, Delete
	}
Gdip_Delete() {
	Gdip_DisposeImage(SearchIn)
	Gdip_DisposeImage(FishHook)
	Gdip_Shutdown(pToken2)
	return
	}
return

AutoFish:
	SearchIn := Gdip_BitmapFromHWND(mchwnd)
	Err := Gdip_imageSearch(SearchIn, FishHook,, 0, 0, 0, 0, 40)	; Can try with coordinates for faster or less resourced processing.
	if (Err < 1) {
		Fish_Idle += 1
		sleep, 100
		if (Fish_Idle < 600) {
			Gdip_DisposeImage(SearchIn)
			return
			}
		goto, ControlCheck
		}
	else if (Err > 0) {
		sleep, 100					; A little delay before the reel-in occurs.
		SetControlDelay -1
		ControlClick,, ahk_id %mchwnd%,, right,, NA	; Reel-in the Fishing Rod
		sleep, 300
		SetControlDelay -1
		ControlClick,, ahk_id %mchwnd%,, right,, NA	; Casts the Fishing Rod again
		Fish_Idle := 0		; Resets the Fish_Idle Counter
		FishCount += 1
		Gdip_DisposeImage(SearchIn)
		sleep, 500
		}
return

Counter:
ElapsedTime := Round((A_TickCount - StartTime)/1000)
FishDuration := Convert(ElapsedTime)
Fish_Tally := "`n`nFish/Loots : " FishCount "`n`nDuration : " FishDuration
return

Convert(X_Secs)	{	; Convert Seconds to Hour:Min:Sec format. Check the end of script for alternate.
	Timer := {Hour: X_Secs//3600, Min: (Mod(X_Secs, 3600))//60, Sec: Mod(X_Secs, 60)}
	For Key in Timer
		if (Timer[Key] < 10)
			Timer[Key] := "0" Timer[Key]
	return Timer.Hour ":" Timer.Min ":" Timer.Sec
	}

;=============================================================================
Auto_Attack: ;############################################################
;=============================================================================

SetTimer, Attack, % (toggle := !toggle) ? (0) : ("Delete")
return

Attack:
	SetControlDelay, -1
	ControlClick,, % "ahk_id" id, , Left, , NA
	sleep, 630
return

;=============================================================================
Portal_Calculator: ;######################################################
;=============================================================================

KeyWait Alt
BlockInput On
Clipboard := "" 
ControlSend,, {F3 down}{c}{F3 up}, ahk_id %mchwnd%

ClipWait, 1
	if ErrorLevel {
		BlockInput Off
		return
		}

if InStr(Clipboard, "the_end", false, 23) {
	LocValid := false
	Clipboard := ""
	goto, FinalRep
	}
else LocValid := true
	
Coordinates := StrReplace(StrReplace(Clipboard, "/execute in minecraft:"), "run tp @s ")
Clipboard := ""

Loop, Parse, Coordinates, %A_Space%
	{
	if A_Index in 1,3
		continue
	if A_Index = 2
		{
		My_XPos := (Substr(A_LoopField, 1, -3)) - 0
		continue
		}
	if A_Index = 4
		{
		My_ZPos := (Substr(A_LoopField, 1, -3)) - 0
		break	
		}
	}

if InStr(Coordinates, "overworld") {
	My_World := "OverWorld"
	Other_World := "Nether"
	Other_XPos := Floor(My_XPos/8)
	Other_ZPos := Floor(My_ZPos/8)
	}		
else {
	My_World := "Nether"
	Other_World := "OverWorld"
	Other_XPos := My_XPos*8
	Other_ZPos := My_ZPos*8	
	}

FinalRep:
IsValid := "At your current " My_World " coordinate (" My_XPos ", ~, " My_ZPos "), your " Other_World " portal will be at coordinate (" Other_XPos ", ~, " Other_ZPos ")."
IsInvalid := "You are currently in End City, setting up a portal is NOT possible here, sorry. Or you have not set any portals YET."

ControlSend,, {Enter}, ahk_id %mchwnd%
sleep, 100

if LocValid = true
	ControlSend,, {Text}%IsValid%, ahk_id %mchwnd%
else
	ControlSend,, {Text}%IsInvalid%, ahk_id %mchwnd%
sleep, 100
ControlSend,, {Enter}, ahk_id %mchwnd%
BlockInput Off
return

;=============================================================================
;=Image2Include: ;########################################################
;=============================================================================
;  _______________________________________________________________________________________________________ 
; | This #Include file was generated by Image2Include.ahk created by [just me], you must not change it!   |
; | https://www.autohotkey.com/board/topic/93292-image2include-include-images-in-your-scripts/            |
; | Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN           |
; | http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257 |
; |_______________________________________________________________________________________________________|

File2hBitmap(File) {
	Static hBitmap := 0
	VarSetCapacity(B64, File.2 << !!A_IsUnicode)
	B64 := File.1
	If !(DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0))
		return False
	VarSetCapacity(Dec, DecLen, 0)
	If !(DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0))
		return False
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	return hBitmap
	}

;################################################################
;# ALTERNATE FUNCTION FOR CONVERTING SECONDS TO HH:MM:SS FORMAT #
;################################################################
;Convert(Secs) {	
;	DummyDate := 20200101	; This date is just a Duh! Me!
;	DummyDate += %Secs%, seconds
;	FormatTime, XXMin_XXSec, %DummyDate%, mm:ss
;	XXHr := Secs//3600
;	if (XXHr < 10)
;		XXHr := "0" XXHr
;	return XXHr ":" XXMin_XXSec
;	}
;################################################################
