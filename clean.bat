@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

RMDIR /S /Q ".fabric"
RMDIR /S /Q ".replay_cache"
RMDIR /S /Q "cache"
RMDIR /S /Q "controllable_natives"
RMDIR /S /Q "crash-reports"
RMDIR /S /Q "debug"
RMDIR /S /Q "Distant_Horizons_server_data\REPLAY"
RMDIR /S /Q "logs"
RMDIR /S /Q "voxelmap\cache"

DEL "config\crash_assistant\modlist.json"

ATTRIB -H "servers.dat.bak"
DEL "servers.dat.bak"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "winevent.ps1"

MKDIR ".fabric"
MKDIR ".replay_cache"
MKDIR "cache"
MKDIR "controllable_natives"
MKDIR "crash-reports"
MKDIR "debug"
MKDIR "Distant_Horizons_server_data\REPLAY"
MKDIR "logs"
MKDIR "voxelmap\cache"

ATTRIB +H ".fabric"
ATTRIB +H ".replay_cache"
ATTRIB +H "cache"
ATTRIB +H "controllable_natives"
ATTRIB +H "crash-reports"
ATTRIB +H "debug"
ATTRIB +H "Distant_Horizons_server_data\REPLAY"
ATTRIB +H "logs"
ATTRIB +H "voxelmap\cache"
