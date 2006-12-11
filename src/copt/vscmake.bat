@echo off
rem $Id: vscmake.bat,v 1.4 2006-12-11 17:46:54 stefano Exp $

echo *****************
echo * Building copt *
echo *****************
cl /Fecopt /Iregex -DUSE_REGEXP -DLOCAL_REGEXP -D _CRT_SECURE_NO_DEPRECATE -D _CRT_NONSTDC_NO_DEPRECATE *.c regex\reg*.c
move copt.exe ..\..\bin
del *.obj
