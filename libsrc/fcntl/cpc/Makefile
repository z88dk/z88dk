#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2016-07-02 15:41:38 dom Exp $

include ../../Make.config

CFILES = \
	close.c      \
	cpc_openin.c \
	cpc_openout.c \
	open.c       \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   

OBJECTS = $(CFILES:.c=.o)

all: $(OUTPUT_DIRECTORY)/cpcfs.lib

$(OUTPUT_DIRECTORY)/cpcfs.lib: $(OBJECTS) $(wildcard *.asm) cpcfs.lst
	@echo ''
	@echo '--- Building Amstrad CPC fcntl Library ---'
	@echo ''
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcfs @cpcfs.lst


.c.o:
	zcc +cpc $(CFLAGS)  -D__CPC__  $*.c


clean:
	$(RM)  *.sym *.map zcc_opt.def *.o* *.i $(AFILES) $(OUTPUT_DIRECTORY)/cpcfs.lib
