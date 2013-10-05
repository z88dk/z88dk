@echo off
rem $Id: gccmake.bat,v 1.17 2013-10-05 10:54:35 pauloscustodio Exp $

echo *******************
echo * Building z80asm *
echo *******************
del *.o
gcc -c -o asmdrctv.o             asmdrctv.c
gcc -c -o class.o                class.c
gcc -c -o codearea.o             codearea.c
gcc -c -o deffile.o              deffile.c
gcc -c -o die.o                  die.c
gcc -c -o dynstr.o               dynstr.c
gcc -c -o errors.o               errors.c
gcc -c -o except.o               except.c
gcc -c -o exprprsr.o             exprprsr.c
gcc -c -o file.o                 file.c
gcc -c -o hist.o                 hist.c
gcc -c -o ldinstr.o              ldinstr.c
gcc -c -o listfile.o             listfile.c
gcc -c -o mapfile.o              mapfile.c
gcc -c -o memalloc.o             memalloc.c
gcc -c -o model.o                model.c
gcc -c -o model_symref.o         model_symref.c
gcc -c -o modlink.o              modlink.c
gcc -c -o module.o               module.c
gcc -c -o objfile.o              objfile.c
gcc -c -o options.o              options.c
gcc -c -o parse.o                parse.c
gcc -c -o prsident.o             prsident.c
gcc -c -o prsline.o              prsline.c
gcc -c -o safestr.o              safestr.c
gcc -c -o scan.o                 scan.c
gcc -c -o srcfile.o              srcfile.c
gcc -c -o strhash.o              strhash.c
gcc -c -o strpool.o              strpool.c
gcc -c -o strutil.o              strutil.c
gcc -c -o sym.o                  sym.c
gcc -c -o symref.o               symref.c
gcc -c -o symtab.o               symtab.c
gcc -c -o z80asm.o               z80asm.c
gcc -c -o z80instr.o             z80instr.c
gcc -c -o z80pass.o              z80pass.c
gcc -c -o init.o                 init.c
gcc -c -o init_obj.o             init_obj.c
gcc -c -o init_obj_file.o        init_obj_file.c
gcc -c -o init_obj_options.o     init_obj_options.c
gcc -o z80asm.exe *.o
copy z80asm.exe ..\..\bin
del z80asm.exe
