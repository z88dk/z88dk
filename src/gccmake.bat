@echo off

rem $Id: gccmake.bat,v 1.8 2016-07-01 15:10:47 stefano Exp $

gcc
if %ERRORLEVEL% == 1 goto :build

goto :nocompiler

:build
cls

echo *********************
echo * Building with GCC *
echo *********************
echo *
echo *

set cygwin=nodosfilewarning
echo #define WIN32 1 > config.h
echo #define Z88DK_VERSION "[GCC_custom]" >> config.h

md ..\bin
cd appmake
call gccmake
cd ..
cd copt
call gccmake
cd ..
cd cpp
call gccmake
cd ..
cd sccz80
call gccmake
cd ..
cd ticks
call gccmake
cd ..
cd z80asm
call gccmake
cd ..
cd zcc
call gccmake
cd ..
cd zx7
call gccmake
cd ..
cd scanner
call gccmake
cd ..
echo **************************
echo * Building support tools *
echo **************************
echo *
cd ..
cd support
cd ar
call gccmake
cd ..
rem cd graphics
rem call gccmake
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
echo * 'gcc' not found
echo *

:end
