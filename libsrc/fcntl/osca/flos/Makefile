#
# Makefile for OSCA FLOS file support
#
# $Id: Makefile,v 1.7 2016-07-02 15:41:39 dom Exp $


include ../../../Make.config

OBJECTS = open.o close.o read.o readbyte.o write.o writebyte.o remove.o rename.o mkdir.o lseek.o fdtell.o

all: $(OUTPUT_DIRECTORY)/flosdos.lib

$(OUTPUT_DIRECTORY)/flosdos.lib: $(OBJECTS) floslist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/flosdos @floslist

%.o: %.c
	zcc +osca $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

