#
# Makefile for far malloc
#
# $Id: Makefile,v 1.8 2006-06-18 14:55:43 dom Exp $

include ../Make.config

all:
	cd strings ; $(MAKE) ; cd ..
	$(LIBLINKER) -x../farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings ; $(MAKE) clean ; cd ..
