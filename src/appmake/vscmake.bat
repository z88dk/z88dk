@echo off
rem $Id: vscmake.bat,v 1.3 2005-03-08 18:18:34 stefano Exp $

echo ********************
echo * Building appmake *
echo ********************
cl /Feappmake -D__WIN32__ *.c
move appmake.exe ..\..\bin
del *.obj
