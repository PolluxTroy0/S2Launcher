#AutoIt3Wrapper_Icon=sacred2.ico
#AutoIt3Wrapper_Outfile=S2Server.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Server Launcher
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Server Launcher
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=PolluxTroy
#AutoIt3Wrapper_Res_LegalCopyright=PolluxTroy

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <Inet.au3>

$appversion = FileGetVersion(@ScriptFullPath, $FV_FILEVERSION)
$AppName = "Sacred 2 Server Launcher v." & $appversion
$IniFile = @ScriptDir & "\S2Server\S2Server.ini"

If Not FileExists(@ScriptDir & "\system\s2gs.exe") Then
	If Not FileExists(@ScriptDir & "\S2Server\system\s2gs.exe") Then
		MsgBox(16, $AppName, "Error : Unable to find s2gs.exe ! Please start S2Server.exe from the root folder of Sacred 2.")
		Exit
	EndIf
EndIf

;Install required files
SplashTextOn($AppName, "Extracting...", 400, 50, -1, -1)
DirCreate(@ScriptDir & "\S2Server\")
FileInstall("BouncyCastle.Crypto.dll", @ScriptDir & "\S2Server\BouncyCastle.Crypto.dll",0)
FileInstall("S2Library.dll", @ScriptDir & "\S2Server\S2Library.dll",0)
FileInstall("S2Lobby.exe", @ScriptDir & "\S2Server\S2Lobby.exe",0)
FileInstall("S2Lobby.exe.config", @ScriptDir & "\S2Server\S2Lobby.exe.config",0)
FileInstall("System.Data.SQLite.dll", @ScriptDir & "\S2Server\System.Data.SQLite.dll",0)
FileInstall("accounts.sqlite", @ScriptDir & "\S2Server\accounts.sqlite",0)
;FileInstall("ip.cfg", @ScriptDir & "\S2Server\ip.cfg",0) ;Contain one line : 127.0.0.1
FileInstall("S2Firewall.cmd", @ScriptDir & "\S2Server\S2Firewall.cmd",0)
FileInstall("S2Server_ReadMe.txt", @ScriptDir & "\S2Server\S2Server_ReadMe.txt",0)
SplashOff()

;Commandline
If $CmdLine[0] <> 0 Then
	If $CmdLine[1] == "-start" Then
		_Start()
		Exit
	EndIf
EndIf

;Gui
$Form1 = GUICreate($AppName, 458, 369, -1, -1)

$Group1 = GUICtrlCreateGroup("Lobby Settings (OpenNet Only)", 232, 8, 217, 153)

$Label10 = GUICtrlCreateLabel("IP Address", 240, 34, 55, 17)
$Input6 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "lobby", "127.0.0.1"), 320, 32, 121, 21)
GUICtrlSetTip($Input6, "hostname or ip of lobby-server")

$Label11 = GUICtrlCreateLabel("Port", 240, 58, 23, 17)
$Input7 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "lobby_port", "6800"), 320, 56, 121, 21)
GUICtrlSetTip($Input7, "port of lobby-server")

$Label12 = GUICtrlCreateLabel("Username", 240, 82, 52, 17)
$Input8 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "lobby_name", "Sacred2LobbyAccount"), 320, 80, 121, 21)
GUICtrlSetTip($Input8, "lobby user name")

$Label13 = GUICtrlCreateLabel("Password", 240, 106, 50, 17)
$Input9 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "lobby_pwd", "password"), 320, 104, 121, 21)
GUICtrlSetTip($Input9, "lobby password")

$Label14 = GUICtrlCreateLabel("Broadcast Port", 240, 130, 74, 17)
$Input10 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "broadcastport", "6800"), 320, 128, 121, 21)
GUICtrlSetTip($Input10, "set broadcast UDP port to <num> (1024..32767)" & @CRLF & "(server broadcast port must be the same as listening port of client!)")

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Game Settings", 8, 128, 217, 201)

$Label8 = GUICtrlCreateLabel("Name", 16, 154, 32, 17)
$Input4 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "name", "Sacred 2 Server"), 96, 152, 121, 21)
GUICtrlSetTip($Input4, "set server name")

