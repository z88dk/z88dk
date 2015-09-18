@echo off

echo *******************
echo * Building z80asm *
echo *******************
gcc -oz80asm.exe -I.\lib -Wall *.c lib\*.c
move z80asm.exe ..\..\bin
del *.o
