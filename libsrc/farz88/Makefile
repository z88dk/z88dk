#
# Makefile for far malloc
#
# $Id: Makefile,v 1.5 2002-07-15 15:34:06 dom Exp $


all:
	cd strings; $(MAKE)
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst

clean:
	rm -f *.o *~
	cd strings; $(MAKE) clean
