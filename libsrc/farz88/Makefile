#
# Makefile for far malloc
#
# $Id: Makefile,v 1.4 2001-04-18 14:59:40 stefano Exp $


all:
	cd strings; make
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst

clean:
	rm -f *.o *~
	cd strings; make clean