$Label9 = GUICtrlCreateLabel("Description", 16, 178, 57, 17)
$Input5 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "description", "A Sacred 2 Dedicated Server"), 96, 176, 121, 21)
GUICtrlSetTip($Input5, "set server description")

$Label3 = GUICtrlCreateLabel("Type", 16, 202, 28, 17)
$Combo2 = GUICtrlCreateCombo("", 96, 200, 121, 25, $CBS_DROPDOWNLIST)
GUICtrlSetTip($Combo2, "set game type:" & @CRLF & "campaign : campaign mode (default)" & @CRLF & "free : free game mode" & @CRLF & "pvp : playerkiller mode")
GuiCtrlSetData($Combo2, "")
GuiCtrlSetData($Combo2, "campaign|free|pvp")
$initype = IniRead($IniFile, "SACRED2SRVCFG", "type", "free")
If $initype == "campaign" Then
	_GUICtrlComboBox_SetCurSel($Combo2, 0)
ElseIf $initype == "free" Then
	_GUICtrlComboBox_SetCurSel($Combo2, 1)
ElseIf $initype == "pvp" Then
	_GUICtrlComboBox_SetCurSel($Combo2, 2)
EndIf

$Label4 = GUICtrlCreateLabel("Difficulty", 16, 226, 44, 17)
$Combo3 = GUICtrlCreateCombo("", 96, 224, 121, 25, $CBS_DROPDOWNLIST)
GUICtrlSetTip($Combo3, "set game difficulty:" & @CRLF & "bronze : bronze difficulty mode (default)" & @CRLF & "silver : silver difficulty mode" & @CRLF & "gold : gold difficulty mode" & @CRLF & "platin : platin difficulty mode" & @CRLF & "niob : niob difficulty mode")
GuiCtrlSetData($Combo3, "")
GuiCtrlSetData($Combo3, "bronze|silver|gold|platin|niob")
$inidiff = IniRead($IniFile, "SACRED2SRVCFG", "diff", "bronze")
If $inidiff == "bronze" Then
	_GUICtrlComboBox_SetCurSel($Combo3, 0)
ElseIf $inidiff == "silver" Then
	_GUICtrlComboBox_SetCurSel($Combo3, 1)
ElseIf $inidiff == "gold" Then
	_GUICtrlComboBox_SetCurSel($Combo3, 2)
ElseIf $inidiff == "platin" Then
	_GUICtrlComboBox_SetCurSel($Combo3, 3)
ElseIf $inidiff == "niob" Then
	_GUICtrlComboBox_SetCurSel($Combo3, 4)
EndIf

$Label5 = GUICtrlCreateLabel("Mode", 16, 250, 31, 17)
$Combo4 = GUICtrlCreateCombo("", 96, 248, 121, 25, $CBS_DROPDOWNLIST)
GUICtrlSetTip($Combo4, "set game mode:" & @CRLF & "hardcore : hardcore mode" & @CRLF & "softcore : softcore mode (default)")
GuiCtrlSetData($Combo4, "")
GuiCtrlSetData($Combo4, "softcore|hardcore")
_GUICtrlComboBox_SetCurSel($Combo4, 1)
$inimode = IniRead($IniFile, "SACRED2SRVCFG", "mode", "softcore")
If $inimode == "softcore" Then
	_GUICtrlComboBox_SetCurSel($Combo4, 0)
ElseIf $inimode == "hardcore" Then
	_GUICtrlComboBox_SetCurSel($Combo4, 1)
EndIf

$Label6 = GUICtrlCreateLabel("Max Players", 16, 274, 61, 17)
$Input2 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "numplayers", "5"), 96, 272, 121, 21)
GUICtrlSetTip($Input2, "set max. num of players in session" & @CRLF & "(campaign=5 players, other modes=16 players)")

$Label7 = GUICtrlCreateLabel("Password", 16, 298, 50, 17)
$Input3 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "password", "password"), 96, 296, 121, 21)
GUICtrlSetTip($Input3, "set a session password")

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("Server Settings", 8, 8, 217, 113)

