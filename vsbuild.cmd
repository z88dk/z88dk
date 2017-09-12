setlocal

rem Build tools
if not exist bin mkdir bin
devenv win32\z88dk.sln /Build Release

if "%1"=="--nolib" goto :exit

rem Build library
set PATH=%CD%\bin;%PATH%
set Z80_OZFILES=%CD%\lib\
set ZCCCFG=%CD%\lib\config\

make -C %CD%\libsrc
make -C %CD%\libsrc install
make -C %CD%\libsrc\_DEVELOPMENT

rem z80asm_lib
make -C %CD%\src\z80asm Z80ASM=%CD%\bin\z80asm z80asm_lib
copy /y %CD%\src\z80asm\z80asm*.lib %CD%\lib\

:exit
endlocal
