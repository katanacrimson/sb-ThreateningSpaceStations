@echo off
REM Starbound mod builder script.
REM @author Damian Bushong
setlocal enabledelayedexpansion enableextensions

node validate.js

if errorlevel 1 (
	echo FAIL: One or more JSON files failed to validate
	set iserror=1
	goto END
) else (
	echo JSON files considered valid
)

:END
pause
exit /b %iserror%
