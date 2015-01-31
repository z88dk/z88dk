@echo off
rem $Id: gccmake.bat,v 1.2 2015-01-31 15:59:44 stefano Exp $

echo ****************
echo * Building zx7 *
echo ****************
gcc -o zx7 *.c
@rem gcc -ozx7 *.c
copy zx7.exe ..\..\bin
del zx7.exe
