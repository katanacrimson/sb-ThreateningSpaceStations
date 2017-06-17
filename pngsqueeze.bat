@echo off
setlocal enabledelayedexpansion enableextensions
call _smtkpath.bat
call "%smtkpath%\tool.pngsqueeze.bat" %cd%
endlocal & ( set smtkpath= )
pause