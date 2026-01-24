@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

FOR %%C IN (
    .fabric
    .mixin.out
    .physics_mod_cache
    .replay_cache
    cache
    controllable_natives
    crash-reports
    debug
    Distant_Horizons_server_data\REPLAY
    local
    logs
    replay_recordings
    voicechat_recordings
    voxelmap\cache
    config\spark\tmp
    config\spark\tmp-client
) DO (
    IF EXIST "%%C" RMDIR /S /Q "%%C"
    MKDIR "%%C"
    ATTRIB +H "%%C"
)

DEL /Q "config\crash_assistant\modlist.json" >NUL 2>&1
DEL /Q "config\skinshuffle.rem\skin-caches.json.rem" >NUL 2>&1
DEL /Q "config\voicechat\username-cache.json" >NUL 2>&1
DEL /Q "config\jade\usernamecache.json" >NUL 2>&1

IF EXIST "winevent.ps1" (
    powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "winevent.ps1"
)

FOR /R %%F IN (*.rem *.bak *.tmp *.old *.log .gitignore) DO (
    IF EXIST "%%F" ATTRIB +H "%%F"
)

FOR /D /R %%D IN (*.rem *.bak *.tmp *.old) DO (
    ATTRIB +H "%%D"
)
