@echo off
rem $Id: vscmake.bat,v 1.2 2015-01-31 15:59:44 stefano Exp $

echo ****************
echo * Building zx7 *
echo ****************
cl /Fezx7 /Iregex *.c
move zx7.exe ..\..\bin
del *.obj
