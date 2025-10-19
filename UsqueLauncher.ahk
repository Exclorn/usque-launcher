; --- Usque GUI Launcher ---
if !A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
Global usque_pid := 0
Gui, +AlwaysOnTop
Gui, Font, s12, Segoe UI
Gui, Add, Text, w300 Center, Usque Launcher
Gui, Font, s10
Gui, Add, Text, x12 y+20 w300, Status:
Gui, Add, Edit, x70 y-2 w220 vStatusBox ReadOnly, Disconnected
Gui, Add, Button, x50 y+20 w200 h40 gStartStop, &Start Tunnel
Gui, Show, w320 h140, Usque Launcher
GuiControl, +cRed, StatusBox
Return

StartStop:
    if (usque_pid = 0) {
        if !FileExist("usque.exe") or !FileExist("wintun.dll") {
            MsgBox, 16, Error, "usque.exe or wintun.dll not found!"
            Return
        }
        if !FileExist("config.json") {
            GuiControl,, StatusBox, Registering...
            RunWait, %ComSpec% /c usque.exe register,, Hide
        }
        Run, %ComSpec% /c usque.exe nativetun,, Hide, usque_pid
        GuiControl,, StatusBox, CONNECTED
        GuiControl, +cGreen, StatusBox
        GuiControl,, Button1, &Stop Tunnel
    } else {
        Process, Close, %usque_pid%
        usque_pid := 0
        GuiControl,, StatusBox, Disconnected
        GuiControl, +cRed, StatusBox
        GuiControl,, Button1, &Start Tunnel
    }
Return

GuiClose:
    if (usque_pid != 0) { Process, Close, %usque_pid% }
    ExitApp
