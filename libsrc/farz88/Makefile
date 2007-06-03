#
# Makefile for far malloc
#
# $Id: Makefile,v 1.9 2007-06-03 15:13:05 stefano Exp $

include ../Make.config

all:
	cd strings ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings ; $(MAKE) clean ; cd ..
