@echo off
setlocal enabledelayedexpansion enableextensions
set iserror=0
call _smtkpath.bat
call "%smtkpath%\smtk.bat" %cd%
if errorlevel 1 (
  set iserror=1
)
endlocal & (
  set smtkpath=
  set _iserror=%iserror%
)
pause
exit /b %_iserror%
