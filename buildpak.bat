@echo off
REM Starbound mod pak helper script.
REM 
REM @author katana <katana@odios.us>
REM @license MIT license <https://opensource.org/licenses/MIT>
REM 
REM Copyright 2017 Damian Bushong <katana@odios.us>
REM 
REM Permission is hereby granted, free of charge, to any person obtaining a 
REM copy of this software and associated documentation files (the "Software"), 
REM to deal in the Software without restriction, including without limitation 
REM the rights to use, copy, modify, merge, publish, distribute, sublicense, 
REM and/or sell copies of the Software, and to permit persons to whom the 
REM Software is furnished to do so, subject to the following conditions:
REM 
REM The above copyright notice and this permission notice shall be included 
REM in all copies or substantial portions of the Software.
REM
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
REM OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
REM THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
REM ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
REM OTHER DEALINGS IN THE SOFTWARE.

setlocal enabledelayedexpansion enableextensions

:BASE_CONFIG
REM // DO. NOT. MODIFY. THESE.
REM // SERIOUSLY.  HERE BE DRAGONS.
set iserror=0
set sbpacker=
set packerexe=asset_packer.exe
set rootdir=%~dp0
set argv=%*

:PAK_CONFIG
REM //////////////////////////////////////////////////////////////////////////////////
REM // configure the build script here
REM //////////////////////////////////////////////////////////////////////////////////
set pakname=MyMod.pak
set builddir=%rootdir%build
set srcdir=%rootdir%src

REM //////////////////////////////////////////////////////////////////////////////////
REM //
REM // end build script configuration.
REM // don't modify beyond this point unless you're sure you know what you're doing.
REM //
REM //////////////////////////////////////////////////////////////////////////////////

REM // allow overriding the pak name via argv
if(!argv!) NEQ () (
	set pakname=!argv!
)

REM /**
REM  *
REM  * Rough flow should be like this:
REM  *  - find asset_packer
REM  *     - check STARBOUND_PATH
REM  *     - then check system PATH
REM  *     - look for a Steam-based Starbound installation in Windows registry, then check there
REM  *     - look for a GOG-based Starbound installation, then check there
REM  *     - bail out and fail if not found
REM  *  - build mod's pak file (bailing out if that failed)
REM  *  - call post-pak hook if there is one (also bailing out if that failed)
REM  *  - terminate with exit code 0 if all worked fine
REM  *
REM  */

echo looking for asset_packer.exe...
REM // while most users will *not* have the STARBOUND_PATH env var defined, we'll still check it first.
REM // relying on it first it allows the end user to dictate where we should look in the event 
REM // that there's multiple installations.
REM // this can be extremely useful if developing for an unstable version, older version, etc.
if "%sbpacker%" == "" ( call :CHECK_STARBOUND_PATH )
if "%sbpacker%" == "" ( call :CHECK_PATH )
if "%sbpacker%" == "" ( call :CHECK_STEAM )
if "%sbpacker%" == "" ( call :CHECK_GOG )

REM // FAIL!
if "%sbpacker%" == "" (
	goto :NO_PACKER_FOUND
) else (
	goto MAKE_PAK
)
REM // in the event that reality decides to pull a fast one on us, make sure we exit.
goto END
exit %iserror%

:CHECK_STARBOUND_PATH
REM // we'll try seeing if the %STARBOUND_PATH% env variable is even set. if so, we're in luck.
echo checking STARBOUND_PATH for asset_packer...
if defined STARBOUND_PATH (
	if exist "%STARBOUND_PATH%\%packerexe%" (
		echo found asset_packer via STARBOUND_PATH.
		set sbpacker="%STARBOUND_PATH%\%packerexe%"
		exit /b
	)
	if exist "%STARBOUND_PATH%\win32\%packerexe%" (
		echo found asset_packer via STARBOUND_PATH.
		set sbpacker="%STARBOUND_PATH%\win32\%packerexe%"
		exit /b
	)

	echo found STARBOUND_PATH env var, but could not find asset_packer?!
	echo please verify that you're pointing STARBOUND_PATH to the correct location.
	echo now looking elsewhere...
) else (
	echo STARBOUND_PATH env var not set. looking elsewhere...
)

exit /b

:CHECK_PATH
REM // determine if asset_packer is in $PATH
echo checking system PATH for asset_packer...
@where /q %packerexe%
if errorlevel 0 (
	echo found asset_packer via system PATH.
	set sbpacker=%packerexe%
	exit /b
) else (
	echo asset_packer not in system PATH, looking elsewhere...
)

exit /b

