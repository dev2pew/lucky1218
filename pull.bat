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
IF %ERRORLEVEL% 1 (
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

ECHO migrating your game files...
ECHO migrating replays...

IF EXIST "replay_recordings" (
    FOR /F "delims=" %%F IN ('DIR /B /A-D "replay_recordings"') DO (
        MOVE /Y "replay_recordings\%%F" "replays\"
    )
)

RMDIR /S /Q "replay_recordings"

IF EXIST "voicechat_recordings" (
    FOR /F "delims=" %%F IN ('DIR /B /A-D "voicechat_recordings"') DO (
        MOVE /Y "voicechat_recordings\%%F" "voices\"
    )
)

RMDIR /S /Q "voicechat_recordings"

ECHO migrated game files.

@REM BACK UP PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

ECHO backing up your game files...
ECHO backing up your capes...

IF EXIST "cape_overrides" (
    XCOPY "cape_overrides" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your mod configurations...

IF EXIST "config" (
    XCOPY "config" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up mod-based resources...

IF EXIST "data" (
    XCOPY "data" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your default world configurations...

IF EXIST "defaultconfigs" (
    XCOPY "defaultconfigs" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up Distant Horizons server data...

IF EXIST "Distant_Horizons_server_data" (
    XCOPY "Distant_Horizons_server_data" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up game downloads...

IF EXIST "downloads" (
    XCOPY "downloads" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up Polymer-based resource packs...

IF EXIST "polymer" (
    XCOPY "polymer" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your replays...

IF EXIST "replays" (
    XCOPY "replays" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your resource packs...

IF EXIST "resourcepacks" (
    XCOPY "resourcepacks" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your saves...

IF EXIST "saves" (
    XCOPY "saves" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your schematics...

IF EXIST "schematics" (
    XCOPY "schematics" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your screenshots...

IF EXIST "screenshots" (
    XCOPY "screenshots" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up server resource packs...

IF EXIST "server-resource-packs" (
    XCOPY "server-resource-packs" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your shaders packs...

IF EXIST "shaderpacks" (
    XCOPY "shaderpacks" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your skins...

IF EXIST "skin_overrides" (
    XCOPY "skin_overrides" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your waypoints...

IF EXIST "voxelmap" (
    XCOPY "voxelmap" "..\pull.tmp" /E /I /H /Y /Q >NUL
)

ECHO backing up your game options...

IF EXIST "options.txt" (
    MOVE /Y "options.txt" "..\pull.tmp\" >NUL
)

ECHO backing up your servers...

IF EXIST "servers.dat" (
    MOVE /Y "servers.dat" "..\pull.tmp\" >NUL
)

ECHO backing up your whitelist...

IF EXIST "whitelist.json" (
    MOVE /Y "whitelist.json" "..\pull.tmp\" >NUL
)

@REM RESET PHASE                                ---- ---- ---- ---- ---- ---- ---- ----

ECHO fetching latest version...
git.exe fetch origin main

ECHO resetting your game instance...
git.exe reset --hard origin/main

ECHO cleaning untracked files...
git.exe clean -fd

@REM RESTORE PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

ECHO restoring your game files...

ECHO restoring up your whitelist...

IF EXIST "..\pull.tmp\whitelist.json" (
    MOVE /Y "..\pull.tmp\whitelist.json" ".\" >NUL
)

ECHO restoring up your servers...

IF EXIST "..\pull.tmp\servers.dat" (
    MOVE /Y "..\pull.tmp\servers.dat" ".\" >NUL
)

ECHO restoring up your game options...

IF EXIST "..\pull.tmp\options.txt" (
    MOVE /Y "..\pull.tmp\options.txt" ".\" >NUL
)

ECHO restoring up your waypoints...

IF EXIST "..\pull.tmp\voxelmap" (
    XCOPY "..\pull.tmp\voxelmap" "voxelmap" /E /I /H /Y /Q >NUL
)

ECHO restoring up your skins...

IF EXIST "..\pull.tmp\skin_overrides" (
    XCOPY "..\pull.tmp\skin_overrides" "skin_overrides" /E /I /H /Y /Q >NUL
)

ECHO restoring up your shaders packs...

IF EXIST "..\pull.tmp\shaderpacks" (
    XCOPY "..\pull.tmp\shaderpacks" "shaderpacks" /E /I /H /Y /Q >NUL
)

ECHO restoring up server resource packs...

IF EXIST "..\pull.tmp\server-resource-packs" (
    XCOPY "..\pull.tmp\server-resource-packs" "server-resource-packs" /E /I /H /Y /Q >NUL
)

ECHO restoring up your screenshots...

IF EXIST "..\pull.tmp\screenshots" (
    XCOPY "..\pull.tmp\screenshots" "screenshots" /E /I /H /Y /Q >NUL
)

ECHO restoring up your schematics...

IF EXIST "..\pull.tmp\schematics" (
    XCOPY "..\pull.tmp\schematics" "schematics" /E /I /H /Y /Q >NUL
)

ECHO restoring up your saves...

IF EXIST "..\pull.tmp\saves" (
    XCOPY "..\pull.tmp\saves" "saves" /E /I /H /Y /Q >NUL
)

ECHO restoring up your resource packs...

IF EXIST "..\pull.tmp\resourcepacks" (
    XCOPY "..\pull.tmp\resourcepacks" "resourcepacks" /E /I /H /Y /Q >NUL
)

ECHO restoring up your replays...

IF EXIST "..\pull.tmp\replays" (
    XCOPY "..\pull.tmp\replays" "replays" /E /I /H /Y /Q >NUL
)

ECHO restoring up Polymer-based resource packs...

IF EXIST "..\pull.tmp\polymer" (
    XCOPY "..\pull.tmp\polymer" "polymer" /E /I /H /Y /Q >NUL
)

ECHO restoring up game downloads...

IF EXIST "..\pull.tmp\downloads" (
    XCOPY "..\pull.tmp\downloads" "downloads" /E /I /H /Y /Q >NUL
)

ECHO restoring up Distant Horizons server data...

IF EXIST "..\pull.tmp\Distant_Horizons_server_data" (
    XCOPY "..\pull.tmp\Distant_Horizons_server_data" "Distant_Horizons_server_data" /E /I /H /Y /Q >NUL
)

ECHO restoring up your default world configurations...

IF EXIST "..\pull.tmp\defaultconfigs" (
    XCOPY "..\pull.tmp\defaultconfigs" "defaultconfigs" /E /I /H /Y /Q >NUL
)

ECHO restoring up mod-based resources...

IF EXIST "..\pull.tmp\data" (
    XCOPY "..\pull.tmp\data" "data" /E /I /H /Y /Q >NUL
)

ECHO restoring up your mod configurations...

IF EXIST "..\pull.tmp\config" (
    XCOPY "..\pull.tmp\config" "config" /E /I /H /Y /Q >NUL
)

ECHO restoring up your capes...

IF EXIST "..\pull.tmp\cape_overrides" (
    XCOPY "..\pull.tmp\cape_overrides" "cape_overrides" /E /I /H /Y /Q >NUL
)

@REM CLEANUP PHASE                              ---- ---- ---- ---- ---- ---- ---- ----

ATTRIB -H "..\pull.tmp"
RMDIR /S /Q "..\pull.tmp"

@REM TWEAK PHASE                                ---- ---- ---- ---- ---- ---- ---- ----

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

@REM HIDE PHASE                                 ---- ---- ---- ---- ---- ---- ---- ----

FOR /R %%F IN (*
    ATTRIB +H "%%F"
)

FOR /R %%D IN (*.rem\ *.bak\) DO (
    ATTRIB +H "%%D"
)

ECHO all done.
PAUSE
