#
# Wahey, a messed up makefile for building libraries!
#



all: itou.o utoi.o printf.o sprintf.o fprintf.o vfprintf_comp.o vsprintf.o \
     scanf.o sscanf.o fscanf.o vfscanf.o vsscanf.o vfprintf_fp.o

.c.o:
	zcc -vn -Wn43 -make-lib $*.c


clean:
	rm -f *.err *.o* *.sym *.map zcc_opt.def
