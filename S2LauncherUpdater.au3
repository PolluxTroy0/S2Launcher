#AutoIt3Wrapper_Icon=sacred2.ico
#AutoIt3Wrapper_Outfile=S2LauncherUpdater.exe
#AutoIt3Wrapper_OutFile_Type=exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=Sacred 2 Launcher Updater
#AutoIt3Wrapper_Res_ProductName=Sacred 2 Launcher Updater
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=PolluxTroy (Discord: Pollux Troy#0231)
#AutoIt3Wrapper_Res_LegalCopyright=PolluxTroy (Discord: Pollux Troy#0231)

#include <InetConstants.au3>

If $CmdLine[0] <> 0 Then

	$link = $CmdLine[1]
	$file = $CmdLine[2]

	ProcessClose("S2Launcher.exe")
	Sleep(500)
	FileDelete(@ScriptDir & "\S2Launcher.exe")
	Sleep(500)
	INetGet($link, @ScriptDir & "\" & $file)

	Run(@ScriptDir & "\" & $file)

	Exit

Else
	Exit
EndIf