$Label1 = GUICtrlCreateLabel("Server Type", 16, 34, 62, 17)
$Combo1 = GUICtrlCreateCombo("", 96, 32, 121, 25, $CBS_DROPDOWNLIST)
GUICtrlSetTip($Combo1, "changes initial connection mode:" & @CRLF & "lan : LAN multiplayer mode (default)"& @CRLF & "opennet : opennet multiplayer mode")
GuiCtrlSetData($Combo1, "")
GuiCtrlSetData($Combo1, "opennet|lan")
$inicon = IniRead($IniFile, "SACRED2SRVCFG", "connmode", "lan")
If $inicon == "opennet" Then
	_GUICtrlComboBox_SetCurSel($Combo1, 0)
ElseIf $inicon == "lan" Then
	_GUICtrlComboBox_SetCurSel($Combo1, 1)
EndIf

$Label2 = GUICtrlCreateLabel("Server Port", 16, 58, 57, 17)
$Input1 = GUICtrlCreateInput(IniRead($IniFile, "SACRED2SRVCFG", "port", "6802"), 96, 56, 121, 21)
GUICtrlSetTip($Input1, "set fixed game TCP/IP port to <num> (1024..32767)")

$Checkbox2 = GUICtrlCreateCheckbox("Log", 96, 96, 121, 17)
GUICtrlSetTip($Checkbox2, "create logfile")
GuiCtrlSetState($Checkbox2, $GUI_DISABLE)
$var = IniRead($IniFile, "SACRED2SRVCFG", "log", "1")
If $var == 0 Then
	GUICtrlSetState($Checkbox2, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox2, $GUI_CHECKED)
EndIf

$Checkbox1 = GUICtrlCreateCheckbox("Lock Config", 96, 80, 121, 17)
GUICtrlSetTip($Checkbox1, "configuration cannot be changed after gameserver has started")
$var = IniRead($IniFile, "SACRED2SRVCFG", "lockconfig", "0")
If $var == 0 Then
	GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox1, $GUI_CHECKED)
EndIf

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Other Settings", 232, 168, 217, 161)

$Label15 = GUICtrlCreateLabel("Auto Shutdown", 240, 216, 77, 17)
GuiCtrlSetState(-1, $GUI_DISABLE)
$Input11 = GUICtrlCreateInput("", 320, 216, 121, 21)
GUICtrlSetTip($Input11, "automatic gameserver shutdown in <num> seconds if no client has connected")
GuiCtrlSetState($Input11, $GUI_DISABLE)

$Label16 = GUICtrlCreateLabel("CPU", 240, 240, 26, 17)
GuiCtrlSetState($Label16, $GUI_DISABLE)
$Input13 = GUICtrlCreateInput("", 320, 240, 121, 21)
GUICtrlSetTip($Input13, "bind gameserver process to the specified cpu")
GuiCtrlSetState($Input13, $GUI_DISABLE)

$Label17 = GUICtrlCreateLabel("Exec", 240, 264, 28, 17)
GuiCtrlSetState($Label17, $GUI_DISABLE)
$Input12 = GUICtrlCreateInput("", 320, 264, 121, 21)
GUICtrlSetTip($Input12, "set <filename> as main script file")
GuiCtrlSetState($Input12, $GUI_DISABLE)

$Label18 = GUICtrlCreateLabel("Session Timer", 240, 192, 70, 17)
GuiCtrlSetState($Label18, $GUI_DISABLE)
$Input14 = GUICtrlCreateInput("", 320, 192, 121, 21)
GUICtrlSetTip($Input14, "set time limit for the session to <num> seconds" & @CRLF & "(timer starts when first client is ingame)")
GuiCtrlSetState($Input14, $GUI_DISABLE)

$Checkbox3 = GUICtrlCreateCheckbox("Act As User", 240, 304, 97, 17)
GUICtrlSetTip($Checkbox3, "force server to act as helper server for an user and not as session hosting server")
GuiCtrlSetState($Checkbox3, $GUI_DISABLE)
$var = IniRead($IniFile, "SACRED2SRVCFG", "act_as_user", "0")
If $var == 0 Then
	GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox3, $GUI_CHECKED)
EndIf

