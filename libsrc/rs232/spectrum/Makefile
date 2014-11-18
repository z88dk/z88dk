#
# $Id: Makefile,v 1.6 2014-11-18 07:06:41 stefano Exp $

all:
	@echo ''
	@echo '---> Building ZX Plus RS232 library <---'
	@echo ''
	cd plus3 ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building Interface 1 RS232 library <---'
	@echo ''
	cd if1 ; $(MAKE) ; cd ..


clean:
	cd plus3 ; $(MAKE) clean ; cd ..
	cd if1 ; $(MAKE) clean ; cd ..
