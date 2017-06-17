@echo off
setlocal enabledelayedexpansion enableextensions
REM
REM SMTk - Starbound Mod Toolkit
REM
REM This is a configuration file so that you, the end user, can change SMTk to suit
REM   your needs.
REM Please be sure to thorougly read the comments with each config directive.
REM
REM //////////////////////////////////////////////////////////////////////////////////
REM // configure SMTk below
REM //////////////////////////////////////////////////////////////////////////////////

REM //
REM // the filename to use of the mod's pake file
REM //
set pakname=ThreateningSpaceStations.pak

REM // -------------------------------------------------------------------------------
REM // feature toggles for SMTk
REM // valid values are 0 and 1
REM // -------------------------------------------------------------------------------

REM //
REM // enable/disable the patchbuilder tool
REM //
set BUILD_USE_PATCHBUILDER=1

REM //
REM // enable/disable PNG asset compression
REM //
set BUILD_USE_PNGSQUEEZE=0

REM //
REM // enable/disable JSON validation
REM //
set BUILD_USE_JSONVALIDATE=1

REM //////////////////////////////////////////////////////////////////////////////////
REM //
REM // advanced SMTk configuration.
REM // advanced users only.
REM //
REM //////////////////////////////////////////////////////////////////////////////////

REM //
REM // prevent the prepakhook from running (even if it exists)
REM //
REM set BUILD_USE_PREPAKHOOK=0
REM //
REM // prevent the postpakhook from running (even if it exists)
REM //
REM set BUILD_USE_POSTPAKHOOK=0

REM // -------------------------------------------------------------------------------
REM // directory paths for SMTk
REM // values must be valid directory paths without trailing slashes
REM // -------------------------------------------------------------------------------

REM //
REM // the directory to build patches from (should contain modified copies of Starbound asset files)
REM //
set patchbasedir=

REM //
REM // the directory to write built pak files to
REM //
set builddir=

REM //
REM // the directory containing the mod source files to build the mod from
REM //
set srcdir=

REM //
REM // the directory containing the unpacked Starbound asset files
REM //
set sbassetsdir=

REM //////////////////////////////////////////////////////////////////////////////////
REM //
REM // end SMTk configuration.
REM // don't modify beyond this point unless you're sure you know what you're doing.
REM //
REM //////////////////////////////////////////////////////////////////////////////////
endlocal & (
	set _pakname=%pakname%

	set _patchbasedir=%patchbasedir%
	set _builddir=%builddir%
	set _srcdir=%srcdir%
	set _sbassetsdir=%sbassetsdir%

	set _BUILD_USE_PNGSQUEEZE=%BUILD_USE_PNGSQUEEZE%
	set _BUILD_USE_JSONVALIDATE=%BUILD_USE_JSONVALIDATE%
	set _BUILD_USE_PATCHBUILDER=%BUILD_USE_PATCHBUILDER%
	set _BUILD_USE_PREPAKHOOK=%BUILD_USE_PREPAKHOOK%
	set _BUILD_USE_POSTPAKHOOK=%BUILD_USE_POSTPAKHOOK%
)