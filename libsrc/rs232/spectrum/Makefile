#
# $Id: Makefile,v 1.3 2002-07-15 15:34:07 dom Exp $

all:
	@echo ''
	@echo '---> Building +3 RS232 library <---'
	@echo ''
	cd plus3 ; $(MAKE)
	@echo ''
	@echo '---> Building Interface 1 RS232 library <---'
	@echo ''
	cd if1 ; make


clean:
	cd plus3 ; $(MAKE) clean
	cd if1 ; $(MAKE) clean
