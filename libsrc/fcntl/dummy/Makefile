# $Id: Makefile,v 1.5 2002-10-22 19:15:05 dom Exp $

all:
	@echo ''
	@echo '---> Building NDOS library <---'
	@echo ''
	z80asm -d -ns -nm -Mo -x../../ndos @ndoslist

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
