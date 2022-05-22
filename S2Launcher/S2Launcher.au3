#AutoIt3Wrapper_Icon=s2launcher.ico
#AutoIt3Wrapper_Outfile=S2Launcher.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Launcher
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Launcher
#AutoIt3Wrapper_Res_ProductVersion=1.0.5.0
#AutoIt3Wrapper_Res_Fileversion=1.0.5.0
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

;Executable must be nammed S2Launcher.exe
If @ScriptName <> "S2Launcher.exe" Then
	MsgBox(16, "Sacred 2 Launcher", 'Error : The Sacred 2 Launcher executable must be nammed "S2Launcher.exe" !')
	Exit
EndIf

;Variables
$appversion = FileGetVersion(@ScriptFullPath, $FV_FILEVERSION)
Global $path = @ScriptDir & "\"
Global $inifile = @ScriptDir & "\S2Launcher.ini"

;Check for update
_Update()

;S2Server Update
$InternalVersion = "1.0.1.0"
$InstalledVersion = FileGetVersion($path & "S2Server.exe", $FV_FILEVERSION)
$Compare = _StringCompareVersions($InstalledVersion, $InternalVersion)
If $Compare == -1 Then
	$ServerNeedUpdate = 1
Else
	$ServerNeedUpdate = 0
EndIf

;Autostart
If IniRead($inifile, "S2LAUNCHER", "autostart", "0") == "1" Then
	_Play()
	_Wait()
	_Exit()
Else
	IniWrite($inifile, "S2LAUNCHER", "autostart", "0")
EndIf

;Splashscreen
FileInstall("splash.jpg", @TempDir & "\splash.jpg", 1)

;Game executable version
$ver = FileGetVersion(@ScriptDir & "\system\sacred2.exe", $FV_FILEVERSION)
If @error Then
	$ver = "0.0.0.0"
EndIf

;Game language
$CustomFile = @UserProfileDir & "\AppData\Local\Ascaron Entertainment\Sacred 2\optionsCustom.txt" ;Custom options path
$lang = _Search($CustomFile, "locale.language", "Language")
$speech = _Search($CustomFile, "locale.speech", "Speech")
$track = _Search($CustomFile, "locale.movietrack", "MovieTrack")

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
;$MenuAutoStart = GUICtrlCreateMenuItem("AutoStart", $MenuFile)
$MenuBackupName = GUICtrlCreateMenuItem("Change backup folder name", $MenuFile)
$MenuUpdate = GUICtrlCreateMenuItem("Check for update on startup", $MenuFile)
$MenuSeparator1 = GUICtrlCreateMenuItem("", $MenuFile)
$MenuExit = GUICtrlCreateMenuItem("Exit", $MenuFile)
$MenuSettings = GUICtrlCreateMenu("Settings")
$MenuAdmin = GUICtrlCreateMenuItem("Please restart as administrator to enable this menu.", $MenuSettings)
GuiCtrlSetState($MenuAdmin, $GUI_DISABLE)
$MenuLanguage = GUICtrlCreateMenu("Language", $MenuSettings)
$MenuLde = GUICtrlCreateMenuItem("German (de_DE)", $MenuLanguage)
$MenuLen = GUICtrlCreateMenuItem("English (en_UK)", $MenuLanguage)
$MenuLfr = GUICtrlCreateMenuItem("French (fr_FR)", $MenuLanguage)
$MenuLes = GUICtrlCreateMenuItem("Spanish (es_ES)", $MenuLanguage)
$MenuLit = GUICtrlCreateMenuItem("Italian (it_IT)", $MenuLanguage)
$MenuSpeech = GUICtrlCreateMenu("Speech Lang.", $MenuSettings)
$MenuSde = GUICtrlCreateMenuItem("German (de_DE)", $MenuSpeech)
$MenuSen = GUICtrlCreateMenuItem("English (en_UK)", $MenuSpeech)
$MenuSfr = GUICtrlCreateMenuItem("French (fr_FR)", $MenuSpeech)
$MenuSes = GUICtrlCreateMenuItem("Spanish (es_ES)", $MenuSpeech)
$MenuSit = GUICtrlCreateMenuItem("Italian (it_IT)", $MenuSpeech)
$MenuTrack = GUICtrlCreateMenu("Movie Track", $MenuSettings)
$MenuT5 = GUICtrlCreateMenuItem("German (5)", $MenuTrack)
$MenuT6 = GUICtrlCreateMenuItem("English (6)", $MenuTrack)
$MenuT7 = GUICtrlCreateMenuItem("French (7)", $MenuTrack)
$MenuT8 = GUICtrlCreateMenuItem("Spanish (8)", $MenuTrack)
$MenuT9 = GUICtrlCreateMenuItem("Italian (9)", $MenuTrack)
$MenuHelp = GUICtrlCreateMenu("?")
$MenuReadMeL = GUICtrlCreateMenuItem("Launcher ReadMe", $MenuHelp)
$MenuReadMeS = GUICtrlCreateMenuItem("Server ReadMe", $MenuHelp)
$MenuSeparator2 = GUICtrlCreateMenuItem("", $MenuHelp)
$MenuGitHub = GUICtrlCreateMenuItem("View sources on GitHub", $MenuHelp)
$MenuSupport = GUICtrlCreateMenuItem("Get support on DarkMatters", $MenuHelp)
$MenuSeparator3 = GUICtrlCreateMenuItem("", $MenuHelp)
$MenuCreator = GUICtrlCreateMenuItem("Created by PolluxTroy", $MenuHelp)
GuiCtrlSetState(-1, $GUI_DISABLE)

