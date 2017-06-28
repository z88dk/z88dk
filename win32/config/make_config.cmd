@echo off
setlocal
set dir=%~dp0\..\..\src
pushd %dir%
set today=%date%
set today=%today:-=%
if not exist config.h (
  echo #define PREFIX "/usr/local/share/z88dk"	>  config.h
  echo #define UNIX 1							>> config.h
  echo #define EXEC_PREFIX ""					>> config.h
  echo #define Z88DK_VERSION "build-%today%"	>> config.h
  echo Created %dir%\config.h
) else (
  echo File exists %dir%\config.h
)
popd
endlocal
