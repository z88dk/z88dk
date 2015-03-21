@echo off
rem $Id: vscmake.bat,v 1.5 2015-03-21 00:51:29 aralbrec Exp $

echo *****************
echo * Building copt *
echo *****************
cl /Fecopt /I. -DLOCAL_REGEXP -D _CRT_SECURE_NO_DEPRECATE -D _CRT_NONSTDC_NO_DEPRECATE *.c regex\reg*.c
move copt.exe ..\..\bin
del *.obj
