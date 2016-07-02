#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../Make.config

OBJECTS = close.o fabandon.o findhand.o freehand.o open.o \
	read.o readbyte.o write.o writebyte.o

all: $(OUTPUT_DIRECTORY)/p3.lib

$(OUTPUT_DIRECTORY)/p3.lib: $(OBJECTS) p3list $(wildcard *.asm)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/p3 @p3list

.c.o:
	zcc +zx $(CFLAGS) -DPLUS3 $*.c

clean:
	$(RM) *.o* zcc_opt.def $(OUTPUT_DIRECTORY)/p3.lib
	

