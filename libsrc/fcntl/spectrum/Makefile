#
# $Id: Makefile,v 1.3 2005-03-01 17:50:36 stefano Exp $

all:
	@echo ''
	@echo '---> Building +3 File library <---'
	@echo ''
	cd plus3 ; $(MAKE)
	@echo ''
	@echo '---> Building ZX Microdrive File library <---'
	@echo ''
	cd microdrive ; $(MAKE)


clean:
	cd plus3 ; $(MAKE) clean
	cd microdrive ; $(MAKE) clean
