#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile $


include ../../../../Make.config

OBJECTS = open.o close.o read.o write.o readbyte.o writebyte.o remove.o rename.o lseek.o fdtell.o

all: $(OUTPUT_DIRECTORY)/zxmdv.lib


$(OUTPUT_DIRECTORY)/zxmdv.lib: $(OBJECTS) mdvlist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	$(ZCC) +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

