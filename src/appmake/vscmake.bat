@echo off
rem $Id: vscmake.bat,v 1.5 2008-12-08 20:58:17 stefano Exp $

echo ********************
echo * Building appmake *
echo ********************
cl /Feappmake -DWIN32 -D _CRT_SECURE_NO_DEPRECATE *.c
move appmake.exe ..\..\bin
del *.obj
