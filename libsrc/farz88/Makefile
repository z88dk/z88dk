#
# Makefile for far malloc
#
# $Id: Makefile,v 1.11 2016-07-02 15:42:55 dom Exp $

include ../Make.config

all:
	cd strings ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings ; $(MAKE) clean ; cd ..
