#
# $Id: Makefile,v 1.6 2007-10-02 14:13:48 stefano Exp $

all:
	@echo ''
	@echo '---> Building +3 File library <---'
	@echo ''
	cd plus3 ; $(MAKE) ; cd ..
	@echo ''
	@echo '---> Building ZX Microdrive File library <---'
	@echo ''
	cd microdrive ; $(MAKE)
	@echo ''
	@echo '---> Building ZX BASIC driver library <---'
	@echo ''
	cd zxbasdrv ; $(MAKE)


clean:
	cd plus3 ; $(MAKE) clean ; cd ..
	cd microdrive ; $(MAKE) clean ; cd ..
	cd zxbasdrv ; $(MAKE) clean ; cd ..
