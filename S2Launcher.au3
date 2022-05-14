#AutoIt3Wrapper_Icon=sacred2.ico
#AutoIt3Wrapper_Outfile=S2Launcher.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Launcher
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.5
#AutoIt3Wrapper_Res_Fileversion=1.0.0.5
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Launcher

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <FontConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <TrayConstants.au3>

Opt("TrayAutoPause", 0)
Opt("TrayIconHide", 0)
Opt("TrayMenuMode", 3)

$appversion = FileGetVersion(@ScriptFullPath, $FV_FILEVERSION)

If @ScriptName == "S2LauncherP.exe" Then
	$Registry = False
	$mode = " - Portable Mode"
ElseIf @ScriptName == "S2LauncherR.exe" Then
	$Registry = True
	$mode = " - Installed Mode"
Else
	$Registry = "Both"
	$mode = ""
EndIf

FileInstall("splash.jpg", @TempDir & "\splash.jpg", 1)

If $Registry == True Then
	If @OSArch == "X86" Then
		$ver = RegRead("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", "CurrentVersion")
		$lang = RegRead("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", "Language")
		$speech = RegRead("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", "Speech")
		$track = RegRead("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", "MovieTrack")
		$path = RegRead("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", "InstallPath")
	Else
		$ver = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", "CurrentVersion")
		$lang = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", "Language")
		$speech = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", "Speech")
		$track = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", "MovieTrack")
		$path = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", "InstallPath")
	EndIf
ElseIf $Registry == False Then
	$ver = FileGetVersion(@ScriptDir & "\system\sacred2.exe", $FV_FILEVERSION)
	$lang = "?"
	$speech = "?"
	$track = "?"
	$path = @ScriptDir & "\"
Else
	$ver = FileGetVersion(@ScriptDir & "\system\sacred2.exe", $FV_FILEVERSION)
	If @error Then
		$ver = "0.0.0.0"
	EndIf

	$path = @ScriptDir & "\"

	$File = @UserProfileDir & "\AppData\Local\Ascaron Entertainment\Sacred 2\optionsCustom.txt"

	$Search = "locale.language"
	If @OSArch == "X86" Then
		$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
		$valuename = "Language"
	Else
		$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
		$valuename = "Language"
	EndIf
	$lang = _Search($File, $Search)

	$Search = "locale.speech"
	If @OSArch == "X86" Then
		$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
		$valuename = "Speech"
	Else
		$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
		$valuename = "Speech"
	EndIf
	$speech = _Search($File, $Search)

	$Search = "locale.movietrack"
	If @OSArch == "X86" Then
		$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
		$valuename = "MovieTrack"
	Else
		$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
		$valuename = "MovieTrack"
	EndIf
	$track = _Search($File, $Search)
EndIf

Local $bar[5] = [@TAB & "v." & $ver, @TAB & "L : " & $lang, @TAB & "S : " & $speech, @TAB & "T : " & $track, "" & $path]
Local $barsize[5] = [60, 60, 60, 40, -1]

$Form1 = GUICreate("Sacred 2 Launcher" & $mode & " v." & $appversion, 561, 379, -1, -1)
GUISetBkColor("0xECE3BE", $Form1)
$Pic1 = GUICtrlCreatePic(@TempDir & "\splash.jpg", 0, 0, 561, 269)
$Play = GUICtrlCreateButton("Play", 448, 280, 99, 65)
$Server = GUICtrlCreateButton("Server" & @CRLF & "Launcher", 216, 280, 99, 65, $BS_MULTILINE)
$Mods = GUICtrlCreateButton("Mods" & @CRLF & "Manager", 8, 280, 99, 65, $BS_MULTILINE)
;$Save = GUICtrlCreateButton("Savegame Folder", 112, 280, 99, 33, $BS_MULTILINE)
$Backup = GUICtrlCreateButton("Backup Saves", 112, 280, 99, 41)

$autosaveonexit = GUICtrlCreateCheckbox("AutoBackup", 120, 328, 81, 17)

$skipopenal = GUICtrlCreateCheckbox("Skip OpenAl", 320, 296, 80, 17)
$logging = GUICtrlCreateCheckbox("Logging", 320, 328, 57, 17)
$nocpubinding = GUICtrlCreateCheckbox("No CPU Binding", 320, 280, 95, 17)
$showserver = GUICtrlCreateCheckbox("Show Server", 320, 312, 81, 17)

$StatusBar1 = _GUICtrlStatusBar_Create($Form1, $barsize, $bar)