$Checkbox4 = GUICtrlCreateCheckbox("MiniDump", 344, 304, 97, 17)
GUICtrlSetTip($Checkbox4, "enable minidump")
GuiCtrlSetState($Checkbox4, $GUI_DISABLE)
$var = IniRead($IniFile, "SACRED2SRVCFG", "minidump", "0")
If $var == 0 Then
	GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox3, $GUI_CHECKED)
EndIf

$Checkbox5 = GUICtrlCreateCheckbox("Non Dedicated", 344, 288, 97, 17)
GUICtrlSetTip($Checkbox5, "start gameserver in nondedicated mode" & @CRLF & "(launched from a sacred2 client)")
GuiCtrlSetState($Checkbox5, $GUI_DISABLE)
$var = IniRead($IniFile, "SACRED2SRVCFG", "nondedicated", "0")
If $var == 0 Then
	GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox3, $GUI_CHECKED)
EndIf

$Checkbox6 = GUICtrlCreateCheckbox("Presentation", 240, 288, 97, 17)
GUICtrlSetTip($Checkbox6, "start in presentation mode")
GuiCtrlSetState($Checkbox6, $GUI_DISABLE)
$var = IniRead($IniFile, "SACRED2SRVCFG", "presentation", "0")
If $var == 0 Then
	GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
ElseIf $var == 1 Then
	GUICtrlSetState($Checkbox3, $GUI_CHECKED)
EndIf

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Button1 = GUICtrlCreateButton("Start Server", 8, 336, 219, 25)
If GUICtrlRead($Combo1) == "lan" Then
	GuiCtrlSetData($Button1, "Start LAN Server")
ElseIf GUICtrlRead($Combo1) == "opennet" Then
	GuiCtrlSetData($Button1, "Start Online Server")
EndIf

$Button2 = GUICtrlCreateButton("Save Settings", 232, 336, 107, 25)
$Button3 = GUICtrlCreateButton("Exit", 344, 336, 107, 25)

GUISetState(@SW_SHOW)

;Save settings
Func _Save()
	If GUICtrlRead($Checkbox3) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "act_as_user", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "act_as_user", "1")
	EndIf

	IniWrite($IniFile, "SACRED2SRVCFG", "autoshutdown", GUICtrlRead($Input11))
	IniWrite($IniFile, "SACRED2SRVCFG", "broadcastport", GUICtrlRead($Input10))
	IniWrite($IniFile, "SACRED2SRVCFG", "connmode", GUICtrlRead($Combo1))
	IniWrite($IniFile, "SACRED2SRVCFG", "cpu", GUICtrlRead($Input13))
	IniWrite($IniFile, "SACRED2SRVCFG", "diff", GUICtrlRead($Combo3))
	IniWrite($IniFile, "SACRED2SRVCFG", "description", GUICtrlRead($Input5))
	IniWrite($IniFile, "SACRED2SRVCFG", "exec", GUICtrlRead($Input12))
	IniWrite($IniFile, "SACRED2SRVCFG", "lobby", GUICtrlRead($Input6))
	IniWrite($IniFile, "SACRED2SRVCFG", "lobby_port", GUICtrlRead($Input7))
	IniWrite($IniFile, "SACRED2SRVCFG", "lobby_name", GUICtrlRead($Input8))
	IniWrite($IniFile, "SACRED2SRVCFG", "lobby_pwd", GUICtrlRead($Input9))
	IniWrite($IniFile, "SACRED2SRVCFG", "lobby_cdkey", "")

	If GUICtrlRead($Checkbox1) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "lockconfig", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "lockconfig", "1")
	EndIf

	If GUICtrlRead($Checkbox2) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "log", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "log", "1")
	EndIf

	IniWrite($IniFile, "SACRED2SRVCFG", "mode", GUICtrlRead($Combo4))
	IniWrite($IniFile, "SACRED2SRVCFG", "name", GUICtrlRead($Input4))

	If GUICtrlRead($Checkbox4) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "minidump", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "minidump", "1")
	EndIf

	If GUICtrlRead($Checkbox5) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "nondedicated", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "nondedicated", "1")
	EndIf

	IniWrite($IniFile, "SACRED2SRVCFG", "numplayers", GUICtrlRead($Input2))
	IniWrite($IniFile, "SACRED2SRVCFG", "password", GUICtrlRead($Input3))
	IniWrite($IniFile, "SACRED2SRVCFG", "port", GUICtrlRead($Input1))
	IniWrite($IniFile, "SACRED2SRVCFG", "sessiontimer", GUICtrlRead($Input14))
	IniWrite($IniFile, "SACRED2SRVCFG", "type", GUICtrlRead($Combo2))

	If GUICtrlRead($Checkbox6) == 4 Then
		IniWrite($IniFile, "SACRED2SRVCFG", "presentation", "0")
	Else
		IniWrite($IniFile, "SACRED2SRVCFG", "presentation", "1")
	EndIf
