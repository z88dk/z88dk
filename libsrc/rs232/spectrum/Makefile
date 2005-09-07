#
# $Id: Makefile,v 1.5 2005-09-07 01:30:34 aralbrec Exp $

all:
	@echo ''
	@echo '---> Building +3 RS232 library <---'
	@echo ''
	cd plus3 ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building Interface 1 RS232 library <---'
	@echo ''
	cd if1 ; $(MAKE) ; cd ..


clean:
	cd plus3 ; $(MAKE) clean ; cd ..
	cd if1 ; $(MAKE) clean ; cd ..