GUICtrlSetTip($skipopenal, "Disable OpenAl API for sound and audio.")
GUICtrlSetTip($logging, "Enable logging")
GUICtrlSetTip($nocpubinding, "Prevent the game from using only one CPU.")
GUICtrlSetTip($showserver, "Show game server.")
GUICtrlSetTip($autosaveonexit, "Create a savegames backup when the game stop.")

;If $lang == "fr_FR" Then
;	GUICtrlSetData($Play, "Jouer")
;EndIf

If Not FileExists($path & "system\sacred2.exe") Then
	GUICtrlDelete($Play)
	$Play = GUICtrlCreateButton("Game" & @CRLF & "not found !", 448, 280, 99, 65, $BS_MULTILINE)
	GUICtrlSetState($Play, $GUI_DISABLE)
Else
	GUICtrlDelete($Play)
	$Play = GUICtrlCreateButton("Play", 448, 280, 99, 65)
	GUICtrlSetFont($Play, 12, $FW_BOLD, $GUI_FONTNORMAL)
EndIf
If Not FileExists($path & "S2Server.exe") Then
	$serverinstall = 0
	GUICtrlSetData($Server, "Install" & @CRLF & "Server Launcher")
Else
	$serverinstall = 1
EndIf
If Not FileExists($path & "JSGME.exe") Then
	$modsinstall = 0
	GUICtrlSetData($Mods, "Install JSGME" & @CRLF & "Mods Manager")
Else
	$modsinstall = 1
EndIf
;If Not FileExists(@UserProfileDir & "\Saved Games\Ascaron Entertainment\Sacred 2\") Then
;	GUICtrlSetData($Save, "Savegame folder" & @CRLF & "not found !")
;	GuiCtrlSetState($Save, $GUI_DISABLE)
;	GuiCtrlSetState($Backup, $GUI_DISABLE)
;EndIf

$ini_skipopenal = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "skipopenal", "4")
If FileExists(@ScriptDir & "\S2Launcher.ini") Then
	If $ini_skipopenal == 1 Then
		GUICtrlSetState($skipopenal, $GUI_CHECKED)
	EndIf
Else
	GUICtrlSetState($skipopenal, $GUI_CHECKED)
EndIf

$ini_logging = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "logging", "4")
If $ini_logging == 1 Then
	GUICtrlSetState($logging, $GUI_CHECKED)
EndIf

$ini_nocpubinding = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "nocpubinding", "4")
If FileExists(@ScriptDir & "\S2Launcher.ini") Then
	If $ini_nocpubinding == 1 Then
		GUICtrlSetState($nocpubinding, $GUI_CHECKED)
	EndIf
Else
	GUICtrlSetState($nocpubinding, $GUI_CHECKED)
EndIf

$ini_showserver = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "showserver", "4")
If $ini_showserver == 1 Then
	GUICtrlSetState($showserver, $GUI_CHECKED)
EndIf

$ini_autosaveonexit = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "autosaveonexit", "4")
If $ini_autosaveonexit == 1 Then
	GUICtrlSetState($autosaveonexit, $GUI_CHECKED)
EndIf

