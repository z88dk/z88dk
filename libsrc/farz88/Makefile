#
# Makefile for far malloc
#
# $Id: Makefile,v 1.6 2002-10-22 19:15:02 dom Exp $


all:
	cd strings; $(MAKE)
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings; $(MAKE) clean
