@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

WHERE git.exe >NUL 2>&1
IF ERRORLEVEL 1 (
    ECHO you have to install git bash.
    PAUSE
    EXIT /B 1
)

IF NOT EXIST ".git" (
    ECHO you need to clone mod pack first.
    PAUSE
    EXIT /B 1
)

:ASK

SET /P confirm="are you sure you want to update... (Y/n) >> "
IF /I "%confirm%"=="y" (
    GOTO MAIN
) ELSE {
    GOTO ASK
}

:MAIN

git.exe merge --abort >NUL 2>&1
git.exe rebase --abort >NUL 2>&1

IF EXIST ".git\index.lock" (
    DEL /F /Q ".git\index.lock"
)

git.exe reset --hard HEAD >NUL
git.exe clean -fd >NUL
git.exe stash push -m "config.tmp" -- config/ >NUL
git.exe stash push -u -m "mods.rem" >NUL

git.exe stash list | findstr.exe /I "mods.rem" >NUL

IF NOT %ERRORLEVEL% 1 (
    git.exe stash drop "stash^{/mods.rem}" >NUL
)

git.exe pull --rebase origin main

IF %ERRORLEVEL% 1 (
    ECHO pull failed - likely a conflict that could not be auto-resolved.
    ECHO please resolve the conflict manually, then re-run the script.
    PAUSE
    EXIT /B 1
)

git.exe stash list | FINDSTR /I "config.tmp" >NUL

IF NOT %ERRORLEVEL% 1 (
    git.exe stash pop >NUL
)

FOR /R %%F IN (*
    ATTRIB +H "%%F"
)

FOR /R %%D IN (*.rem\ *.bak\) DO (
    ATTRIB +H "%%D"
)

ECHO all done.

PAUSE
