╔═════════════════════════════════════════════════════════════════════════════════════╗
║                            ► SACRED 2 SERVER LAUNCHER ◄                             ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 Allow you to start a lobby server (for online play) and/or a game server for
 Sacred 2 Gold, with a simple GUI to set all required parameters. Everything needed
 for this is bundled within the launcher.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► IMPORTANT THINGS TO KNOW                                                        ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Player's characters will not be stored on the server, only in player's computer.

 ● It seems that after some days of running, some instabilitys may occurs on the
   server. It is recommended to restart it from time to time.

 ● All players must use the same game version with same mods as the running server
   to be aple to play and avoid bugs.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► REMINDER                                                                        ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 Always make a backup of your game and savegames before using any mods or program.
 Even if developers do their best to provide bugfree mods or program, there is always
 a small chance that it could break up something in your games or savegames.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► REQUIREMENTS                                                                    ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● .NET Framework 4.6.1 (for the Lobby application)
   https://www.microsoft.com/fr-fr/download/details.aspx?id=49982

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► INSTALLATION                                                                    ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Copy S2Server.exe to the root of Sacred 2 game folder.
   Required files will be extracted at first launch in S2Server folder.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► NETWORK REQUIREMENTS                                                            ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Port forwarding to server host IP (on your router) :
    ● 6800 (for lobby server),
    ● 6801 (for chat server),
    ● 6802 (for game server).

   Each router's interface are different, but you may find a "Port Forwarding" section
   where you can do that. For example, if the computer on wich you want to host the
   lobby server or game server have the IP address 192.168.1.5, you musd add a rule
   that redirect each ports to this computer's IP address for TCP and UDP protocol.

 ● Allow ports 6800, 6801 and 6802 into your firewall if needed.

 ● Allow the game client, lobby server and game server into your firewall.
   You can use S2Firewall.cmd to do it easily, located in S2Server folder.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► USAGE                                                                           ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Use the GUI to modify settings and start a game server.

 ● If you set server mode to "LAN", the server is only accessible on your network.

 ● If you set server mode to "OpenNet", a lobby server will be started in order for
   everyone to be able to join it, and a game server will be started.

 ● Please refer to tooltips in the GUI to understand what parameters are used for.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► ACCESSING THE LOBBY/GAME SERVER                                                 ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Open this file in a text editor : .\scripts\optionsDefault.txt
 ● Modify this line (~10) : lobby_ip = "eu.sacred2.net", by replacing "eu.sacred2.net"
   with the IP address of the lobby server to connect to.
    ● If you start the game on the same computer where the lobby server is launched,
      use "localhost" as the IP address.
    ● If you want someone to connect to the lobby server from the internet, he/she/it
      must use the public IP address of the server. You can use this website to
      find it : https://www.whatismyip.com/
 ● Save the file then launch the game. Don't forget to start the server before.

 ■ If you set the server mode to OpenNet :
  ● Go to Multiplayer, then click on "New account",
  ● Fill in the form like desired. Remember not to use sensible data for password,
  ● Don't worry about CD Key, enter anything you want,
  ● Validate the registration form,
  ● Now, you can use this newly created account to log into the lobby server,
  ● In the main window, you must now be abble to see and join your server.

 ■ If you set the server mode to LAN :
  ● Go to Multiplayer, then click on "Local",
  ● In the main window, you must now be abble to see and join your server.

 If you get an error 61 or 64, that's something related to the game can't have
 access to the lobby or game server. Check NETWORK REQUIREMENTS section of
 this ReadMe.

 ■ This is a network example :

       ┌───────────────────┐     ┌───────────────────┐     ┌───────────────────┐
       │     COMPUTER 1    │     │     COMPUTER 2    │     │     COMPUTER 3    │
       │   Local Network   │     │   Local Network   │     │   Online  Network │
       │ IP : 192.168.1.10 │     │ IP : 192.168.1.11 │     │ IP : 123.231.79.6 │
       └─────────┬─────────┘     └─────────┬─────────┘     └─────────┬─────────┘
                 │                         │                         │ 
                 ↓                         ↓                         ↓ 
         Must connect to           Must connect to           Must connect to
           192.168.1.5               192.168.1.5               76.23.151.21
          on port  6800             on port  6800              on port  6800
                 │                         │                         │
                 │   ┌─────────────────────┘                         │
          ┌──────┘   │       ┌───────────────────────────────────────┘
          │          │       │
    ┌─────↓──────────↓───────↓─┐                         ┌────────────────────────┐
    │    COMPUTER 4 RUNNING    │                         │      COMPUTER 4        │
    │   LOBBY AND//OR SERVER   │     Must connect to     │  GAME CLIENT  RUNNING  │
    │ Local IP : 192.168.1.5   ◄─────   127.0.0.1   ◄────┤  ON SAME  COMPUTER AS  │
    │ Public IP : 76.23.151.21 │      on port  6800      │ THE GAME/LOBBY SERVER  │
    │ Ports 6800-6802 are      │                         │ Local IP : 192.168.1.5 │
    │ forwarded to local IP.   │                         └────────────────────────┘
    └──────────────────────────┘

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► STOP LOBBY AND GAME SERVER                                                      ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● To properly stop the lobby server, use the X key inside the lobby server window.
 ● To properly stop the game server, user CTRL+C inside the game server window.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► CONFIGURATION FILE                                                              ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 All settings are stored in S2Server.ini file inside S2Server folder.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► SIMPLE START                                                                    ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 If you want to automatically start the server with a shortcut, bypassing the GUI and
 using settings in S2Server.ini, you can create a shortcut to S2Server.exe with the
 following argument : -start.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► DEDICATED SERVER                                                                ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 If you want to create a dedicated server without unnecessary game files,
 copy these files and folders (with structure) into S2Server folder :

  ● \system\MemLeaks_s2gs.xml			● \pak\generic.zip
  ● \system\MemMgr.dll				● \pak\persector.zip
  ● \system\orcSystem.dll			● \pak\spawn.zip
  ● \system\plugins_srv.cfg			● \scripts\autoexec.txt
  ● \system\plugin_filesystem.dll		● \scripts\behaviour.txt
  ● \system\plugin_fileZip.dll			● \scripts\genMipMapInfo.txt
  ● \system\plugin_win32platform.dll		● \scripts\heightmap.txt
  ● \system\s2core.dll				● \scripts\landscape.txt
  ● \system\s2gs.exe				● \scripts\roadmap.txt
  ● \system\s2logic.dll				● \scripts\startPos.txt
  ● \system\s2logicdll.dll			● \scripts\server\*.*
  ● \system\s2vista.dll				● \scripts\server\heroes\*.*
  ● \system\stlport.5.0.dll			● \scripts\shared\*.*
  ● \system\tincat3.dll
  ● \system\zlib1.dll

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► LOBBY MAIN ACCOUNT                                                              ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 The Lobby database already contain an account :
  ● Username : Sacred2LobbyAccount
  ● Password : password
 This account is/could be used by the game server to login into the lobby.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► FILES USED BY THE LAUNCHER                                                      ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● accounts.sqlite		: Database containing users accounts.
 ● BouncyCastle.Crypto.dll	: Used for network data encryption.
 ● channels.sqlite		: Databse used for chat channels.
 ● S2Firewall.cmd		: Can be used to enable/disable firewall rules.
 ● S2Library.dll		: Library used for Sacred 2.
 ● S2Lobby.exe			: Lobby server main application.
 ● S2Lobby.exe.config		: Configuration file for lobby server application.
 ● S2Server.exe			: Main application for the launcher.
 ● S2Server.ini			: Store all settings for the launcher application.
 ● S2Server_ReadMe.txt		: This ReadMe.
 ● System.Data.SQLite.dll	: SQLite dll used to manage databases.
 ● sources.zip			: Source files used to build launcher and lobby.

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► CREDITS AND SOURCES                                                             ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● Sacred 2 Server Launcher
    ● Author : PolluxTroy (Discord: Pollux Troy#0231)  
    ● Sources : https://github.com/PolluxTroy0/S2Launcher

 ● Sacred 2 Lobby Emulator
    ● Sources : https://github.com/pnxr/sacred2-lobby-emulator/

╔═════════════════════════════════════════════════════════════════════════════════════╗
║ ► VESRIONS HISTORY                                                                ◄ ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
 ● v1.0 - 14/05/2022 - Initial Release