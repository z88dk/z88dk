@ECHO OFF
:CLEAN
ECHO Cleaning...
DEL penius.bin
ECHO.
ECHO.

:COMPILE
ECHO Compiling...
CALL penius_compile.bat
ECHO.
ECHO.

IF EXIST penius.bin GOTO:EMU
GOTO:ERROR

:EMU
ECHO Running in emulator...
CALL penius_emu.bat
GOTO:END

:ERROR
ECHO Not running due to error.
GOTO:END

:END