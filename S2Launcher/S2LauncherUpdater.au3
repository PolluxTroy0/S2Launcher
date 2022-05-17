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
	$link = $CmdLine[1]
	$file = $CmdLine[2]
	$path = @ScriptDir & "\"
	$title = "Sacred 2 Launcher Updater"
	$url = "https://github.com/PolluxTroy0/S2Launcher/releases/latest"
	$dlmsg = "Downloading update..."
	$error = "An error occured while downloading the update." & @CRLF & "Please download the update manually and replace " & $file & " in the game root folder."

	SplashTextOn($title, $dlmsg, 400, 50, -1, -1)
	ProcessClose($file)
	Sleep(500)
	FileDelete($path & $file)
	Sleep(500)
	INetGet($link, $path & $file)
	If @error Then
		MsgBox(16, $title, $error)
		ShellExecute($url)
		Exit
	EndIf
	Run($path & $file)
	Exit
EndIf