@echo off
rem $Id: gccmake.bat,v 1.1 2012-11-05 08:15:51 stefano Exp $

echo ****************
echo * Building zcc *
echo ****************
@rem  /Fezcc -DMSDOS -D WIN32 -D _CRT_SECURE_NO_DEPRECATE *.c
gcc -o zcc -D_WIN32 -DLOCAL_REGEXP -I../copt *.c ../copt/regex/*.c
copy zcc.exe ..\..\bin
del zcc.exe
