@echo off
rem $Id: vscmake.bat,v 1.1 2015-01-23 07:07:32 stefano Exp $

echo ****************
echo * Building zx7 *
echo ****************
cl /Fezx7 /Iregex *.c
move zx7.exe ..\..\bin
del *.obj
