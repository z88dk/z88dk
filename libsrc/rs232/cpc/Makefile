#
# $Id: Makefile,v 1.2 2008-07-18 07:51:12 stefano Exp $

all:
	@echo ''
	@echo '---> Building CPC RS232 library (STI) <---'
	@echo ''
	cd sti ; $(MAKE) ; cd ..

	@echo ''
	@echo '---> Building CPC RS232 library (BOOSTER) <---'
	@echo ''
	cd booster ; $(MAKE) ; cd ..

clean:
	cd sti ; $(MAKE) clean ; cd ..
	cd booster ; $(MAKE) clean ; cd ..
