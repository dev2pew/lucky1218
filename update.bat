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

git.exe stash push -m "local settings"
git.exe pull origin main
git.exe stash pop

ECHO all done.

PAUSE
