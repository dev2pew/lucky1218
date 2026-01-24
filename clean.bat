@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

RMDIR /S /Q ".fabric"
RMDIR /S /Q ".mixin.out"
RMDIR /S /Q ".physics_mod_cache"
RMDIR /S /Q ".replay_cache"
RMDIR /S /Q "cache"
RMDIR /S /Q "controllable_natives"
RMDIR /S /Q "crash-reports"
RMDIR /S /Q "debug"
RMDIR /S /Q "Distant_Horizons_server_data\REPLAY"
RMDIR /S /Q "local"
RMDIR /S /Q "logs"
RMDIR /S /Q "replay_recordings"
RMDIR /S /Q "voicechat_recordings"
RMDIR /S /Q "voxelmap\cache"

RMDIR /S /Q "config\spark\tmp"
RMDIR /S /Q "config\spark\tmp-client"

DEL "config\crash_assistant\modlist.json"

DEL "config\skinshuffle.rem\skin-caches.json.rem"
DEL "config\voicechat\username-cache.json"
DEL "config\jade\usernamecache.json"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "winevent.ps1"

MKDIR ".fabric"
MKDIR ".mixin.out"
MKDIR ".physics_mod_cache"
MKDIR ".replay_cache"
MKDIR "cache"
MKDIR "controllable_natives"
MKDIR "crash-reports"
MKDIR "debug"
MKDIR "Distant_Horizons_server_data\REPLAY"
MKDIR "local"
MKDIR "logs"
MKDIR "replay_recordings"
MKDIR "voicechat_recordings"
MKDIR "voxelmap\cache"

MKDIR "config\spark\tmp"
MKDIR "config\spark\tmp-client"

ATTRIB +H ".fabric"
ATTRIB +H ".mixin.out"
ATTRIB +H ".physics_mod_cache"
ATTRIB +H ".replay_cache"
ATTRIB +H "cache"
ATTRIB +H "controllable_natives"
ATTRIB +H "crash-reports"
ATTRIB +H "debug"
ATTRIB +H "Distant_Horizons_server_data\REPLAY"
ATTRIB +H "local"
ATTRIB +H "logs"
ATTRIB +H "replay_recordings"
ATTRIB +H "voicechat_recordings"
ATTRIB +H "voxelmap\cache"

ATTRIB +H "config\spark\tmp"
ATTRIB +H "config\spark\tmp-client"

FOR /R %%F IN (*
    ATTRIB +H "%%F"
)

FOR /R %%D IN (*.rem\ *.bak\ *.old\ *.log\) DO (
    ATTRIB +H "%%D"
)
