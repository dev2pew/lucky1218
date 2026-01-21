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

IF EXIST ".git" (
    ECHO you already cloned the repo.
    PAUSE
    EXIT /B 1
)

:ASK

SET /P confirm="are you sure you want to delete all and clone... (Y/n) >> "
IF /I "%confirm%"=="y" (
    GOTO MAIN
) ELSE {
    GOTO ASK
}

:MAIN

RMDIR /S /Q "config"
RMDIR /S /Q "mods"
RMDIR /S /Q "resourcepacks"
RMDIR /S /Q "shaderpacks"

DEL "options.txt"
DEL "clean.bat"
DEL "winevent.ps1"

git.exe clone https://github.com/dev2pew/lucky1218.git .

PAUSE