;Check if lang/speech installed
Local $LangList[5] = ["de_DE", "en_UK", "fr_FR", "es_ES", "it_IT"]
Local $LangReqFiles[8] = ["global.res", "AppendBonus.csv", "AppendMaterial.csv", "AppendRare.csv", "DescriptionBonus.csv", "DescriptionMaterial.csv", "DescriptionRare.csv", "Optional.csv"]
Local $SpeechReqFiles[3] = ["soundresources.txt", "speechhq.zip", "speechlq.zip"]

;Check for required files
Local $LangCountArray[5] = [0, 0, 0, 0, 0]
Local $SpeechCountArray[5] = [0, 0, 0, 0, 0]
$LangCount = 0
$SpeechCount = 0
For $i = 0 To 4 Step 1
	For $j = 0 To 7 Step 1
		If FileExists($path & "locale\" & $LangList[$i] & "\" & $LangReqFiles[$j]) Then
			$LangCount = $LangCount + 1
		EndIf
		If $j= 7 Then
			$LangCountArray[$i] = $LangCount
			$LangCount = 0
		EndIf
	Next
Next
For $i = 0 To 4 Step 1
	For $j = 0 To 2 Step 1
		If FileExists($path & "locale\" & $LangList[$i] & "\" & $SpeechReqFiles[$j]) Then
			$SpeechCount = $SpeechCount + 1
		EndIf
		If $j= 2 Then
			$SpeechCountArray[$i] = $SpeechCount
			$SpeechCount = 0
		EndIf
	Next
Next

;Disable missing language
If $LangCountArray[0] <> 8 Then
	GUICtrlSetState($MenuLde, $GUI_DISABLE)
	GUICtrlSetData($MenuLde, "German (de_DE) not installed")
EndIf
If $LangCountArray[1] <> 8 Then
	GUICtrlSetState($MenuLen, $GUI_DISABLE)
	GUICtrlSetData($MenuLen, "English (en_UK) not installed")
EndIf
If $LangCountArray[2] <> 8 Then
	GUICtrlSetState($MenuLfr, $GUI_DISABLE)
	GUICtrlSetData($MenuLfr, "French (fr_FR) not installed")
EndIf
If $LangCountArray[3] <> 8 Then
	GUICtrlSetState($MenuLes, $GUI_DISABLE)
	GUICtrlSetData($MenuLes, "Spanish (es_ES) not installed")
EndIf
If $LangCountArray[4] <> 8 Then
	GUICtrlSetState($MenuLit, $GUI_DISABLE)
	GUICtrlSetData($MenuLit, "Italian (it_IT) not installed")
EndIf
If $SpeechCountArray[0] <> 3 Then
	GUICtrlSetState($MenuSde, $GUI_DISABLE)
	GUICtrlSetData($MenuSde, "German (de_DE) not installed")
	GUICtrlSetState($MenuT5, $GUI_DISABLE)
	GUICtrlSetData($MenuT5, "German (5) not installed")
EndIf
If $SpeechCountArray[1] <> 3 Then
	GUICtrlSetState($MenuSen, $GUI_DISABLE)
	GUICtrlSetData($MenuSen, "English (en_UK) not installed")
	GUICtrlSetState($MenuT6, $GUI_DISABLE)
	GUICtrlSetData($MenuT6, "English (6) not installed")
EndIf
If $SpeechCountArray[2] <> 3 Then
	GUICtrlSetState($MenuSfr, $GUI_DISABLE)
	GUICtrlSetData($MenuSfr, "French (fr_FR) not installed")
	GUICtrlSetState($MenuT7, $GUI_DISABLE)
	GUICtrlSetData($MenuT7, "French (7) not installed")
EndIf
If $SpeechCountArray[3] <> 3 Then
	GUICtrlSetState($MenuSes, $GUI_DISABLE)
	GUICtrlSetData($MenuSes, "Spanish (es_ES) not installed")
	GUICtrlSetState($MenuT8, $GUI_DISABLE)
	GUICtrlSetData($MenuT8, "Spanish (8) not installed")
EndIf
If $SpeechCountArray[4] <> 3 Then
	GUICtrlSetState($MenuSit, $GUI_DISABLE)
	GUICtrlSetData($MenuSit, "Italian (it_IT) not installed")
	GUICtrlSetState($MenuT9, $GUI_DISABLE)
	GUICtrlSetData($MenuT9, "Italian (9) not installed")
EndIf

;Mark active language
If $lang == "de_DE" Then
	GUICtrlSetState($MenuLde, $GUI_CHECKED)
ElseIf $lang == "en_UK" Then
	GUICtrlSetState($MenuLen, $GUI_CHECKED)
ElseIf $lang == "fr_FR" Then
	GUICtrlSetState($MenuLfr, $GUI_CHECKED)
ElseIf $lang == "es_ES" Then
	GUICtrlSetState($MenuLes, $GUI_CHECKED)
ElseIf $lang == "it_IT" Then
	GUICtrlSetState($MenuLit, $GUI_CHECKED)
Else
	GuiCtrlSetState($MenuLanguage, $GUI_DISABLE)
EndIf

;Mark active speech
If $speech == "de_DE" Then
	GUICtrlSetState($MenuSde, $GUI_CHECKED)
ElseIf $speech == "en_UK" Then
	GUICtrlSetState($MenuSen, $GUI_CHECKED)
ElseIf $speech == "fr_FR" Then
	GUICtrlSetState($MenuSfr, $GUI_CHECKED)
ElseIf $speech == "es_ES" Then
	GUICtrlSetState($MenuSes, $GUI_CHECKED)
ElseIf $speech == "it_IT" Then
	GUICtrlSetState($MenuSit, $GUI_CHECKED)
Else
	GuiCtrlSetState($MenuSpeech, $GUI_DISABLE)
EndIf

;Mark active movietrack
If $track == "5" Then
	GUICtrlSetState($MenuT5, $GUI_CHECKED)
ElseIf $track == "6" Then
	GUICtrlSetState($MenuT6, $GUI_CHECKED)
ElseIf $track == "7" Then
	GUICtrlSetState($MenuT7, $GUI_CHECKED)
ElseIf $track == "8" Then
	GUICtrlSetState($MenuT8, $GUI_CHECKED)
ElseIf $track == "9" Then
	GUICtrlSetState($MenuT9, $GUI_CHECKED)
Else
	GUICtrlSetState($MenuTrack, $GUI_DISABLE)
EndIf

;If IniRead($inifile, "S2LAUNCHER", "autostart", "4") == 1 Then
;	GUICtrlSetState($MenuAutoStart, $GUI_CHECKED)
;EndIf

If IniRead($inifile, "S2LAUNCHER", "update", "4") == 1 Then
	GUICtrlSetState($MenuUpdate, $GUI_CHECKED)
EndIf

If Not FileExists(@ScriptDir & "\S2Launcher.exe") Then
	GUICtrlDelete($MenuReadMeL)
EndIf

If Not FileExists(@ScriptDir & "\S2Server.exe") Then
	GUICtrlDelete($MenuReadMeS)
EndIf

;Disable settings submenus if not admin
If Not IsAdmin() Then
	GUICtrlDelete($MenuLanguage)
	GUICtrlDelete($MenuSpeech)
	GUICtrlDelete($MenuTrack)
Else
	GUICtrlDelete($MenuAdmin)
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
If $ServerNeedUpdate == 1 Then
	$serverinstall = 2
	GUICtrlSetData($Server, "Update" & @CRLF & "Server Launcher")
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
				ProcessClose("S2Server.exe")
				FileInstall("S2Server.exe", $path & "S2Server.exe", 1)
				GUISetState(@SW_HIDE, $Form1)
				_Save()
				ShellExecute(@ScriptFullPath)
				_Exit()
			ElseIf $serverinstall == 2 Then
				GuiCtrlSetState($Server, $GUI_DISABLE)
				GuiCtrlSetData($Server, "Updating...")
				ProcessClose("S2Server.exe")
				FileInstall("S2Server.exe", $path & "S2Server.exe", 1)
				Run($path & "S2Server.exe -update")
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

		Case $MenuBackupName
			GUISetState(@SW_HIDE, $Form1)
			$DirName = IniRead($inifile, "S2LAUNCHER", "savefoldername", "S2SavesBackup")
			$NewDirName = InputBox("Sacred 2 Launcher", "Change the savegames backup folder name to ?" & @CRLF, $DirName, "", 300, 150)
			If $NewDirName <> "" Then
				$NewDirName = StringReplace($NewDirName, " ", "")
				IniWrite($inifile, "S2LAUNCHER", "savefoldername", $NewDirName)
				DirMove($path & $DirName, $path & $NewDirName, 1)
			EndIf
			GUISetState(@SW_SHOW, $Form1)

		;Case $MenuAutoStart
		;	If IniRead($inifile, "S2LAUNCHER", "autostart", "0") == "1" Then
		;		IniWrite($inifile, "S2LAUNCHER", "autostart", "0")
		;		GUICtrlSetState($MenuUpdate, $GUI_UNCHECKED)
		;	Else
		;		IniWrite($inifile, "S2LAUNCHER", "autostart", "1")
		;		GUICtrlSetState($MenuUpdate, $GUI_CHECKED)
		;	EndIf

		Case $MenuUpdate
			If IniRead($inifile, "S2LAUNCHER", "update", "0") == "1" Then
				IniWrite($inifile, "S2LAUNCHER", "update", "0")
				GUICtrlSetState($MenuUpdate, $GUI_UNCHECKED)
			Else
				IniWrite($inifile, "S2LAUNCHER", "update", "1")
				GUICtrlSetState($MenuUpdate, $GUI_CHECKED)
			EndIf

		Case $MenuGitHub
			ShellExecute("https://github.com/PolluxTroy0/S2Launcher")

		Case $MenuSupport
			ShellExecute("https://darkmatters.org/forums/index.php?/topic/72314-sacred-2-downloads-sacred-2-gamelobbyserver-launcher/")

		Case $MenuReadMeL
			FileInstall("ReadMe.html", @ScriptDir & "\S2Launcher-ReadMe.html", 1)
			ShellExecute(@ScriptDir & "\S2Launcher-ReadMe.html")

		Case $MenuReadMeS
			FileInstall("ReadMe.html", @ScriptDir & "\S2Server-ReadMe.html", 1)
			ShellExecute(@ScriptDir & "\S2Server-ReadMe.html")

		Case $MenuLde
			_Change("Language", "de_DE")

		Case $MenuLen
			_Change("Language", "en_UK")

		Case $MenuLfr
			_Change("Language", "fr_FR")

		Case $MenuLes
			_Change("Language", "es_ES")

		Case $MenuLit
			_Change("Language", "it_IT")

		Case $MenuSde
			_Change("Speech", "de_DE")

		Case $MenuSen
			_Change("Speech", "en_UK")

		Case $MenuSfr
			_Change("Speech", "fr_FR")

		Case $MenuSes
			_Change("Speech", "es_ES")

		Case $MenuSit
			_Change("Speech", "it_IT")

		Case $MenuT5
			_Change("MovieTrack", "5")

		Case $MenuT6
			_Change("MovieTrack", "6")

		Case $MenuT7
			_Change("MovieTrack", "7")

		Case $MenuT8
			_Change("MovieTrack", "8")

		Case $MenuT9
			_Change("MovieTrack", "9")

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

	$RegU = "HKEY_CURRENT_USER\SOFTWARE\Ascaron Entertainment\Sacred 2"
	$RegL32 = "HKEY_LOCAL_MACHINE\SOFTWARE\Ascaron Entertainment\Sacred 2"
	$RegL64 = "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ascaron Entertainment\Sacred 2"
	$RegPathU = RegRead($RegU, "InstallPath")
	$RegVerU = RegRead($RegU, "CurrentVersion")
	$RegLangU = RegRead($RegU, "Language")
	$RegSpeechU = RegRead($RegU, "Speech")
	$RegTrackU = RegRead($RegU, "MovieTrack")
	$RegPathL32 = RegRead($RegL32, "InstallPath")
	$RegVerL32 = RegRead($RegL32, "CurrentVersion")
	$RegLangL32 = RegRead($RegL32, "Language")
	$RegSpeechL32 = RegRead($RegL32, "Speech")
	$RegTrackL32 = RegRead($RegL32, "MovieTrack")
	$RegPathL64 = RegRead($RegL64, "InstallPath")
	$RegVerL64 = RegRead($RegL64, "CurrentVersion")
	$RegLangL64 = RegRead($RegL64, "Language")
	$RegSpeechL64 = RegRead($RegL64, "Speech")
	$RegTrackL64 = RegRead($RegL64, "MovieTrack")
	$RegSave = 'Windows Registry Editor Version 5.00' & @CRLF & @CRLF & _
	'[' & $RegU & ']' & @CRLF & _
	'"Language"="' & $RegLangU & '"' & @CRLF & _
	'"Speech"="' & $RegSpeechU & '"' & @CRLF & _
	'"MovieTrack"="' & $RegTrackU & '"' & @CRLF & @CRLF & _
	'[' & $RegL32 & ']' & @CRLF & _
	'"Language"="' & $RegLangL32 & '"' & @CRLF & _
	'"Speech"="' & $RegSpeechL32 & '"' & @CRLF & _
	'"MovieTrack"="' & $RegTrackL32 & '"' & @CRLF & _
	'"CurrentVersion"="' & $RegVerL32 & '"' & @CRLF & _
	'"InstallPath"="' & $RegPathL32 & '"' & @CRLF & @CRLF & _
	'[' & $RegL64 & ']' & @CRLF & _
	'"Language"="' & $RegLangL64 & '"' & @CRLF & _
	'"Speech"="' & $RegSpeechL64 & '"' & @CRLF & _
	'"MovieTrack"="' & $RegTrackL64 & '"' & @CRLF & _
	'"CurrentVersion"="' & $RegVerL64 & '"' & @CRLF & _
	'"InstallPath"="' & $RegPathL64 & '"'
	FileWrite($backupfolder & $datetime & $extsave & "\registry.reg", $RegSave)

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
Func _Search($File, $Search, $valuename)
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
			$keyname = "HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2"
			;$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Ascaron Entertainment\Sacred 2"
			;$keyname = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2"
		$RegValue = RegRead($keyname, $valuename)
		If @error <> 0 Then
			$Result = "0"
		Else
			$Result = $RegValue
		EndIf
	EndIf

	Return $Result
EndFunc

Func _Change($type, $value)
	GUISetState(@SW_HIDE, $Form1)
	SplashTextOn("Sacred 2 Launcher", "Changing " & $type & "...", 400, 50, -1, -1)

	RegWrite("HKEY_CURRENT_USER\Software\Ascaron Entertainment\Sacred 2", $type, "REG_SZ", $value)
	;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Ascaron Entertainment\Sacred 2", $type, "REG_SZ", $value)
	;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Ascaron Entertainment\Sacred 2", $type, "REG_SZ", $value)

	Local $Lines
	$Line = "0"
	$Result = "0"
	$File = @UserProfileDir & "\AppData\Local\Ascaron Entertainment\Sacred 2\optionsCustom.txt"
	If $type == "Language" Then
		$Search = "locale.language"
	ElseIf $type == "Speech" Then
		$Search = "locale.speech"
	ElseIf $type == "MovieTrack" Then
		$Search = "locale.movietrack"
	EndIf

	_FileReadToArray($File, $Lines)
	If @error <> "0" Then
		$Result = "0"
	Else
		For $i = 1 To $Lines[0]
			If StringInStr($Lines[$i], $Search) Then
				$Lines[$i] = $Search & ' = ' & '"' & $value & '"'
				_FileWriteFromArray($File, $Lines, 1)
				ExitLoop
			EndIf
		Next
	EndIf

	_Save()
	ShellExecute(@ScriptFullPath)
	SplashOff()
	_Exit()
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
    $i_Result = 0

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