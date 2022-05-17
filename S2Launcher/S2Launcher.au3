#AutoIt3Wrapper_Icon=sacred2.ico
#AutoIt3Wrapper_Outfile=S2Launcher.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Launcher
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Launcher
#AutoIt3Wrapper_Res_ProductVersion=1.0.3.0
#AutoIt3Wrapper_Res_Fileversion=1.0.3.0
#AutoIt3Wrapper_Res_CompanyName=PolluxTroy
#AutoIt3Wrapper_Res_LegalCopyright=PolluxTroy

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
#include <InetConstants.au3>

;Options
Opt("TrayAutoPause", 0)
Opt("TrayIconHide", 0)
Opt("TrayMenuMode", 3)

;Variables
$appversion = FileGetVersion(@ScriptFullPath, $FV_FILEVERSION)
Global $path = @ScriptDir & "\"
Global $inifile = @ScriptDir & "\S2Launcher.ini"

;Check for update
_Update()

;Autostart
If IniRead($inifile, "S2LAUNCHER", "autostart", "0") == "1" Then
	_Play()
	_Wait()
	_Exit()
Else
	IniWrite($inifile, "S2LAUNCHER", "autostart", "0")
EndIf

;ReadMe
FileInstall("ReadMe.html", @ScriptDir & "\S2Launcher-ReadMe.html",1)

;Splashscreen
FileInstall("splash.jpg", @TempDir & "\splash.jpg", 1)

;Game executable version
$ver = FileGetVersion(@ScriptDir & "\system\sacred2.exe", $FV_FILEVERSION)
If @error Then
	$ver = "0.0.0.0"
EndIf

;Custom options path
$File = @UserProfileDir & "\AppData\Local\Ascaron Entertainment\Sacred 2\optionsCustom.txt"

;Game language
If @OSArch == "X86" Then
	$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
	$valuename = "Language"
Else
	$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
	$valuename = "Language"
EndIf
$lang = _Search($File, "locale.language", $keyname, $valuename)

;Game speech language
If @OSArch == "X86" Then
	$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
	$valuename = "Speech"
Else
	$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
	$valuename = "Speech"
EndIf
$speech = _Search($File, "locale.speech", $keyname, $valuename)

;Game movietrack
If @OSArch == "X86" Then
	$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
	$valuename = "MovieTrack"
Else
	$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
	$valuename = "MovieTrack"
EndIf
$track = _Search($File, "locale.movietrack", $keyname, $valuename)

;Defining status bar infos
Local $bar[5] = [@TAB & "v." & $ver, @TAB & "L : " & $lang, @TAB & "S : " & $speech, @TAB & "T : " & $track, "" & $path]
Local $barsize[5] = [60, 60, 60, 40, -1]

;Main GUI
$Form1 = GUICreate("Sacred 2 Launcher" & " v." & $appversion & "", 561, 398, -1, -1) ;379
GUISetBkColor("0xECE3BE", $Form1)
$Pic1 = GUICtrlCreatePic(@TempDir & "\splash.jpg", 0, 0, 561, 269)
$Play = GUICtrlCreateButton("Play", 448, 280, 99, 65)
$Server = GUICtrlCreateButton("Server" & @CRLF & "Launcher", 216, 280, 99, 65, $BS_MULTILINE)
$Mods = GUICtrlCreateButton("Mods" & @CRLF & "Manager", 8, 280, 99, 65, $BS_MULTILINE)
$Backup = GUICtrlCreateButton("Backup Saves", 112, 280, 99, 41)
$autosaveonexit = GUICtrlCreateCheckbox("AutoBackup", 120, 328, 81, 17)
$skipopenal = GUICtrlCreateCheckbox("Skip OpenAl", 320, 296, 80, 17)
$logging = GUICtrlCreateCheckbox("Logging", 320, 328, 57, 17)
$nocpubinding = GUICtrlCreateCheckbox("No CPU Binding", 320, 280, 95, 17)
$showserver = GUICtrlCreateCheckbox("Show Server", 320, 312, 81, 17)

