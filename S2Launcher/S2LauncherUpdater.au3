#AutoIt3Wrapper_Icon=sacred2.ico
#AutoIt3Wrapper_Outfile=S2LauncherUpdater.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Launcher Updater
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Launcher Updater
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=PolluxTroy
#AutoIt3Wrapper_Res_LegalCopyright=PolluxTroy

#include <InetConstants.au3>

If $CmdLine[0] <> 0 Then

	SplashTextOn("Sacred 2 Launcher Updater", "Downloading update...", 400, 50, -1, -1)

	$link = $CmdLine[1]
	$file = $CmdLine[2]

	ProcessClose("S2Launcher.exe")
	Sleep(500)
	FileDelete(@ScriptDir & "\S2Launcher.exe")
	Sleep(500)
	INetGet($link, @ScriptDir & "\" & $file)
	If @error Then
		MsgBox(16, "Sacred 2 Launcher Updater", "An error occured while downloading the launcher update." & @CRLF & "Please download the update manually and replace S2Launcher.exe in the game root folder.")
		Exit
	EndIf

	Run(@ScriptDir & "\" & $file)

	Exit

Else
	Exit
EndIf