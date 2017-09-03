#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.20 2016-07-02 15:42:55 dom Exp $

include ../Make.config

all: $(OUTPUT_DIRECTORY)/malloc.lib $(OUTPUT_DIRECTORY)/malloc_rcm.lib


$(OUTPUT_DIRECTORY)/malloc.lib: $(wildcard *.asm) malllist
	$(RM) *.o
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/malloc @malllist

$(OUTPUT_DIRECTORY)/malloc_rcm.lib: $(wildcard *.asm) malllist
	$(RM) *.o
	$(LIBLINKER) --cpu=r2k -x$(OUTPUT_DIRECTORY)/malloc_rcm @malllist

clean:
	cd strings ; $(RM) *.o* ; cd ..
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 