;Top Menu
$MenuFile = GUICtrlCreateMenu("File")
$MenuUpdate = GUICtrlCreateMenuItem("Check for update", $MenuFile)
GuiCtrlSetState(-1, $GUI_DISABLE)
$MenuSeparator1 = GUICtrlCreateMenuItem("", $MenuFile)
$MenuExit = GUICtrlCreateMenuItem("Exit", $MenuFile)
$MenuSettings = GUICtrlCreateMenu("Settings")
$MenuLanguage = GUICtrlCreateMenu("Language", $MenuSettings)
GuiCtrlSetState(-1, $GUI_DISABLE)
$MenuItem13 = GUICtrlCreateMenuItem("German (de_DE)", $MenuLanguage)
$MenuItem14 = GUICtrlCreateMenuItem("English (en_UK)", $MenuLanguage)
$MenuItem25 = GUICtrlCreateMenuItem("French (fr_FR)", $MenuLanguage)
$MenuItem26 = GUICtrlCreateMenuItem("Spanish (es_ES)", $MenuLanguage)
$MenuItem27 = GUICtrlCreateMenuItem("Italian (it_IT)", $MenuLanguage)
$MenuSpeech = GUICtrlCreateMenu("Speech Lang.", $MenuSettings)
GuiCtrlSetState(-1, $GUI_DISABLE)
$MenuItem15 = GUICtrlCreateMenuItem("German (de_DE)", $MenuSpeech)
$MenuItem16 = GUICtrlCreateMenuItem("English (en_UK)", $MenuSpeech)
$MenuItem22 = GUICtrlCreateMenuItem("French (fr_FR)", $MenuSpeech)
$MenuItem23 = GUICtrlCreateMenuItem("Spanish (es_ES)", $MenuSpeech)
$MenuItem24 = GUICtrlCreateMenuItem("Italian (it_IT)", $MenuSpeech)
$MenuTrack = GUICtrlCreateMenu("MovieTrack", $MenuSettings)
GuiCtrlSetState(-1, $GUI_DISABLE)
$MenuItem17 = GUICtrlCreateMenuItem("German (5)", $MenuTrack)
$MenuItem18 = GUICtrlCreateMenuItem("English (6)", $MenuTrack)
$MenuItem19 = GUICtrlCreateMenuItem("French (7)", $MenuTrack)
$MenuItem20 = GUICtrlCreateMenuItem("Spanish (8)", $MenuTrack)
$MenuItem21 = GUICtrlCreateMenuItem("Italian (9)", $MenuTrack)
$MenuAbout = GUICtrlCreateMenu("About")
$MenuCreator = GUICtrlCreateMenuItem("Created by PolluxTroy", $MenuAbout)
GuiCtrlSetState(-1, $GUI_DISABLE)
$MenuSeparator2 = GUICtrlCreateMenuItem("", $MenuAbout)
$MenuGitHub = GUICtrlCreateMenuItem("View sources on GitHub", $MenuAbout)
$MenuSupport = GUICtrlCreateMenuItem("Get support on DarkMatters", $MenuAbout)
$MenuHelp = GUICtrlCreateMenu("?")
$MenuReadMeL = GUICtrlCreateMenuItem("Launcher ReadMe", $MenuHelp)
$MenuReadMeS = GUICtrlCreateMenuItem("Server ReadMe", $MenuHelp)

If Not FileExists(@ScriptDir & "\S2Launcher-ReadMe.html") Then
	GUICtrlDelete($MenuReadMeL)
EndIf

If Not FileExists(@ScriptDir & "\S2Server-ReadMe.html") Then
	GUICtrlDelete($MenuReadMeS)
EndIf

;Status Bar
$StatusBar1 = _GUICtrlStatusBar_Create($Form1, $barsize, $bar)

;Tooltips
GUICtrlSetTip($skipopenal, "Disable OpenAl API for sound and audio.")
GUICtrlSetTip($logging, "Enable logging")
GUICtrlSetTip($nocpubinding, "Prevent the game from using only one CPU.")
GUICtrlSetTip($showserver, "Show game server.")
GUICtrlSetTip($autosaveonexit, "Create a savegames backup when the game stop.")

;Play button languages
If $lang == "fr_FR" Then
	GUICtrlSetData($Play, "Jouer")
ElseIf $lang == "de_DE" Then
	GUICtrlSetData($Play, "Spieler")
ElseIf $lang == "en_UK" Then
	GUICtrlSetData($Play, "Play")
ElseIf $lang == "en_US" Then
	GUICtrlSetData($Play, "Play")
ElseIf $lang == "es_ES" Then
	GUICtrlSetData($Play, "Jugador")
ElseIf $lang == "hu_HU" Then
	GUICtrlSetData($Play, "Játékos")
ElseIf $lang == "it_IT" Then
	GUICtrlSetData($Play, "Giocatore")
ElseIf $lang == "pl_PL" Then
	GUICtrlSetData($Play, "Gracz")
ElseIf $lang == "ru_RU" Then
	GUICtrlSetData($Play, "Игрок")
Else
	GUICtrlSetData($Play, "Play")
EndIf

;Settings Buttons
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

;Settings Checkboxes
If FileExists($inifile) Then
	If IniRead($inifile, "S2LAUNCHER", "skipopenal", "4") == 1 Then
		GUICtrlSetState($skipopenal, $GUI_CHECKED)
	EndIf
Else
	GUICtrlSetState($skipopenal, $GUI_CHECKED)
