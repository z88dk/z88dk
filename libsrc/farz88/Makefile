#
# Makefile for far malloc
#
# $Id: Makefile,v 1.10 2007-06-04 05:54:11 stefano Exp $

include ../Make.config

all:
	cd strings ; $(MAKE) ; cd ..
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings ; $(MAKE) clean ; cd ..
