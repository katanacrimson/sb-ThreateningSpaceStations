@echo off
REM Starbound mod builder script.
REM @author Damian Bushong
setlocal enabledelayedexpansion enableextensions

node pngsqueeze.js

if errorlevel 1 (
	echo FAIL: Something broke trying to run sb-pngsqueeze
	set iserror=1
	goto END
) else (
	echo PNG files crushed down successfully.
)

:END
pause
exit /b %iserror%
