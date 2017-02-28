@echo off
rem $Id: vscmake.bat,v 1.4 2009-07-09 17:21:19 stefano Exp $

echo ****************
echo * Building zcc *
echo ****************
cl /Fezcc -DMSDOS -D WIN32 -D _CRT_SECURE_NO_DEPRECATE -DLOCAL_REGEXP -I..\copt *.c ..\copt\regex\*.c
move zcc.exe ..\..\bin
del *.obj
