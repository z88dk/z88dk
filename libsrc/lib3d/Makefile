#
# Makefile for lib3d
#
# $Id: Makefile,v 1.1 2009-04-10 12:47:42 stefano Exp $


include ../Make.config

all:	
	zcc +test $(CFLAGS) *.c
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/lib3d @lib3d.lst

clean:
	$(RM) *.o* zcc_opt.def
