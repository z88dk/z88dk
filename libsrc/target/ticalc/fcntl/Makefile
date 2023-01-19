#
# Makefile for TI83+ file support
#
# $Id: Makefile $


include ../../../Make.config

OBJECTS = ticalc_fcntl.o open.o close.o read.o write.o readbyte.o writebyte.o remove.o rename.o lseek.o fdtell.o

all: $(OBJECTS)

.c.o:
	$(ZCC) +ti8x $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
