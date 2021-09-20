@ECHO OFF
SET Z88DK=Z:\Apps\_code\z88dk-win32-1.99A
SET SRCDIR=%CD%
SET LIBDIR=%CD%\..\lib

SET PATH=%PATH%;%Z88DK%\BIN

REM Normally these reside inside the z88dk, but we hijack them and use our minimal local version
REM SET	OZFILES=%Z88DK%/LIB/
REM SET	ZCCCFG=%Z88DK%/LIB/CONFIG/
SET	OZFILES=%LIBDIR%
SET	ZCCCFG=%LIBDIR%\config

ECHO Compiling from dir "%SRCDIR%"...
%Z88DK%\bin\zcc +vtech -subtype=rom_autostart -v -I..\includes -openius.bin penius.c

REM Check if an error happened
IF ERRORLEVEL 1 GOTO:ERROR


ECHO File stats:
dir penius.bin

GOTO:NOERROR

:ERROR
ECHO.
ECHO ! Error happened!
ECHO.
ECHO 
GOTO:END

:NOERROR
ECHO.
ECHO Compilation OK.
ECHO.

:END