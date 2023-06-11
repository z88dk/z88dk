@echo off
setlocal
set dir=%~dp0\..\..\src
pushd %dir%
set today=%date%
set today=%today:-=%
rem if not exist config.h (
  echo #define PREFIX "c:/z88dk"	>  config.h
  echo #define BINDIR "c:/z88dk/bin"	>> config.h
  echo #define Z88DK_VERSION "MSC build-%today%"	>> config.h
  echo Created %dir%\config.h
rem ) else (
rem   echo File exists %dir%\config.h
rem )
popd
endlocal