:CHECK_STEAM
REM // we need to get the Steam installation directory for Starbound if it's installed from there.
REM // @note: 211820 is the SteamApp ID for Starbound.
echo checking for Steam installation of Starbound...
set steam_install=
@for /f "tokens=1,2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 211820" /v InstallLocation 2^>nul') do @if %%A==InstallLocation set steam_install=%%C
if not "%steam_install%" == "" (
	REM // it's installed via steam! let's make a sanity check that the asset_packer is there, though.
	REM // (this first case shouldn't happen - but let's just check anyways)
	if exist "%steam_install%\%packerexe%" (
		echo found asset_packer in Starbound Steam install directory.
		set sbpacker="%steam_install%\%packerexe%"
		exit /b
	)
	if exist "%steam_install%\win32\%packerexe%" (
		echo found asset_packer in Starbound Steam install directory.
		set sbpacker="%steam_install%\win32\%packerexe%"
		exit /b
	)

	echo found Starbound Steam installation location, but could not find asset_packer?!
	echo please verify that the Starbound Steam installation is not corrupt or outdated.
	echo now looking elsewhere...
) else (
	echo could not locate a Steam install of Starbound, looking elsewhere...
)

exit /b

:CHECK_GOG
REM // we need to get the GOG installation directory for Starbound if it's installed from there.
REM // @note: 1452598881 is the GOG gameID for Starbound.
REM // @todo: adapt for a 32bit system?
echo checking for gog installation of Starbound...
set gog_install=
@for /f "tokens=1,2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\1452598881" /v PATH 2^>nul') do @if %%A==PATH set gog_install=%%C
if not "%gog_install%" == "" (
	REM // it's installed via GOG! let's make a sanity check that the asset_packer is there, though.
	REM // (this first case shouldn't happen - but let's just check anyways)
	if exist "%gog_install%\%packerexe%" (
		echo found asset_packer in Starbound GOG install directory.
		set sbpacker="%gog_install%\%packerexe%"
		exit /b
	)
	if exist "%gog_install%\win32\%packerexe%" (
		echo found asset_packer in Starbound GOG install directory.
		set sbpacker="%gog_install%\win32\%packerexe%"
		exit /b
	)

	echo found Starbound GOG installation location, but could not find asset_packer?!
	echo please verify that the Starbound GOG installation is not corrupt or outdated.
	echo now looking elsewhere...
) else (
	echo could not locate a GOG install of Starbound, looking elsewhere...
)

exit /b

:NO_PACKER_FOUND
REM // welp. no packer found...we're doomed.
echo could not find the Starbound asset_packer.exe executable.
echo please ensure Starbound is installed, and if so, try setting the 
echo STARBOUND_PATH env variable to the root directory of your Starbound installation.
set iserror=1
goto END

:MAKE_PAK
REM // run the packer!

REM // quick sanity check...
if "%sbpacker%" == "" (
	goto NO_PACKER_FOUND
)

REM // in the event that you need to do special things before the pak is built 
REM // (move files around, move files out of the srcdir, etc.)
REM // you can use a pre-pak hook which will get passed the name of the pak file we're about to build.
REM // this hook should be a bat file named "prepakhook.bat" and be located in the root directory 
REM // for the mod, which should be the parent directory for this build script.
if exist "%rootdir%prepakhook.bat" (
	echo found pre-pak hook, executing...
	call "%rootdir%prepakhook.bat" "%pakname%"
	REM // if the pre-pak hook returned a non-zero error code, explode
	if errorlevel 1 (
		echo pre-pak hook returned a failure code.
		echo something might have went wrong.
		set iserror=1
		goto END
	)
	echo pre-pak hook complete
)

echo calling asset_packer to build mod pak file...
call "%sbpacker%" "%srcdir%" "%builddir%\%pakname%"
if errorlevel 1 (
	echo pak build appears to have failed. exiting...
	set iserror=1
	goto END
)

REM // in the event that you need to do special things after the pak is built 
REM // (if you want to rename the pak file, copy it, auto commit it, whatever)
REM // you can use a post-pak hook which will get passed the path to the built pak file.
REM // this hook should be a bat file named "postpakhook.bat" and be located in the root directory 
REM // for the mod, which should be the parent directory for this build script.
if exist "%rootdir%postpakhook.bat" (
	echo found post-pak hook, executing...
	call "%rootdir%postpakhook.bat" "%builddir%\%pakname%"
	REM // if the post-pak hook returned a non-zero error code, explode
	if errorlevel 1 (
		echo post-pak hook returned a failure code.
		echo something might have went wrong.
		set iserror=1
		goto END
	)
	echo post-pak hook complete
)

echo your built pak should be ready at: %builddir%\%pakname%

goto END

:END
REM // don't pause if we got an argv - we'll assume it's a script calling us.
if not (!argv!) NEQ () (
	pause
)
exit /b %iserror%