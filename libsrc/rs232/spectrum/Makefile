#
# $Id: Makefile,v 1.4 2002-10-02 09:44:13 dom Exp $

all:
	@echo ''
	@echo '---> Building +3 RS232 library <---'
	@echo ''
	cd plus3 ; $(MAKE)
	@echo ''
	@echo '---> Building Interface 1 RS232 library <---'
	@echo ''
	cd if1 ; $(MAKE)


clean:
	cd plus3 ; $(MAKE) clean
	cd if1 ; $(MAKE) clean
