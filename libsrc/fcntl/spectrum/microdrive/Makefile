#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $


include ../../../Make.config

OBJECTS = open.o close.o readbyte.o remove.o rename.o lseek.o fdtell.o

all: $(OUTPUT_DIRECTORY)/zxmdv.lib


$(OUTPUT_DIRECTORY)/zxmdv.lib: $(OBJECTS) mdvlist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