EndFunc

Func _Start()
	$act_as_user = IniRead($IniFile, "SACRED2SRVCFG", "act_as_user", "")
	$autoshutdown = IniRead($IniFile, "SACRED2SRVCFG", "autoshutdown", "")
	$broadcastport = IniRead($IniFile, "SACRED2SRVCFG", "broadcastport", "")
	$connmode = IniRead($IniFile, "SACRED2SRVCFG", "connmode", "")
	$cpu = IniRead($IniFile, "SACRED2SRVCFG", "cpu", "")
	$diff = IniRead($IniFile, "SACRED2SRVCFG", "diff", "")
	$description = IniRead($IniFile, "SACRED2SRVCFG", "description", "")
	$exec = IniRead($IniFile, "SACRED2SRVCFG", "exec", "")
	$lobby = IniRead($IniFile, "SACRED2SRVCFG", "lobby", "")
	$lobby_port = IniRead($IniFile, "SACRED2SRVCFG", "lobby_port", "")
	$lobby_name = IniRead($IniFile, "SACRED2SRVCFG", "lobby_name", "")
	$lobby_pwd = IniRead($IniFile, "SACRED2SRVCFG", "lobby_pwd", "")
	$lobby_cdkey = IniRead($IniFile, "SACRED2SRVCFG", "lobby_cdkey", "")
	$lockconfig = IniRead($IniFile, "SACRED2SRVCFG", "lockconfig", "")
	$log = IniRead($IniFile, "SACRED2SRVCFG", "log", "")
	$mode = IniRead($IniFile, "SACRED2SRVCFG", "mode", "")
	$name = IniRead($IniFile, "SACRED2SRVCFG", "name", "")
	$minidump = IniRead($IniFile, "SACRED2SRVCFG", "minidump", "")
	$nondedicated = IniRead($IniFile, "SACRED2SRVCFG", "nondedicated", "")
	$numplayers = IniRead($IniFile, "SACRED2SRVCFG", "numplayers", "")
	$password = IniRead($IniFile, "SACRED2SRVCFG", "password", "")
	$port = IniRead($IniFile, "SACRED2SRVCFG", "port", "")
	$sessiontimer = IniRead($IniFile, "SACRED2SRVCFG", "sessiontimer", "")
	$type = IniRead($IniFile, "SACRED2SRVCFG", "type", "")
	$presentation = IniRead($IniFile, "SACRED2SRVCFG", "presentation", "")

	$ServerConfig = ""

	If $act_as_user == 1 Then
		$ServerConfig &= " -act_as_user"
	EndIf

	If Not $autoshutdown == "" Or Not $autoshutdown == 0 Then
		$ServerConfig &= " -autoshutdown=" & $autoshutdown
	EndIf

	If Not $broadcastport == "" Or Not $broadcastport == 0 Then
		$ServerConfig &= " -broadcastport=" & $broadcastport
	EndIf

	$ServerConfig &= " -connmode=" & $connmode

	If Not $cpu == "" Or Not $cpu == 0 Then
		$ServerConfig &= " -cpu=" & $cpu
	EndIf

	$ServerConfig &= " -diff=" & $diff
	$ServerConfig &= " -description=" & '"' & $description & '"'

	If Not $exec == "" Or Not $exec == 0 Then
		$ServerConfig &= " -exec=" & '"' & $exec & '"'
	EndIf

	If $connmode == "opennet" Then
		$ServerConfig &= " -lobby=" & $lobby
		$ServerConfig &= " -lobby_port=" & $lobby_port
		$ServerConfig &= " -lobby_name=" & $lobby_name
		$ServerConfig &= " -lobby_pwd=" & $lobby_pwd
		;$ServerConfig &= " -lobby_cdkey=" & $lobby_cdkey
	EndIf

	If $lockconfig == 1 Then
		$ServerConfig &= " -lockconfig"
	EndIf

	If $log == 1 Then
		$ServerConfig &= " -log=1"
	EndIf

	$ServerConfig &= " -mode=" & $mode
	$ServerConfig &= " -name=" & '"' & $name & '"'

	If $minidump == 1 Then
		$ServerConfig &= " -minidump"
	EndIf

	If $nondedicated == 1 Then
		$ServerConfig &= " -nondedicated"
	EndIf

	$ServerConfig &= " -numplayers=" & $numplayers
	$ServerConfig &= " -password=" & $password

	If $connmode == "opennet" Then
		$ServerConfig &= " -port=" & $port
	EndIf

	If Not $sessiontimer == "" Or Not $sessiontimer == 0 Then
		$ServerConfig &= " -sessiontimer=" & $sessiontimer
	EndIf

	$ServerConfig &= " -type=" & $type

	If $presentation == 1 Then
		$ServerConfig &= " -presentation"
	EndIf

	If $connmode == "opennet" Then
		$ServerConfig &= " -externalip=" & _GetIP()
	EndIf

	GUISetState(@SW_HIDE)

	If $connmode == "opennet" Then
		If FileExists(@ScriptDir & "\S2Server\S2Lobby.exe") Then
			SplashTextOn($AppName, "Starting Lobby...", 400, 50, -1, -1)
			Run(@ScriptDir & "\S2Server\S2Lobby.exe", @ScriptDir & "\S2Server\")
			Sleep(2500)
			SplashOff()
		Else
			MsgBox(16,$AppName, "Error : Unable to find S2Lobby.exe !")
			Exit
		EndIf
	EndIf

	If FileExists(@ScriptDir & "\S2Server\system\s2gs.exe") Then
		SplashTextOn($AppName, "Starting Server...", 400, 50, -1, -1)
		Run(@ComSpec & " /c " & 'title Sacred 2 Game Server - Press CTRL+C to stop && call S2Server\system\s2gs.exe /high' & $ServerConfig, @ScriptDir & "\S2Server\", @SW_SHOW)
		;Run(@ScriptDir & "\S2Server\system\s2gs.exe" & " /high" & $ServerConfig, @ScriptDir & "\S2Server\")
		SplashOff()
	ElseIf FileExists(@ScriptDir & "\system\s2gs.exe") Then
		SplashTextOn($AppName, "Starting Server...", 400, 50, -1, -1)
		Run(@ComSpec & " /c " & 'title Sacred 2 Game Server - Press CTRL+C to stop && call system\s2gs.exe /high' & $ServerConfig, @ScriptDir & "\", @SW_SHOW)
		;Run(@ScriptDir & "\system\s2gs.exe" & " /high" & $ServerConfig, @ScriptDir & "\")
		SplashOff()
	Else
		MsgBox(16,$AppName, "Error : Unable to find s2gs.exe !")
		Exit
	EndIf

	Exit
EndFunc

$sCurrCombo = GUICtrlRead($Combo1)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			_Save()
			_Start()

		Case $Button2
			_Save()

		Case $Button3
			Exit

	EndSwitch

    If GUICtrlRead($Combo1) <> $sCurrCombo And _GUICtrlComboBox_GetDroppedState($Combo1) = False Then
		If GUICtrlRead($Combo1) == "lan" Then
			GuiCtrlSetData($Button1, "Start LAN Server")
			;Disable Lobby Settings
		ElseIf GUICtrlRead($Combo1) == "opennet" Then
			GuiCtrlSetData($Button1, "Start Online Server")
			;Enable Lobby Settings
		EndIf
		Sleep(500)
		$sCurrCombo = GUICtrlRead($Combo1)
    EndIf

WEnd