EndIf

If FileExists($inifile) Then
	If IniRead($inifile, "S2LAUNCHER", "nocpubinding", "4") == 1 Then
		GUICtrlSetState($nocpubinding, $GUI_CHECKED)
	EndIf
Else
	GUICtrlSetState($nocpubinding, $GUI_CHECKED)
EndIf

If IniRead($inifile, "S2LAUNCHER", "logging", "4") == 1 Then
	GUICtrlSetState($logging, $GUI_CHECKED)
EndIf

If IniRead($inifile, "S2LAUNCHER", "showserver", "4") == 1 Then
	GUICtrlSetState($showserver, $GUI_CHECKED)
EndIf

If IniRead($inifile, "S2LAUNCHER", "autosaveonexit", "4") == 1 Then
	GUICtrlSetState($autosaveonexit, $GUI_CHECKED)
EndIf

;Show GUI
GUISetState(@SW_SHOW, $Form1)

;Main loop
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_Save()
			_Exit()

		Case $Play
			GUISetState(@SW_HIDE, $Form1)
			_Save()
			_Play()
			_Wait()
			_Exit()

			$param = ""

			If IniRead($inifile, "S2LAUNCHER", "skipopenal", "4") == 1 Then
				$param &= " -skipopenal"
			EndIf

			If IniRead($inifile, "S2LAUNCHER", "logging", "4") == 1 Then
				$param &= " -logging"
			EndIf

			If IniRead($inifile, "S2LAUNCHER", "nocpubinding", "4") == 1 Then
				$param &= " -nocpubinding"
			EndIf

			If IniRead($inifile, "S2LAUNCHER", "showserver", "4") == 1 Then
				$param &= " -showserver"
			EndIf

			Run($path & "system\sacred2.exe" & $param)

			If IniRead($inifile, "S2LAUNCHER", "autosaveonexit", "0") == 1 Then
				TraySetToolTip("Waiting for Sacred 2 to stop," & @CRLF & "to create a savegames backup...")

				While ProcessExists("sacred2.exe")
					Sleep(1000)
				WEnd

				_Backup(1)
				Sleep(5000)
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

		Case $MenuExit
			_Save()
			_Exit()

		Case $MenuGitHub
			ShellExecute("https://github.com/PolluxTroy0/S2Launcher")

		Case $MenuSupport
			ShellExecute("https://darkmatters.org/forums/index.php?/topic/72314-sacred-2-downloads-sacred-2-gamelobbyserver-launcher/")

		Case $MenuReadMeL
			ShellExecute(@ScriptDir & "\S2Launcher-ReadMe.html")

		Case $MenuReadMeS
			ShellExecute(@ScriptDir & "\S2Server-ReadMe.html")

	EndSwitch
WEnd

;Play function (to start the game)
Func _Play()
	$param = ""
	If IniRead($inifile, "S2LAUNCHER", "skipopenal", "4") == 1 Then
		$param &= " -skipopenal"
	EndIf

	If IniRead($inifile, "S2LAUNCHER", "logging", "4") == 1 Then
		$param &= " -logging"
	EndIf

	If IniRead($inifile, "S2LAUNCHER", "nocpubinding", "4") == 1 Then
		$param &= " -nocpubinding"
	EndIf

	If IniRead($inifile, "S2LAUNCHER", "showserver", "4") == 1 Then
		$param &= " -showserver"
	EndIf

	Run($path & "system\sacred2.exe" & $param)
EndFunc

;Wait function (for game to sop)
Func _Wait()
	If IniRead($inifile, "S2LAUNCHER", "autosaveonexit", "0") == 1 Then
		TraySetToolTip("Waiting for Sacred 2 to stop," & @CRLF & "to create a savegames backup...")

		While ProcessExists("sacred2.exe")
			Sleep(1000)
		WEnd

		_Backup(1)
		Sleep(5000)
	EndIf
EndFunc

;Backup savegames function
Func _Backup($auto = 0)
	Sleep(500)

	$datetime = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
	$savefoldername = IniRead($inifile, "S2LAUNCHER", "savefoldername", "S2SavesBackup")

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
		MsgBox(64, "AutoBackup Saves", $CopyMsg)
	Else
		TrayTip("AutoBackup Saves", $CopyMsg, 5, $CopyIcon)
	EndIf

	Sleep(500)
EndFunc

;Search github for updates
Func _Search($File, $Search, $keyname, $valuename)
	Local $Lines
	$Line = "0"
	$Result = "0"

	_FileReadToArray($File, $Lines)
	If @error <> "0" Then
		$Result = "0"
	Else
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
	EndIf

	If $Result == "0" Then
		$RegValue = RegRead($keyname, $valuename)
		If @error <> 0 Then
			$Result = "0"
		Else
			$Result = $RegValue
		EndIf
	EndIf

	Return $Result
