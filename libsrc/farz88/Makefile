#
# Makefile for far malloc
#
# $Id: Makefile,v 1.7 2005-09-07 01:30:33 aralbrec Exp $


all:
	cd strings ; $(MAKE) ; cd ..
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst

clean:
	$(RM) *.o *~
	cd strings ; $(MAKE) clean ; cd ..
