@echo off
setlocal enabledelayedexpansion enableextensions
call _smtkpath.bat
call "%smtkpath%\tool.jsonvalidate.bat" %cd%
endlocal & ( set smtkpath= )
pause