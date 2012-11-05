@echo off
rem $Id: gccmake.bat,v 1.1 2012-11-05 08:15:51 stefano Exp $

echo ****************
echo * Building cpp *
echo ****************
gcc -o zcpp *.c
copy zcpp.exe ..\..\bin
del zcpp.exe
