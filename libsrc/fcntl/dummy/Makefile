# $Id: Makefile,v 1.4 2002-04-22 08:25:23 dom Exp $

all:
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	z80asm -d -ns -nm -Mo -x../../ndos @ndoslist

clean:
	rm -f  *.sym *.map zcc_opt.def *.o*
