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

:exit
endlocal
