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

git.exe stash push -m "config.tmp" -- config/ >NUL
git.exe stash push -u -m "mods.rem" >NUL

git.exe stash list | FINDSTR /I "mods.rem" >NUL
IF NOT ERRORLEVEL 1 (
    git.exe stash drop "stash^{/mods.rem}" >NUL
)

git.exe pull --rebase origin main

git.exe stash list | FINDSTR /I "config.tmp" >NUL
IF NOT ERRORLEVEL 1 (
    git.exe stash pop >NUL
)

FOR /R %%F IN (*.rem *.bak) DO (
    ATTRIB +H "%%F"
)

FOR /R %%D IN (*.rem\ *.bak\) DO (
    ATTRIB +H "%%D"
)

ECHO all done.

PAUSE
