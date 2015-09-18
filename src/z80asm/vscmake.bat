@echo off

echo *******************
echo * Building z80asm *
echo *******************
cl /Fez80asm -D _CRT_SECURE_NO_DEPRECATE *.c -I.\lib lib\*.c
move z80asm.exe ..\..\bin
del *.obj
