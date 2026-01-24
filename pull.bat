@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

IF "%~1"=="__RUN_TEMP__" (
    GOTO CHECK
)

ECHO preparing...

COPY /Y "%~f0" "%TEMP%\%~n0_tmp.bat" >NUL
"%TEMP%\%~n0_tmp.bat" __RUN_TEMP__ "%~dp0"
EXIT /B

:CHECK

CD /D "%~2"

WHERE git.exe >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO you have to install git bash.
    PAUSE
    EXIT /B 1
)

:ASK

SET /P confirm="are you sure you want to pull... (Y/n) >> "
IF /I "%confirm%"=="y" (
    GOTO MAIN
) ELSE {
    GOTO ASK
}

:MAIN

IF NOT EXIST "..\pull.tmp" (
    MKDIR "..\pull.tmp"
    ATTRIB +H "..\pull.tmp"
)

@REM MIGRATE PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

IF EXIST "replay_recordings" (
    ECHO migrating replays...
    FOR /F "delims=" %%F IN ('DIR /B /A-D "replay_recordings"') DO (
        MOVE /Y "replay_recordings\%%F" "replays\"
    )
    RMDIR /S /Q "replay_recordings"
)

IF EXIST "voicechat_recordings" (
    ECHO migrating voices...
    FOR /F "delims=" %%F IN ('DIR /B /A-D "voicechat_recordings"') DO (
        MOVE /Y "voicechat_recordings\%%F" "voices\"
    )
    RMDIR /S /Q "voicechat_recordings"
)

@REM BACK UP PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

FOR %%D IN (
    cape_overrides
    config
    data
    defaultconfigs
    Distant_Horizons_server_data
    downloads
    polymer
    replays
    resourcepacks
    saves
    schematics
    screenshots
    server-resource-packs
    shaderpacks
    skin_overrides
    voxelmap
) DO (
    IF EXIST "%%D" (
        ECHO backing up %%D...
        XCOPY "%%D" "..\pull.tmp\%%D\" /E /I /H /Y /Q >NUL
    )
)

ECHO backing up user game options...

IF EXIST "options.txt" MOVE /Y "options.txt" "..\pull.tmp\" >NUL
IF EXIST "servers.dat" MOVE /Y "servers.dat" "..\pull.tmp\" >NUL
IF EXIST "whitelist.json" MOVE /Y "whitelist.json" "..\pull.tmp\" >NUL

@REM RESET PHASE                                ---- ---- ---- ---- ---- ---- ---- ----

ECHO fetching latest version...
git.exe fetch origin main

ECHO resetting game instance...
git.exe reset --hard origin/main

ECHO cleaning untracked files...
git.exe clean -fd

@REM RESTORE PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

ECHO restoring up user game options...

IF EXIST "..\pull.tmp\whitelist.json" MOVE /Y "..\pull.tmp\whitelist.json" ".\" >NUL
IF EXIST "..\pull.tmp\servers.dat" MOVE /Y "..\pull.tmp\servers.dat" ".\" >NUL
IF EXIST "..\pull.tmp\options.txt" MOVE /Y "..\pull.tmp\options.txt" ".\" >NUL

FOR %%D IN (
    cape_overrides
    config
    data
    defaultconfigs
    Distant_Horizons_server_data
    downloads
    polymer
    replays
    resourcepacks
    saves
    schematics
    screenshots
    server-resource-packs
    shaderpacks
    skin_overrides
    voxelmap
) DO (
    IF EXIST "..\pull.tmp\%%D" (
        ECHO restoring %%D...
        XCOPY "..\pull.tmp\%%D" "%%D" /E /I /H /Y /Q >NUL
    )
)

@REM CLEANUP PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

ATTRIB -H "..\pull.tmp"
RMDIR /S /Q "..\pull.tmp"

@REM TWEAK PHASE                                ---- ---- ---- ---- ---- ---- ---- ----

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

@REM HIDE PHASE                                 ---- ---- ---- ---- ---- ---- ---- ----

FOR /R %%F IN (*.rem *.bak *.tmp *.old *.log .gitignore) DO (
    IF EXIST "%%F" ATTRIB +H "%%F"
)

FOR /D /R %%D IN (*.rem *.bak *.tmp *.old) DO (
    ATTRIB +H "%%D"
)

@REM PREVENT CRASH FROM EARS MOD
ATTRIB -H "ears-debug.log"

ECHO all done.
PAUSE
