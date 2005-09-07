#
# $Id: Makefile,v 1.4 2005-09-07 01:30:33 aralbrec Exp $

all:
	@echo ''
	@echo '---> Building +3 File library <---'
	@echo ''
	cd plus3 ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building ZX Microdrive File library <---'
	@echo ''
	cd microdrive ; $(MAKE)


clean:
	cd plus3 ; $(MAKE) clean ; cd ..
	cd microdrive ; $(MAKE) clean ; cd ..
