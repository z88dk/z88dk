@echo off
rem $Id: vscmake.bat,v 1.2 2005-03-08 18:18:35 stefano Exp $

echo ****************
echo * Building cpp *
echo ****************
cl /Fezcpp *.c
move zcpp.exe ..\..\bin
del *.obj
