; Created by Asger Juul Brunshøj

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force
#MaxHotkeysPerInterval 500
#WinActivateForce

;-------------------------------------------------------
; AUTO EXECUTE SECTION FOR INCLUDED SCRIPTS
; Scripts being included need to have their auto execute
; section in a function or subroutine which is then
; executed below.
;-------------------------------------------------------
Gosub, gui_autoexecute

Menu, Tray, Icon, %A_ScriptDir%\GUI\Icon.ico ; Change systray icon

;-------------------------------------------------------
; END AUTO EXECUTE SECTION
return
;-------------------------------------------------------

; Load the GUI code
#Include %A_ScriptDir%\GUI\GUI.ahk

; General settings
#Include %A_ScriptDir%\Miscellaneous\miscellaneous.ahk



;-------------------------------------------------
; reload all ahk scripts via Win and F5
; What i'm doing is sending a windows message to all the ahk programs running.
; The message is called WM_COMMAND. It is, internally in Windows, defined as the number 0x111.
; Ref: https://www.autohotkey.com/docs/misc/SendMessageList.htm
; I am sending the message 0x111 with the wParam 65303
; That wParam is what ahk interprets are "Reload"
#F5::
ReloadAllAhkScripts() {
    DetectHiddenWindows, On
    SetTitleMatchMode, 2

    WinGet, allAhkExe, List, ahk_class AutoHotkey
    Loop, % allAhkExe {
        hwnd := allAhkExe%A_Index%

        if (hwnd = A_ScriptHwnd)  ; ignore the current window for reloading
        {
            continue
        }

        PostMessage, 0x111, 65303,,, % "ahk_id" . hwnd
    }
    Reload
}

; Open Terminal
^!t::  ; Ctrl+Alt+T
    if (WinActive("ahk_exe Explorer.EXE ahk_class CabinetWClass"))
    {
        path := GetActiveExplorerPath()
        if (SubStr(path, 0) == "\") ;get last character
            path .= "\"
        path := StrReplace(path, ";", "\;") ;semicolon needs to be escaped
        Run, % "wt.exe -d """ path """"
    }
    else 
    {
        Run, % "wt.exe"
    }
return
