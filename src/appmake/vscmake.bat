@echo off
rem $Id: vscmake.bat,v 1.4 2006-12-11 17:46:54 stefano Exp $

echo ********************
echo * Building appmake *
echo ********************
cl /Feappmake -D__WIN32__ -D _CRT_SECURE_NO_DEPRECATE *.c
move appmake.exe ..\..\bin
del *.obj
