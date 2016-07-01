@echo off

rem $Id: vscmake.bat,v 1.10 2016-07-01 15:10:47 stefano Exp $

cl
if %ERRORLEVEL% == 0 goto :build

goto :nocompiler

:build
cls

echo **************************
echo * Building with Visual C *
echo **************************
echo *
echo *

echo #define WIN32 1 > config.h
echo #define Z88DK_VERSION "[VC_custom]" >> config.h

md ..\bin
cd appmake
call vscmake
cd ..
cd copt
call vscmake
cd ..
cd cpp
call vscmake
cd ..
cd sccz80
call vscmake
cd ..
cd ticks
call vscmake
cd ..
cd z80asm
call vscmake
cd ..
cd zcc
call vscmake
cd ..
cd scanner
call vscmake
cd ..
cd zx7
call vscmake
cd ..
echo **************************
echo * Building support tools *
echo **************************
echo *
cd ..
cd support
cd ar
call vscmake
cd ..
rem cd graphics
rem call vscmake
rem cd ..
echo *
echo *******************
echo * Compilation end *
echo *******************
cd ..
cd src
goto :end

:nocompiler
cls
echo *
echo * 'cl' not found
echo *
echo * Visual Studio is missing or environment isn't set correctly
echo * please use the "Visual Studio command prompt" shortcut 
echo * or execute vcvars32.bat / vcvarsall.bat
echo *

:end
