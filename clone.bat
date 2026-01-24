@ECHO OFF
TITLE %~n0
SETLOCAL ENABLEEXTENSIONS

CD /D "%~dp0"

WHERE git.exe >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO you have to install git bash.
    PAUSE
    EXIT /B 1
)

IF EXIST ".git" (
    ECHO repo exists. use pull.bat instead.
    PAUSE
    EXIT /B 1
)

:ASK

SET /P confirm="your data will be lost, continue?... (Y/n) >> "
IF /I "%confirm%"=="y" (
    GOTO MAIN
) ELSE {
    GOTO ASK
}

:MAIN

git.exe init
git.exe remote add origin https://github.com/dev2pew/lucky1218.git
git.exe fetch origin main
git.exe reset --hard origin/main

ECHO all done.
PAUSE
