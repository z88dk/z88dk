@echo off
rem $Id: vscmake.bat,v 1.1 2015-01-27 05:40:16 aralbrec Exp $

echo ******************
echo * Building ticks *
echo ******************
cl /Feticks /Iregex *.c
move ticks.exe ..\..\bin
del *.obj
