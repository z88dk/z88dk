@echo off
rem $Id: gccmake.bat,v 1.28 2013-12-26 23:42:27 pauloscustodio Exp $

echo *******************
echo * Building z80asm *
echo *******************
del *.o lib\*.o
gcc -c -o asmdrctv.o             asmdrctv.c
gcc -c -o codearea.o             codearea.c
gcc -c -o deffile.o              deffile.c
gcc -c -o dynstr.o               dynstr.c
gcc -c -o errors.o               errors.c
gcc -c -o exprprsr.o             exprprsr.c
gcc -c -o file.o                 file.c
gcc -c -o hist.o                 hist.c
gcc -c -o ldinstr.o              ldinstr.c
gcc -c -o lib/class.o            lib/class.c
gcc -c -o lib/die.o              lib/die.c
gcc -c -o lib/except.o           lib/except.c
gcc -c -o lib/strhash.o          lib/strhash.c
gcc -c -o lib/strlist.o          lib/strlist.c
gcc -c -o lib/strpool.o          lib/strpool.c
gcc -c -o lib/strutil.o          lib/strutil.c
gcc -c -o lib/xmalloc.o          lib/xmalloc.c
gcc -c -o listfile.o             listfile.c
gcc -c -o mapfile.o              mapfile.c
gcc -c -o model.o                model.c
gcc -c -o model_symref.o         model_symref.c
gcc -c -o modlink.o              modlink.c
gcc -c -o module.o               module.c
gcc -c -o objfile.o              objfile.c
gcc -c -o options.o              options.c
gcc -c -o prsident.o             prsident.c
gcc -c -o prsline.o              prsline.c
gcc -c -o safestr.o              safestr.c
gcc -c -o scan.o                 scan.c
gcc -c -o srcfile.o              srcfile.c
gcc -c -o sym.o                  sym.c
gcc -c -o symref.o               symref.c
gcc -c -o symtab.o               symtab.c
gcc -c -o z80asm.o               z80asm.c
gcc -c -o z80instr.o             z80instr.c
gcc -c -o z80pass.o              z80pass.c
gcc -o z80asm.exe *.o lib\*.o
copy z80asm.exe ..\..\bin
del z80asm.exe
