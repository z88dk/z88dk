@echo off
rem $Id: vscmake.bat,v 1.2 2005-03-08 18:18:35 stefano Exp $

echo *******************
echo * Building sccz80 *
echo *******************
cl /Fesccz80 *.c
move sccz80.exe ..\..\bin
del *.obj
