@echo off
fsutil dirty query %systemdrive% >nul || (
powershell "start-process -filepath '%0' -verb runas"
exit
)
IF EXIST "%~dp0%~n0.ps1" (
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -File "%~dp0%~n0.ps1" &exit 0
) ELSE (
 echo.
 echo Could not find %~dp0%~n0.ps1
 echo.
 echo Make sure the file "%~n0.bat" and "%~n0.ps1" exists in the same folder,
 echo along with "kuso2auth" folder.
 echo.
 pause
)
