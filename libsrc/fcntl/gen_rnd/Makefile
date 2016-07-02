#
# Makefile for generic DOS file support
#
# $Id: Makefile,v 1.3 2016-07-02 15:41:39 dom Exp $


include ../../Make.config


OBJECTS = open.o  close.o lseek.o read.o write.o readbyte.o writebyte.o remove.o rename.o fdtell.o

all: $(OUTPUT_DIRECTORY)/gendos.lib

$(OUTPUT_DIRECTORY)/gendos.lib: $(OBJECTS) genlist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gendos @genlist

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def $(OUTPUT_DIRECTORY)/gendos.lib
	

