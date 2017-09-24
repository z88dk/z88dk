setlocal

rem Build tools
if not exist bin mkdir bin
devenv win32\z88dk.sln /Build Release
if %errorlevel% neq 0 goto :error

if "%1"=="--nolib" goto :exit

rem Build library
set PATH=%CD%\bin;%PATH%
set Z80_OZFILES=%CD%\lib\
set ZCCCFG=%CD%\lib\config\

make -C %CD%\libsrc
if %errorlevel% neq 0 goto :error

make -C %CD%\libsrc install
if %errorlevel% neq 0 goto :error

make -C %CD%\libsrc\_DEVELOPMENT
if %errorlevel% neq 0 goto :error

rem z80asm_lib
make -C %CD%\src\z80asm Z80ASM=%CD%\bin\z80asm z80asm_lib
if %errorlevel% neq 0 goto :error

copy /y %CD%\src\z80asm\z80asm*.lib %CD%\lib\
if %errorlevel% neq 0 goto :error

goto :exit

:error
@echo Build script failed

:exit
endlocal
