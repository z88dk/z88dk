#
# Makefile for lib3d
#
# $Id: Makefile,v 1.2 2016-07-02 15:42:55 dom Exp $


include ../Make.config

all:	
	zcc +test $(CFLAGS) *.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/lib3d @lib3d.lst

clean:
	$(RM) *.o* zcc_opt.def
