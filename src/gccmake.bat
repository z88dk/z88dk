@echo off

rem $Id: gccmake.bat,v 1.3 2015-01-27 05:59:43 aralbrec Exp $

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
cd z80asm
call gccmake
cd ..
cd zcc
call gccmake
cd ..
cd zx7
call gccmake
cd ..
cd ticks
call gccmake
cd ..
goto :end

:nocompiler
cls
echo *
echo * 'gcc' not found
echo *

:end
