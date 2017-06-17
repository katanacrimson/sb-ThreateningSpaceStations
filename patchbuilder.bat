@echo off
setlocal enabledelayedexpansion enableextensions
call _smtkpath.bat
call "%smtkpath%\tool.patchbuilder.bat" %cd%
endlocal & ( set smtkpath= )
pause