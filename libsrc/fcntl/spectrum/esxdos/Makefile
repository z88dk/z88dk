#
# Makefile for ESXDOS file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../Make.config

OBJECTS = close.o open.o read.o readbyte.o write.o writebyte.o lseek.o

all: $(OUTPUT_DIRECTORY)/esxdos.lib

$(OUTPUT_DIRECTORY)/esxdos.lib: $(OBJECTS) esxdos.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/esxdos @esxdos.lst

.c.o:
	zcc +zx $(CFLAGS) -DESXDOS $*.c

clean:
	$(RM) *.o* zcc_opt.def $(OUTPUT_DIRECTORY)/esxdos.lib
	