GUISetState(@SW_SHOW, $Form1)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_Save()
			_Exit()

		Case $Play
			_Save()
			$param = ""
			If GUICtrlRead($skipopenal) == 1 Then
				$param &= " -skipopenal"
			EndIf
			If GUICtrlRead($logging) == 1 Then
				$param &= " -logging"
			EndIf
			If GUICtrlRead($nocpubinding) == 1 Then
				$param &= " -nocpubinding"
			EndIf
			If GUICtrlRead($showserver) == 1 Then
				$param &= " -showserver"
			EndIf
			Run($path & "system\sacred2.exe" & $param)
			GUISetState(@SW_HIDE, $Form1)
			If IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "autosaveonexit", "0") == 1 Then
				_WaitCloseForBackup()
			EndIf
			_Exit()

		Case $Server
			If $serverinstall == 0 Then
				GuiCtrlSetState($Server, $GUI_DISABLE)
				GuiCtrlSetData($Server, "Installing...")
				FileInstall("S2Server.exe", $path & "S2Server.exe")
				GUISetState(@SW_HIDE, $Form1)
				_Save()
				ShellExecute(@ScriptFullPath)
				_Exit()
			Else
				ShellExecute($path & "S2Server.exe")
			EndIf

		Case $Mods
			If $modsinstall == 0 Then
				GuiCtrlSetState($Mods, $GUI_DISABLE)
				GuiCtrlSetData($Mods, "Installing...")
				FileInstall("JSGME.exe", $path & "JSGME.exe")
				GUISetState(@SW_HIDE, $Form1)
				_Save()
				ShellExecute(@ScriptFullPath)
				_Exit()
			Else
				ShellExecute($path & "JSGME.exe")
			EndIf

			;Case $Save
			;	ShellExecute(@UserProfileDir & "\Saved Games\Ascaron Entertainment\Sacred 2\")

		Case $Backup
			GuiCtrlSetState($Backup, $GUI_DISABLE)
			Sleep(100)
			GuiCtrlSetData($Backup, "Backup...")
			_Backup()
			GuiCtrlSetData($Backup, "Backup Saves")
			Sleep(100)
			GuiCtrlSetState($Backup, $GUI_ENABLE)

		Case $autosaveonexit
			_Save()

	EndSwitch
WEnd

Func _Search($File, $Search)
	Local $Lines
	$Line = "0"
	$Result = "0"

	_FileReadToArray($File, $Lines)

	For $i = 1 To $Lines[0]
		If StringInStr($Lines[$i], $Search) Then
			$Line = $i
			ExitLoop
		EndIf
	Next

	If $Line <> "0" Then
		Local $hFileOpen = FileOpen($File, $FO_READ)
		If $hFileOpen = -1 Then
			$Result = "0"
		Else
			$Line = FileReadLine($File, $i)
			$Value = _StringBetween($Line, '"', '"')
			$Result = $Value[0]
		EndIf
		FileClose($hFileOpen)
	Else
		$Result = "0"
	EndIf

	If $Result == "0" Then
		$RegValue = RegRead($keyname, $valuename)
		If @error <> 0 Then
			$Result = "?"
		Else
			$Result = $RegValue
		EndIf
	EndIf

	Return $Result
EndFunc

Func _WaitCloseForBackup()
	TraySetToolTip("Waiting for Sacred 2 to stop," & @CRLF & "to create a savegames backup...")

	While ProcessExists("sacred2.exe")
		Sleep(1000)
	WEnd

	_Backup(1)
	Sleep(5000)
EndFunc

Func _Backup($auto = 0)
	GUICtrlSetState($Backup, $GUI_DISABLE)
	Sleep(500)

	$datetime = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC

	$savefoldername = IniRead(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "savefoldername", "S2SavesBackup")

	If $savefoldername == "" Then
		$savefoldername = "S2SavesBackup"
	EndIf

	$backupfolder = @ScriptDir & "\" & $savefoldername & "\"

	If $auto == 0 Then
		$extsave = "-MANUAL"
	ElseIf $auto == 1 Then
		$extsave = "-AUTO"
	Else
		$extsave = ""
	EndIf

	$CopySaves = FileCopy(@UserProfileDir & "\Saved Games\Ascaron Entertainment\Sacred 2\*.*", $backupfolder & $datetime & $extsave & "\saves\", 8)
	$CopyOptions = FileCopy(@UserProfileDir & "\AppData\Local\Ascaron Entertainment\Sacred 2\*.*", $backupfolder & $datetime & $extsave & "\options\", 8)

	If $CopySaves == 0 Or $CopyOptions == 0 Then
		$CopyMsg = "An error occured. Unable to backup savegames !"
		$CopyIcon = 3
	Else
		$CopyMsg = "Game saves have been backed up in " & $backupfolder & $datetime & $extsave & " !"
		$CopyIcon = 0
	EndIf

	If RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "EnableBalloonTips") == 0 Then
		;If $auto == 0 Then
		MsgBox(64, "AutoBackup Saves", $CopyMsg)
		;EndIf
	Else
		TrayTip("AutoBackup Saves", $CopyMsg, 5, $CopyIcon)
	EndIf

	GUICtrlSetState($Backup, $GUI_ENABLE)
	Sleep(500)
EndFunc

Func _Save()
	$save_skipopenal = GUICtrlRead($skipopenal)
	$save_logging = GUICtrlRead($logging)
	$save_nocpubinding = GUICtrlRead($nocpubinding)
	$save_showserver = GUICtrlRead($showserver)
	$save_autosaveonexit = GUICtrlRead($autosaveonexit)

	If $save_skipopenal == "1" Then
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "skipopenal", "1")
	Else
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "skipopenal", "0")
	EndIf

	If $save_logging == "1" Then
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "logging", "1")
	Else
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "logging", "0")
	EndIf

	If $save_nocpubinding == "1" Then
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "nocpubinding", "1")
	Else
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "nocpubinding", "0")
	EndIf

	If $save_showserver == "1" Then
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "showserver", "1")
	Else
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "showserver", "0")
	EndIf

	If $save_autosaveonexit == "1" Then
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "autosaveonexit", "1")
	Else
		IniWrite(@ScriptDir & "\S2Launcher.ini", "S2LAUNCHER", "autosaveonexit", "0")
	EndIf
EndFunc

Func _Exit()
	FileDelete(@TempDir & "\splash.jpg")
	Exit
EndFunc