EndFunc

;Save launcher settings
Func _Save()
	If GUICtrlRead($skipopenal) == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "skipopenal", "1")
	Else
		IniWrite($inifile, "S2LAUNCHER", "skipopenal", "0")
	EndIf

	If GUICtrlRead($logging) == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "logging", "1")
	Else
		IniWrite($inifile, "S2LAUNCHER", "logging", "0")
	EndIf

	If GUICtrlRead($nocpubinding) == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "nocpubinding", "1")
	Else
		IniWrite($inifile, "S2LAUNCHER", "nocpubinding", "0")
	EndIf

	If GUICtrlRead($showserver) == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "showserver", "1")
	Else
		IniWrite($inifile, "S2LAUNCHER", "showserver", "0")
	EndIf

	If GUICtrlRead($autosaveonexit) == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "autosaveonexit", "1")
	Else
		IniWrite($inifile, "S2LAUNCHER", "autosaveonexit", "0")
	EndIf
EndFunc

;Update launcher
Func _Update()
	ProcessClose("S2LauncherUpdater.exe")
	FileDelete(@ScriptDir & "\S2LauncherUpdater.exe")

	If IniRead($inifile, "S2LAUNCHER", "update", "1") == "1" Then
		IniWrite($inifile, "S2LAUNCHER", "update", "1")
		$url = "https://api.github.com/repos/PolluxTroy0/S2Launcher/releases/latest"
		$file = @ScriptDir & "\s2lu"
		$search = "browser_download_url"
		$start = '"browser_download_url":"https://github.com/PolluxTroy0/S2Launcher/releases/download/v'
		$end = '/S2Launcher.exe"'

		;RunWait(@ComSpec & " /c " & 'curl "' & $url & '" --output "' & $file & '"', "", @SW_HIDE)
		INetGet($url, $file)

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
			$Line = FileReadLine($File, $i)
			$Value = _StringBetween($Line, $start, $end)
			If @error Then
				$Result = "0"
			Else
				$Result = $Value[0]
			EndIf
		Else
			$Result = "0"
		EndIf

		FileDelete($file)

		If $Result <> "0" Then
			$CurrentVer = FileGetVersion(@ScriptDir & "\S2Launcher.exe", $FV_FILEVERSION)
			$Compare = _StringCompareVersions($CurrentVer, $Result)
			If $Compare == -1 Then
				$updatedl = MsgBox(64+4, "Sacred 2 Launcher v." & $appversion, "A newer version (" & $Result & ") of the launcher is available. Do you want to download it ?" )
				If $updatedl == "6" Then
					ProcessClose("S2LauncherUpdater.exe")
					Sleep(500)
					FileInstall("S2LauncherUpdater.exe", @ScriptDir & "\S2LauncherUpdater.exe", 1)
					Run(@ScriptDir & "\S2LauncherUpdater.exe https://github.com/PolluxTroy0/S2Launcher/releases/download/v" & $Result & "/S2Launcher.exe S2Launcher.exe", @ScriptDir)
					Exit
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

;Exit launcher
Func _Exit()
	FileDelete(@TempDir & "\splash.jpg")
	Exit
EndFunc

;Exe version compare
Func _StringCompareVersions($s_Version1, $s_Version2 = "0.0.0.0")
    SetError((StringIsDigit(StringReplace($s_Version1, ".", ""))=0) + 2 * (StringIsDigit(StringReplace($s_Version2, ".", ""))=0))
    If @error>0 Then Return 0; Ought to Return something!

    Local $i_Index, $i_Result, $ai_Version1, $ai_Version2

    $ai_Version1 = StringSplit($s_Version1, ".")
    $ai_Version2 = StringSplit($s_Version2, ".")
    $i_Result = 0; Assume strings are equal

    If $ai_Version1[0] <> 4 Then ReDim $ai_Version1[5]
    For $i_Index = 1 To 4
        $ai_Version1[$i_Index] = Int($ai_Version1[$i_Index])
    Next

    If $ai_Version2[0] <> 4 Then ReDim $ai_Version2[5]
    For $i_Index = 1 To 4
        $ai_Version2[$i_Index] = Int($ai_Version2[$i_Index])
    Next

    For $i_Index = 1 To 4
        If $ai_Version1[$i_Index] < $ai_Version2[$i_Index] Then; Version1 older than Version2
            $i_Result = -1
        ElseIf $ai_Version1[$i_Index] > $ai_Version2[$i_Index] Then; Version1 newer than Version2
            $i_Result = 1
        EndIf
        If $i_Result <> 0 Then ExitLoop
    Next

    Return $i_Result
EndFunc