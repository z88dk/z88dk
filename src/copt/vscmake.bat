@echo off
rem $Id: vscmake.bat,v 1.3 2005-03-08 18:18:35 stefano Exp $

echo *****************
echo * Building copt *
echo *****************
cl /Fecopt /Iregex -DUSE_REGEXP -DLOCAL_REGEXP *.c regex\reg*.c
move copt.exe ..\..\bin
del *.obj
